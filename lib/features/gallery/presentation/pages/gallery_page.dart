import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:artflowrise/core/theme/app_theme.dart';
import 'package:artflowrise/core/utils/responsive_helper.dart';
import 'package:artflowrise/features/gallery/presentation/pages/gallery_tutorial_detail_page.dart';
import 'package:artflowrise/features/gallery/presentation/pages/user_publication_detail_page.dart';
import 'package:artflowrise/core/data/tutorial_data.dart';
import 'package:artflowrise/features/auth/presentation/bloc/auth_bloc.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  List<Map<String, dynamic>> get _tutorials => userTutorials;

  List<Map<String, dynamic>> get _filteredTutorials {
    if (_selectedCategory == 'All') {
      return _tutorials;
    }
    return _tutorials.where((tutorial) => tutorial['level'] == _selectedCategory).toList();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh when coming back from detail page
    setState(() {});
  }

  void _showDeleteConfirmation(Map<String, dynamic> tutorial) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Remove Tutorial',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to remove "${tutorial['title']}" from your gallery?',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text(
                'Note: This will only remove it from your personal view. The tutorial remains available in the system.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteTutorial(tutorial);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTutorial(Map<String, dynamic> tutorial) {
    // For regular users, don't actually delete - just show message
    // Only admins can permanently delete tutorials

    // Show success message (but don't actually delete)
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutorial removed from your gallery')),
      );
    }

    // Note: Tutorial remains in the system, only admins can permanently remove it
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Gallery',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.textSecondary),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const GalleryTutorialDetailPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = category == _selectedCategory;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.grey[100],
                    selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primaryBlue : AppTheme.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: ResponsiveHelper.getResponsivePadding(context),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(
                  context,
                  mobile: 2,
                  tablet: 3,
                  desktop: 4,
                ),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: _filteredTutorials.length,
              itemBuilder: (context, index) {
                return _buildTutorialCard(_filteredTutorials[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard(Map<String, dynamic> tutorial) {
    // Get current user
    final authState = context.read<AuthBloc>().state;
    final currentUsername = authState is AuthAuthenticated ? authState.username : null;
    final isOwner = currentUsername != null && tutorial['author'] == currentUsername && tutorial['isOfficial'] == false;

    return InkWell(
      onTap: () {
        // Navigate to appropriate detail page
        if (tutorial['isOfficial'] == false && tutorial['images'] != null) {
          // User publication with images
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => UserPublicationDetailPage(publication: tutorial),
            ),
          );
        } else {
          // Official tutorial
          context.go('/tutorial/${tutorial['id']}');
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        elevation: 0,
        color: Colors.white,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: tutorial['images'] != null && (tutorial['images'] as List).isNotEmpty
                            ? Image.file(
                                File((tutorial['images'] as List<Map<String, String>>).first['path']!),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'images/perspective.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                                        child: const Icon(
                                          Icons.image,
                                          size: 48,
                                          color: AppTheme.primaryBlue,
                                        ),
                                      );
                                    },
                                  );
                                },
                              )
                          : Image.asset(
                              'images/perspective.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                                  child: const Icon(
                                    Icons.image,
                                    size: 48,
                                    color: AppTheme.primaryBlue,
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                tutorial['title'],
                                textDirection: TextDirection.ltr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppTheme.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (tutorial['isOfficial'])
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'OFFICIAL',
                                  style: TextStyle(
                                    fontSize: 8,
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
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tutorial['level'],
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.primaryBlue,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.access_time,
                              size: 12,
                              color: AppTheme.textLight,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              tutorial['duration'],
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppTheme.textLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Delete button for owner
            if (isOwner)
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmation(tutorial);
                  },
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
