import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:artflowrise/core/theme/app_theme.dart';
import 'package:artflowrise/core/data/tutorial_data.dart';
import 'package:artflowrise/features/gallery/presentation/pages/gallery_tutorial_detail_page.dart';
import 'package:artflowrise/features/gallery/presentation/pages/user_publication_detail_page.dart';
import 'package:artflowrise/features/tutorials/presentation/pages/tutorial_detail_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  void _editTutorial(Map<String, dynamic> tutorial, bool? isOfficial) {
    final titleController = TextEditingController(text: tutorial['title']);
    final descriptionController = TextEditingController(text: tutorial['description']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Edit Tutorial'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Find the original tutorial and update it
              if (isOfficial == true) {
                final originalTutorial = officialTutorials.firstWhere((t) => t['id'] == tutorial['id']);
                originalTutorial['title'] = titleController.text;
                originalTutorial['description'] = descriptionController.text;
                officialTutorialsNotifier.value = List.from(officialTutorials);
              } else {
                final originalTutorial = userTutorials.firstWhere((t) => t['id'] == tutorial['id']);
                originalTutorial['title'] = titleController.text;
                originalTutorial['description'] = descriptionController.text;
                userTutorialsNotifier.value = List.from(userTutorials);
              }

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tutorial updated successfully')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteTutorial(Map<String, dynamic> tutorial, bool? isOfficial) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete Tutorial'),
        content: Text(
          'Are you sure you want to delete the tutorial "${tutorial['title']}"? This action will permanently remove the tutorial from the system. Only admins can perform this action.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (isOfficial == true) {
                // Find and remove the original tutorial from officialTutorials
                officialTutorials.removeWhere((t) => t['id'] == tutorial['id']);
                // Update allTutorialsData for tutorial detail pages
                allTutorialsData.remove(tutorial['id']);
                officialTutorialsNotifier.value = List.from(officialTutorials);
              } else {
                // Find and remove the original tutorial from userTutorials
                userTutorials.removeWhere((t) => t['id'] == tutorial['id']);
                userTutorialsNotifier.value = List.from(userTutorials);
              }

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tutorial deleted successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard(Map<String, dynamic> tutorial, bool? isOfficial) {
    final imageUrl = tutorial['images'] != null && (tutorial['images'] as List).isNotEmpty
        ? ((tutorial['images'] as List).first is Map
            ? (tutorial['images'] as List).first['path']
            : (tutorial['images'] as List).first)
        : 'images/perspective.png';

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: InkWell(
        onTap: () => _openTutorialDetail(tutorial, isOfficial ?? false),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.file(
                        File(imageUrl),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'images/perspective.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.primaryBlue.withOpacity(0.1),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 24,
                                  color: AppTheme.textLight,
                                ),
                              );
                            },
                          );
                        },
                      )
                    : Container(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        child: const Icon(
                          Icons.school,
                          size: 24,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tutorial['title'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isOfficial == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'OFFICIAL',
                            style: TextStyle(
                              fontSize: 5,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                        ),
                      PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        iconSize: 14,
                        onSelected: (value) {
                          switch (value) {
                            case 'edit':
                              _editTutorial(tutorial, isOfficial);
                              break;
                            case 'delete':
                              _deleteTutorial(tutorial, isOfficial);
                              break;
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tutorial['description'],
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textSecondary,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'By: ${tutorial['author']}',
                    style: const TextStyle(
                      fontSize: 8,
                      color: AppTheme.textLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openTutorialDetail(Map<String, dynamic> tutorial, bool? isOfficial) {
    // Navigate to tutorial detail page for all tutorials (both official and user-uploaded)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TutorialDetailPage(
          tutorialId: tutorial['id'],
          initialStep: 0,
          isAdmin: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                size: 20,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Admin Dashboard',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: null,
      ),
      body: ValueListenableBuilder<List<Map<String, dynamic>>>(
        valueListenable: userTutorialsNotifier,
        builder: (context, userTutorialsList, _) {
          return ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: officialTutorialsNotifier,
            builder: (context, officialTutorialsList, _) {
              // Combine official and user tutorials
              final List<Map<String, dynamic>> allTutorials = [
                ...officialTutorialsList.map((t) => {...t, 'isOfficial': true}),
                ...userTutorialsList.map((t) => {...t, 'isOfficial': false}),
              ];

              if (allTutorials.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.waving_hand,
                        size: 80,
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '👉 "Welcome, Admin"',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Tutorials will appear here',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.7,
                ),
                itemCount: allTutorials.length,
                itemBuilder: (context, index) {
                  final tutorial = allTutorials[index];
                  final isOfficial = tutorial['isOfficial'] as bool? ?? false;
                  return _buildTutorialCard(tutorial, isOfficial);
                },
              );
            },
          );
        },
      ),
    );
  }
}
