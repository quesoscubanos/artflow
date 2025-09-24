import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:artflowrise/core/theme/app_theme.dart';

class TutorialsPage extends StatefulWidget {
  const TutorialsPage({super.key});

  @override
  State<TutorialsPage> createState() => _TutorialsPageState();
}

class _TutorialsPageState extends State<TutorialsPage> {
  final List<Map<String, dynamic>> _tutorials = [
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
      'isOfficial': false,
    },
    {
      'id': '4',
      'title': 'Portrait Techniques',
      'description': 'Drawing realistic portraits',
      'author': 'Portrait_Master',
      'level': 'Advanced',
      'duration': '90 min',
      'isOfficial': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Tutorials',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.textSecondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Create tutorial feature coming soon!')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tutorials.length,
        itemBuilder: (context, index) {
          return _buildTutorialCard(_tutorials[index]);
        },
      ),
    );
  }

  Widget _buildTutorialCard(Map<String, dynamic> tutorial) {
    return InkWell(
      onTap: () {
        // Navigate to tutorial detail page
        context.go('/tutorial/${tutorial['id']}');
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        elevation: 0,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryBlue.withOpacity(0.3),
                    AppTheme.primaryPink.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.play_circle_outline,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tutorial['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      if (tutorial['isOfficial'])
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'OFFICIAL',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tutorial['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          tutorial['level'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.textLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        tutorial['duration'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
