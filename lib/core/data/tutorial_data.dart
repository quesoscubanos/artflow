import 'package:flutter/foundation.dart';
import 'package:artflowrise/features/tutorials/presentation/pages/tutorial_detail_page.dart';

// Official tutorials (admin uploaded)
List<Map<String, dynamic>> officialTutorials = [
  {
    'id': '1',
    'title': 'Fundamentos del Dibujo',
    'description': 'Aprende los fundamentos del dibujo',
    'author': 'Equipo ArtFlowRise',
    'level': 'Principiante',
    'duration': '45 min',
    'isOfficial': true,
  },
  {
    'id': 'perspective-drawing',
    'title': 'Dibujo con Perspectiva',
    'description': 'Domina las técnicas de perspectiva',
    'author': 'Equipo ArtFlowRise',
    'level': 'Intermedio',
    'duration': '60 min',
    'isOfficial': true,
  },
  {
    'id': '3',
    'title': 'Teoría del Color',
    'description': 'Entendiendo colores y armonía',
    'author': 'Color_Expert',
    'level': 'Principiante',
    'duration': '30 min',
    'isOfficial': true,
  },
  {
    'id': '4',
    'title': 'Técnicas de Retrato',
    'description': 'Dibujando retratos realistas',
    'author': 'Portrait_Master',
    'level': 'Avanzado',
    'duration': '90 min',
    'isOfficial': true,
  },
];

// User-uploaded tutorials (gallery) - mutable for new uploads
List<Map<String, dynamic>> userTutorials = [
  {
    'id': 'gallery-1',
    'title': 'Técnicas Avanzadas de Sombras',
    'description': 'Domina el arte de crear profundidad con sombras',
    'author': 'Shadow_Master',
    'userId': '1',
    'level': 'Avanzado',
    'duration': '75 min',
    'isOfficial': false,
  },
  {
    'id': 'gallery-2',
    'title': 'Fundamentos de Pintura Digital',
    'description': 'Introducción a herramientas y técnicas de arte digital',
    'author': 'Digital_Artist',
    'userId': '1',
    'level': 'Principiante',
    'duration': '50 min',
    'isOfficial': false,
  },
  {
    'id': 'gallery-3',
    'title': 'Composición y Equilibrio',
    'description': 'Aprende a crear obras visualmente atractivas',
    'author': 'Composition_Expert',
    'userId': '1',
    'level': 'Intermedio',
    'duration': '40 min',
    'isOfficial': false,
  },
  {
    'id': 'gallery-4',
    'title': 'Dominio del Acuarela',
    'description': 'Técnicas avanzadas de acuarela y consejos',
    'author': 'Watercolor_Pro',
    'userId': '1',
    'level': 'Avanzado',
    'duration': '85 min',
    'isOfficial': false,
  },
];

/// Notifier that exposes the live userTutorials list so other parts of the app
/// (e.g., dashboard) can listen and react immediately when the gallery changes.
/// Use `userTutorialsNotifier.value = userTutorials;` after mutating the list.
final ValueNotifier<List<Map<String, dynamic>>> userTutorialsNotifier = ValueNotifier(userTutorials);

/// Notifier for official tutorials
final ValueNotifier<List<Map<String, dynamic>>> officialTutorialsNotifier = ValueNotifier(officialTutorials);

// Challenges data
List<Map<String, dynamic>> challenges = [
  {
    'id': '1',
    'title': 'Desafío Semanal de Bocetos',
    'description': 'Crea un boceto de tu objeto favorito usando solo lápiz',
    'difficulty': 'Principiante',
    'duration': '7 días',
    'participants': 45,
    'createdBy': 'Admin',
    'createdDate': '2024-01-15',
    'isJoined': false,
  },
  {
    'id': '2',
    'title': 'Maestro de Armonía de Color',
    'description': 'Crea una pintura usando colores complementarios',
    'difficulty': 'Intermedio',
    'duration': '14 días',
    'participants': 23,
    'createdBy': 'Admin',
    'createdDate': '2024-01-20',
    'isJoined': false,
  },
];

/// Notifier for challenges
final ValueNotifier<List<Map<String, dynamic>>> challengesNotifier = ValueNotifier(challenges);

// Combined tutorials for detail page - this will be updated when official tutorials change
Map<String, Tutorial> allTutorialsData = {
  ...tutorialsData,
  // Add any additional tutorials here if needed
};