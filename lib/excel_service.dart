import 'package:flutter/services.dart';
import 'dart:convert';

class ExcelService {
  static Future<List<String>> getAllCompanies() async {
    // Récupérez les données depuis Excel ou une autre source
    // Ici, nous simulons une liste d'entreprises pour l'exemple
    List<String> allCompanies = ["ACCOR",
      "AIR LIQUIDE",
      "AIRBUS GROUP",
      "ARCELORMITTAL",
      "AXA",
      "BNP PARIBAS",
      "BOUYGUES",
      "CAPGEMINI",
      "CARREFOUR",
      "CREDIT AGRICOLE",
      "DANONE",
      "DASSAULT SYSTEMES",
      "EDENRED",
      "ENGIE",
      "ESSILORLUXOTTICA",
      "EUROFINS SCIENTIFIC",
      "HERMES INTERNATIONAL",
      "KERING",
      "LEGRAND",
      "L'OREAL",
      "LVMH",
      "MICHELIN",
      "ORANGE",
      "PERNOD RICARD",
      "PUBLICIS",
      "RENAULT SAFRAN",
      "SAINT-GOBAIN",
      "SANOFI",
      "SCHNEIDER ELECTRIC",
      "SOCIETE GENERALE",
      "STELLANTIS",
      "STMICROELECTRONICS",
      "TELEPERFORMANCE",
      "THALES",
      "TOTALENERGIES",
      "UNIBAIL-RODAMCO",
      "VEOLIA ENVIRONNEMENT",
      "VINCI",
      "VIVENDI SE",];
    return allCompanies;
  }
}
