import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomLineChart extends StatefulWidget {
  const CustomLineChart({Key? key}) : super(key: key);

  @override
  State<CustomLineChart> createState() => _CustomLineChartState();
}

class _CustomLineChartState extends State<CustomLineChart> {
  List<Color> gradientColors = [
    Colors.white,
    Colors.white,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(30), // Adjust the radius as needed
          child: SizedBox(
            width: 3000, // Set the desired width
            height: 500, // Set the desired height
            child: Padding(
              padding: const EdgeInsets.only(
                right: 18,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                showAvg ? avgData() : mainData(),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: SizedBox(
            width: 60,
            height: 28,
            child: TextButton(
              onPressed: () {
                setState(() {
                  showAvg = !showAvg;
                });
              },
              child: Text(
                'avg',
                style: TextStyle(
                  fontSize: 12,
                  color: showAvg ? Colors.white.withOpacity(0.2) : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    );
    Widget text;
    switch (value.toInt()) {
      case 10:
        text = const Text('MARS', style: style);
        break;
      case 29:
        text = const Text('AVRIL', style: style);
        break;
      case 50:
        text = const Text('MAI', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 8.0, // Adjust as needed for spacing
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.white,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '';
        break;
      case 3:
        text = '';
        break;
      case 5:
        text = '';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false, // Disable the grid
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.transparent),
      ),
      minX: 0,
      maxX: 59,
      minY: 0,
      maxY: 9000,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 7934.17),
            FlSpot(1, 7956.41),
            FlSpot(2, 7932.82),
            FlSpot(3, 7954.74),
            FlSpot(4, 8016.22),
            FlSpot(5, 8028.01),
            FlSpot(6, 8019.73),
            FlSpot(7, 8087.48),
            FlSpot(8, 8137.58),
            FlSpot(9, 8161.42),
            FlSpot(10, 8164.35),
            FlSpot(11, 8148.14),
            FlSpot(12, 8201.05),
            FlSpot(13, 8161.41),
            FlSpot(14, 8179.72),
            FlSpot(15, 8151.92),
            FlSpot(16, 8151.6),
            FlSpot(17, 8184.75),
            FlSpot(18, 8204.81),
            FlSpot(19, 8205.81),
            FlSpot(20, 8130.05),
            FlSpot(21, 8153.23),
            FlSpot(22, 8151.55),
            FlSpot(23, 8061.31),
            FlSpot(24, 8119.3),
            FlSpot(25, 8049.17),
            FlSpot(26, 8045.38),
            FlSpot(27, 8023.74),
            FlSpot(28, 8010.83),
            FlSpot(29, 8045.11),
            FlSpot(30, 7932.61),
            FlSpot(31, 7981.51),
            FlSpot(32, 8023.26),
            FlSpot(33, 8022.41),
            FlSpot(34, 8040.36),
            FlSpot(35, 8105.78),
            FlSpot(36, 8091.86),
            FlSpot(37, 8016.65),
            FlSpot(38, 8088.24),
            FlSpot(39, 8065.15),
            FlSpot(40, 7984.93),
            FlSpot(41, 7914.65),
            FlSpot(42, 7957.57),
            FlSpot(43, 7996.64),
            FlSpot(44, 8075.68),
            FlSpot(45, 8131.41),
            FlSpot(46, 8187.65),
            FlSpot(47, 8219.14),
            FlSpot(48, 8209.28),
            FlSpot(49, 8225.8),
            FlSpot(50, 8239.99),
            FlSpot(51, 8188.49),
            FlSpot(52, 8167.5),
            FlSpot(53, 8185.97),
            FlSpot(54, 8141.46),
            FlSpot(55, 8092.11),
            FlSpot(56, 8132.49),
            FlSpot(57, 8057.8),
            FlSpot(58, 7935.03),
            FlSpot(59, 7953.39),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: false, // Disable the grid
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.transparent),
      ),
      minX: 0,
      maxX: 60,
      minY: 0,
      maxY: 8300,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 7934.17),
            FlSpot(1, 7956.41),
            FlSpot(2, 7932.82),
            FlSpot(3, 7954.74),
            FlSpot(4, 8016.22),
            FlSpot(5, 8028.01),
            FlSpot(6, 8019.73),
            FlSpot(7, 8087.48),
            FlSpot(8, 8137.58),
            FlSpot(9, 8161.42),
            FlSpot(10, 8164.35),
            FlSpot(11, 8148.14),
            FlSpot(12, 8201.05),
            FlSpot(13, 8161.41),
            FlSpot(14, 8179.72),
            FlSpot(15, 8151.92),
            FlSpot(16, 8151.6),
            FlSpot(17, 8184.75),
            FlSpot(18, 8204.81),
            FlSpot(19, 8205.81),
            FlSpot(20, 8130.05),
            FlSpot(21, 8153.23),
            FlSpot(22, 8151.55),
            FlSpot(23, 8061.31),
            FlSpot(24, 8119.3),
            FlSpot(25, 8049.17),
            FlSpot(26, 8045.38),
            FlSpot(27, 8023.74),
            FlSpot(28, 8010.83),
            FlSpot(29, 8045.11),
            FlSpot(30, 7932.61),
            FlSpot(31, 7981.51),
            FlSpot(32, 8023.26),
            FlSpot(33, 8022.41),
            FlSpot(34, 8040.36),
            FlSpot(35, 8105.78),
            FlSpot(36, 8091.86),
            FlSpot(37, 8016.65),
            FlSpot(38, 8088.24),
            FlSpot(39, 8065.15),
            FlSpot(40, 7984.93),
            FlSpot(41, 7914.65),
            FlSpot(42, 7957.57),
            FlSpot(43, 7996.64),
            FlSpot(44, 8075.68),
            FlSpot(45, 8131.41),
            FlSpot(46, 8187.65),
            FlSpot(47, 8219.14),
            FlSpot(48, 8209.28),
            FlSpot(49, 8225.8),
            FlSpot(50, 8239.99),
            FlSpot(51, 8188.49),
            FlSpot(52, 8167.5),
            FlSpot(53, 8185.97),
            FlSpot(54, 8141.46),
            FlSpot(55, 8092.11),
            FlSpot(56, 8132.49),
            FlSpot(57, 8057.8),
            FlSpot(58, 7935.03),
            FlSpot(59, 7953.39),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
