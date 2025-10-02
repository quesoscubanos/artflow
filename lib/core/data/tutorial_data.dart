import 'package:flutter/foundation.dart';
import 'package:artflowrise/features/tutorials/presentation/pages/tutorial_detail_page.dart';

// Official tutorials (admin uploaded)
List<Map<String, dynamic>> officialTutorials = [
  {
    'id': '1',
    'title': 'Drawing Fundamentals',
    'description': 'Learn the basics of drawing',
    'author': 'ArtFlowRise Team',
    'level': 'Beginner',
    'duration': '45 min',
    'isOfficial': true,
  },
  {
    'id': 'perspective-drawing',
    'title': 'Drawing with Perspective',
    'description': 'Master perspective techniques',
    'author': 'ArtFlowRise Team',
    'level': 'Intermediate',
    'duration': '60 min',
    'isOfficial': true,
  },
  {
    'id': '3',
    'title': 'Color Theory',
    'description': 'Understanding colors and harmony',
    'author': 'Color_Expert',
    'level': 'Beginner',
    'duration': '30 min',
    'isOfficial': true,
  },
  {
    'id': '4',
    'title': 'Portrait Techniques',
    'description': 'Drawing realistic portraits',
    'author': 'Portrait_Master',
    'level': 'Advanced',
    'duration': '90 min',
    'isOfficial': true,
  },
];

// User-uploaded tutorials (gallery) - mutable for new uploads
List<Map<String, dynamic>> userTutorials = [
  {
    'id': 'gallery-1',
    'title': 'Advanced Shading Techniques',
    'description': 'Master the art of creating depth with shadows',
    'author': 'Shadow_Master',
    'level': 'Advanced',
    'duration': '75 min',
    'isOfficial': false,
  },
  {
    'id': 'gallery-2',
    'title': 'Digital Painting Basics',
    'description': 'Introduction to digital art tools and techniques',
    'author': 'Digital_Artist',
    'level': 'Beginner',
    'duration': '50 min',
    'isOfficial': false,
  },
  {
    'id': 'gallery-3',
    'title': 'Composition and Balance',
    'description': 'Learn to create visually appealing artwork',
    'author': 'Composition_Expert',
    'level': 'Intermediate',
    'duration': '40 min',
    'isOfficial': false,
  },
  {
    'id': 'gallery-4',
    'title': 'Watercolor Mastery',
    'description': 'Advanced watercolor techniques and tips',
    'author': 'Watercolor_Pro',
    'level': 'Advanced',
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
    'title': 'Weekly Sketch Challenge',
    'description': 'Create a sketch of your favorite object using only pencil',
    'difficulty': 'Beginner',
    'duration': '7 days',
    'participants': 45,
    'createdBy': 'Admin',
    'createdDate': '2024-01-15',
    'isJoined': false,
  },
  {
    'id': '2',
    'title': 'Color Harmony Master',
    'description': 'Create a painting using complementary colors',
    'difficulty': 'Intermediate',
    'duration': '14 days',
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