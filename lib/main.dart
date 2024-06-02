import 'dart:convert';
import 'package:flutter/material.dart';
import 'ProfilePage.dart';
import 'SettingsPage.dart';
import 'NotificationsPage.dart';
import 'excel_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'CustomLineChart.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAC40 Predictor',
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
          secondary: Colors.white,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> favoris = [];
  List<String> suggestions = [];
  OverlayEntry? overlayEntry;
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadFavorites();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        removeOverlay();
      }
    });
  }

  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favoris');
    if (savedFavorites != null) {
      setState(() {
        favoris.addAll(savedFavorites);
      });
    }
  }

  void updateSuggestions(String query) async {
    List<String> allCompanies = await ExcelService.getAllCompanies();
    List<String> newSuggestions = allCompanies
        .where((company) => company.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      suggestions = newSuggestions;
    });
    removeOverlay();
    overlayEntry = createOverlayEntry();
    Overlay.of(context)!.insert(overlayEntry!);
  }

  void removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  OverlayEntry createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: Material(
            elevation: 4.0,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(suggestions[index]),
                  onTap: () {
                    removeOverlay();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FavoriDetailDialog(entreprise: suggestions[index]);
                      },
                    );
                    fetchPredictions(suggestions[index]);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> fetchPredictions(String entrepriseName) async {
    print('Fetching predictions for $entrepriseName');
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/predict'), // Mettez votre adresse IP et votre port
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'entreprise_name': entrepriseName,
        }),
      );

      if (response.statusCode == 200) {
        print('Response received: ${response.body}');
        Map<String, dynamic> data = json.decode(response.body);
        double highPrediction = data['high_prediction'];
        double lowPrediction = data['low_prediction'];

        // Mettre à jour le dialogue avec les prédictions
        Navigator.of(context).pop(); // Fermer le dialogue initial
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return FavoriDetailDialog(
              entreprise: entrepriseName,
              highPrediction: highPrediction,
              lowPrediction: lowPrediction,
            );
          },
        );
      } else {
        print('Erreur lors de la récupération des prédictions: ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CAC40 Predictor'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProfileDialog();
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NotificationsDialog();
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SettingsDialog(prefs);
                },
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 500.0), // Réduire la largeur de la barre de recherche
            child: CompositedTransformTarget(
              link: _layerLink,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                cursorColor: Theme.of(context).colorScheme.secondary,
                onChanged: updateSuggestions,
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Mes actions',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Voir mes actions'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 200,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Favoris',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: favoris.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          favoris[index],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return FavoriDetailDialog(entreprise: favoris[index]);
                            },
                          );
                          fetchPredictions(favoris[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Welcome',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Container(
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[900],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'CAC 40',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          CustomLineChart(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60.0,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.account_circle),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ProfileDialog();
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.notifications),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return NotificationsDialog();
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  color: Theme.of(context).colorScheme.secondary,
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SettingsDialog(prefs);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Boîte de dialogue affichant les détails du favori cliqué
class FavoriDetailDialog extends StatefulWidget {
  final String entreprise;
  final double? highPrediction;
  final double? lowPrediction;

  FavoriDetailDialog({
    required this.entreprise,
    this.highPrediction,
    this.lowPrediction,
  });

  @override
  _FavoriDetailDialogState createState() => _FavoriDetailDialogState();
}

class _FavoriDetailDialogState extends State<FavoriDetailDialog> {
  double? highPrediction;
  double? lowPrediction;
  List<FlSpot> historicalData = [];

  @override
  void initState() {
    super.initState();
    highPrediction = widget.highPrediction;
    lowPrediction = widget.lowPrediction;
    fetchHistoricalData();
  }

  Future<void> fetchHistoricalData() async {
    // Remplacez ceci par la logique pour récupérer les données historiques
    // Ici, nous utilisons des données factices pour l'exemple
    final data = await http.get(Uri.parse('http://127.0.0.1:5000/historical?entreprise=${widget.entreprise}'));

    if (data.statusCode == 200) {
      List<dynamic> jsonData = json.decode(data.body);
      setState(() {
        historicalData = jsonData
            .asMap()
            .entries
            .map((entry) => FlSpot(entry.key.toDouble(), entry.value['Close'].toDouble()))
            .toList();
      });
    } else {
      print('Erreur lors de la récupération des données historiques: ${data.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0,
      backgroundColor: Colors.black.withOpacity(0.5),
      child: Container(
        width: 500.0,
        height: 500,
        padding: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.entreprise,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(color: Colors.grey),
            if (highPrediction == null || lowPrediction == null)
              CircularProgressIndicator()
            else ...[
              Text(
                'Prédictions pour demain:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'High: $highPrediction',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Low: $lowPrediction',
                style: TextStyle(fontSize: 16),
              ),
            ],
            SizedBox(height: 20),
            Text(
              'Données historiques:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Expanded(
              child: historicalData.isEmpty
                  ? CircularProgressIndicator()
                  : LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: historicalData,
                      isCurved: true,
                      barWidth: 2,
                      color: Colors.blue,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fermer'),
            ),
          ],
        ),
      ),
    );
  }

  void updatePredictions(double high, double low) {
    setState(() {
      highPrediction = high;
      lowPrediction = low;
    });
  }
}
