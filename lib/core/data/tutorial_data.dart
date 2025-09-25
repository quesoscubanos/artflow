import 'package:artflowrise/features/tutorials/presentation/pages/tutorial_detail_page.dart';

// Official tutorials (admin uploaded)
final List<Map<String, dynamic>> officialTutorials = [
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

// User-uploaded tutorials (gallery)
final List<Map<String, dynamic>> userTutorials = [
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

// Combined tutorials for detail page
final Map<String, Tutorial> allTutorialsData = {
  ...tutorialsData,
  // Add any additional tutorials here if needed
};