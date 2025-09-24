import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:artflowrise/core/theme/app_theme.dart';
import 'package:artflowrise/core/utils/responsive_helper.dart';

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
              child: Icon(
                Icons.palette,
                size: 20,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'DrawIt',
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
            _buildMixedContentFeed(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMixedContentFeed(BuildContext context) {
    final mixedContent = [
      {
        'type': 'tutorial',
        'title': 'Step 1: Begin with a light sketch of the basic shapes. Focus on proportions and overall composition.',
        'image': 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-RsqcGbjsXj2IVHIPXlqHSJEEebxYC4.png',
        'author': 'ArtFlowRise',
        'isOfficial': true,
        'progress': 0.2,
      },
      {
        'type': 'gallery',
        'title': 'My latest watercolor painting',
        'image': null,
        'author': 'Sarah_Artist',
        'isOfficial': false,
        'likes': 24,
      },
      {
        'type': 'tutorial',
        'title': 'Dibujo con Perspectiva - Paso 2 de 7',
        'image': 'https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-cuZsr9QKrPQ96oFDHJ6VN4EaFxvDCz.png',
        'author': 'ArtFlowRise',
        'isOfficial': true,
        'progress': 0.3,
      },
      {
        'type': 'gallery',
        'title': 'Portrait practice session',
        'image': null,
        'author': 'Mike_Draws',
        'isOfficial': false,
        'likes': 18,
      },
      {
        'type': 'tutorial',
        'title': 'Color Theory Fundamentals',
        'image': null,
        'author': 'ArtFlowRise',
        'isOfficial': true,
        'progress': 0.0,
      },
    ];

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
          
          if (item['type'] == 'tutorial') {
            return _buildTutorialCard(
              context,
              item['title'] as String,
              item['image'] as String?,
              item['author'] as String,
              item['isOfficial'] as bool,
              item['progress'] as double,
            );
          } else {
            return _buildGalleryCard(
              context,
              item['title'] as String,
              item['image'] as String?,
              item['author'] as String,
              item['likes'] as int,
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
        
        if (item['type'] == 'tutorial') {
          return _buildTutorialCard(
            context,
            item['title'] as String,
            item['image'] as String?,
            item['author'] as String,
            item['isOfficial'] as bool,
            item['progress'] as double,
          );
        } else {
          return _buildGalleryCard(
            context,
            item['title'] as String,
            item['image'] as String?,
            item['author'] as String,
            item['likes'] as int,
          );
        }
      },
    );
  }

  Widget _buildTutorialCard(BuildContext context, String title, String? imageUrl, String author, bool isOfficial, double progress) {
    final cardHeight = ResponsiveHelper.isDesktop(context) ? 180.0 : 120.0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    child: Image.network(
                      imageUrl,
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
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        author,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (isOfficial) ...[ 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'OFFICIAL',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                    height: 1.4,
                  ),
                  maxLines: ResponsiveHelper.isDesktop(context) ? 3 : 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                
                if (progress > 0) ...[ 
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: progress > 0 ? AppTheme.primaryPink : AppTheme.primaryBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(progress > 0 ? 'Continue' : 'Start'),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                      color: AppTheme.textLight,
                    ),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      onPressed: () {},
                      color: AppTheme.textLight,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryCard(BuildContext context, String title, String? imageUrl, String author, int likes) {
    final cardHeight = ResponsiveHelper.isDesktop(context) ? 180.0 : 120.0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            child: Container(
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
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppTheme.primaryPink.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 16,
                        color: AppTheme.primaryPink,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        author,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                  maxLines: ResponsiveHelper.isDesktop(context) ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      size: 20,
                      color: AppTheme.primaryPink,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$likes',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.comment_outlined,
                      size: 20,
                      color: AppTheme.textLight,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${likes ~/ 3}',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                      color: AppTheme.textLight,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
