import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service pour gérer les opérations sur les PDFs
class PdfService {
  // TODO: Remplacer par l'URL réelle de votre backend
  static const String baseUrl = 'https://api.prevhub.com'; // URL d'exemple
  
  // Mode mock pour tester le frontend sans backend
  static const bool useMockPdf = true; // Mettre à false pour utiliser le backend réel
  
  /// Récupère le PDF du plan depuis le backend pour une mission donnée
  /// Retourne le chemin local du fichier PDF téléchargé
  Future<String?> fetchPlanPdf(String missionId) async {
    // Mode mock : utiliser le PDF depuis les assets
    if (useMockPdf) {
      return _getMockPdfPath();
    }
    
    // Mode production : télécharger depuis le backend
    try {
      // TODO: Adapter l'endpoint selon votre API
      final url = Uri.parse('$baseUrl/api/missions/$missionId/plan.pdf');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        // Sauvegarder le PDF localement
        final directory = await getApplicationDocumentsDirectory();
        final filePath = path.join(directory.path, 'plan_$missionId.pdf');
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        
        return filePath;
      } else {
        // En cas d'erreur, retourner le PDF mocké
        print('Erreur lors du téléchargement du PDF: ${response.statusCode}');
        return _getMockPdfPath();
      }
    } catch (e) {
      print('Erreur lors de la récupération du PDF: $e');
      // En cas d'erreur, utiliser le PDF mocké
      return _getMockPdfPath();
    }
  }
  
  /// Retourne le chemin d'un PDF mocké depuis les assets
  /// (pour le développement/test)
  Future<String?> _getMockPdfPath() async {
    try {
      // Charger le PDF depuis les assets
      final ByteData data = await rootBundle.load('assets/pdfs/Appli Prev\'hub workflow préventionniste.pdf');
      final Uint8List bytes = data.buffer.asUint8List();
      
      // Sauvegarder dans le répertoire de documents
      final directory = await getApplicationDocumentsDirectory();
      final filePath = path.join(directory.path, 'mock_plan.pdf');
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      
      return filePath;
    } catch (e) {
      print('Erreur lors de la récupération du PDF mocké: $e');
      return null;
    }
  }
  
  /// Sauvegarde les annotations sur le PDF
  Future<bool> saveAnnotations(String missionId, List<Map<String, dynamic>> annotations) async {
    try {
      // TODO: Adapter l'endpoint selon votre API
      final url = Uri.parse('$baseUrl/api/missions/$missionId/annotations');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'annotations': annotations}),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Erreur lors de la sauvegarde des annotations: $e');
      return false;
    }
  }
}

