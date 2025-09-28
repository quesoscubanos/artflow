import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:artflowrise/core/theme/app_theme.dart';
import 'package:artflowrise/core/utils/responsive_helper.dart';
import 'package:artflowrise/core/data/tutorial_data.dart';
import 'package:artflowrise/features/tutorials/presentation/bloc/tutorials_bloc.dart';

// Create a ValueNotifier to listen for changes in userTutorials
final ValueNotifier<List<Map<String, dynamic>>> userTutorialsNotifier = ValueNotifier(userTutorials);

class MainNavigationPage extends StatefulWidget {
  final Widget child; 
  
  const MainNavigationPage({super.key, required this.child});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    switch (index) {
      case 0:
        context.go('/dashboard');
        break;
      case 1:
        context.go('/gallery');
        break;
      case 2:
        context.go('/tutorials');
        break;
      case 3:
        context.go('/challenges');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: AppTheme.textLight,
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library_outlined),
            activeIcon: Icon(Icons.photo_library),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school),
            label: 'Tutorials',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Icon(Icons.emoji_events),
            label: 'Challenges',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.selected,
            backgroundColor: Colors.white,
            selectedIconTheme: IconThemeData(color: AppTheme.primaryBlue),
            unselectedIconTheme: IconThemeData(color: AppTheme.textLight),
            selectedLabelTextStyle: TextStyle(color: AppTheme.primaryBlue),
            unselectedLabelTextStyle: TextStyle(color: AppTheme.textLight),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.photo_library_outlined),
                selectedIcon: Icon(Icons.photo_library),
                label: Text('Gallery'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school),
                label: Text('Tutorials'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.emoji_events_outlined),
                selectedIcon: Icon(Icons.emoji_events),
                label: Text('Challenges'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            backgroundColor: Colors.white,
            selectedIconTheme: IconThemeData(color: AppTheme.primaryBlue),
            unselectedIconTheme: IconThemeData(color: AppTheme.textLight),
            selectedLabelTextStyle: TextStyle(color: AppTheme.primaryBlue),
            unselectedLabelTextStyle: TextStyle(color: AppTheme.textLight),
            minWidth: 200,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.photo_library_outlined),
                selectedIcon: Icon(Icons.photo_library),
                label: Text('Gallery'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.school_outlined),
                selectedIcon: Icon(Icons.school),
                label: Text('Tutorials'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.emoji_events_outlined),
                selectedIcon: Icon(Icons.emoji_events),
                label: Text('Challenges'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person),
                label: Text('Profile'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxContentWidth(context),
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TutorialsBloc, TutorialsState>(
      builder: (context, state) {
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
                  child: Image.asset(
                    'logo/logo.png',
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'ArtFlowRise',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {},
                color: AppTheme.textSecondary,
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: ResponsiveHelper.getResponsivePadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMixedContentFeed(context, state),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMixedContentFeed(BuildContext context, TutorialsState state) {
    // Listen to the mutable gallery list (userTutorialsNotifier) and the TutorialsBloc state.
    return ValueListenableBuilder<List<Map<String, dynamic>>>(
      valueListenable: userTutorialsNotifier,
      builder: (context, userList, _) {
        final tutorials = state is TutorialsLoaded ? state.tutorials : [];

        // Build a combined list of references to the original data sources.
        // Each entry contains a 'type' and a 'source' reference (no deep copy).
        final List<Map<String, dynamic>> mixedContent = [];

        // Add admin/tutorial items (source is the original tutorial map)
        for (final t in tutorials) {
          mixedContent.add({
            'type': 'tutorial',
            'source': t,
          });
        }

        // Add user/gallery items (source is the original user tutorial map)
        for (final g in userList) {
          mixedContent.add({
            'type': 'gallery',
            'source': g,
          });
        }

        // Render using the live sources so any mutation in tutorials or userTutorials
        // is immediately reflected in the dashboard.
        if (ResponsiveHelper.isDesktop(context)) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveHelper.getGridCrossAxisCount(context, mobile: 1, tablet: 2, desktop: 3),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: mixedContent.length,
            itemBuilder: (context, index) {
              final item = mixedContent[index];
              final src = item['source'] as Map<String, dynamic>;

              if (item['type'] == 'tutorial') {
                return _buildTutorialCard(
                  context,
                  src['title'] as String,
                  src['description'] as String,
                  src['imagePath'] as String? ?? src['image'] as String?,
                  src['author'] as String,
                  src['isOfficial'] as bool,
                  (src['progress'] ?? 0.0) as double,
                );
              } else {
                // gallery item - may contain 'images' list for previews
                final imagePreview = (src['images'] != null && (src['images'] as List).isNotEmpty)
                    ? ((src['images'] as List).first is Map ? (src['images'] as List).first['path'] : (src['images'] as List).first)
                    : src['image'] as String? ?? 'images/perspective.png';

                return _buildGalleryCard(
                  context,
                  src['title'] as String,
                  src['description'] as String,
                  imagePreview as String?,
                  src['author'] as String,
                  src['likes'] as int? ?? 0,
                );
              }
            },
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mixedContent.length,
          itemBuilder: (context, index) {
            final item = mixedContent[index];
            final src = item['source'] as Map<String, dynamic>;

            if (item['type'] == 'tutorial') {
              return _buildTutorialCard(
                context,
                src['title'] as String,
                src['description'] as String,
                src['imagePath'] as String? ?? src['image'] as String?,
                src['author'] as String,
                src['isOfficial'] as bool,
                (src['progress'] ?? 0.0) as double,
              );
            } else {
              final imagePreview = (src['images'] != null && (src['images'] as List).isNotEmpty)
                  ? ((src['images'] as List).first is Map ? (src['images'] as List).first['path'] : (src['images'] as List).first)
                  : src['image'] as String? ?? 'images/perspective.png';

              return _buildGalleryCard(
                context,
                src['title'] as String,
                src['description'] as String,
                imagePreview as String?,
                src['author'] as String,
                src['likes'] as int? ?? 0,
              );
            }
          },
        );
      },
    );
  }

  Widget _buildTutorialCard(BuildContext context, String title, String description, String? imageUrl, String author, bool isOfficial, double progress) {
    final cardHeight = ResponsiveHelper.isDesktop(context) ? 180.0 : 120.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: cardHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.grey[100],
            ),
            child: imageUrl != null && imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.file(
                      File(imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          child: Icon(
                            Icons.image_not_supported,
                            size: 48,
                            color: AppTheme.textLight,
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    color: AppTheme.primaryBlue.withOpacity(0.1),
                    child: Icon(
                      Icons.school,
                      size: 48,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: ResponsiveHelper.isDesktop(context) ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryCard(BuildContext context, String title, String description, String? imageUrl, String author, int likes) {
    final cardHeight = ResponsiveHelper.isDesktop(context) ? 180.0 : 120.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: cardHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              color: Colors.grey[100],
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppTheme.primaryPink.withOpacity(0.1),
                          child: Icon(
                            Icons.image,
                            size: 48,
                            color: AppTheme.primaryPink,
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    color: AppTheme.primaryPink.withOpacity(0.1),
                    child: Icon(
                      Icons.image,
                      size: 48,
                      color: AppTheme.primaryPink,
                    ),
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                  maxLines: ResponsiveHelper.isDesktop(context) ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
