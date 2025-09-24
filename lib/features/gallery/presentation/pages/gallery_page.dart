import 'package:flutter/material.dart';
import 'package:artflowrise/core/theme/app_theme.dart';
import 'package:artflowrise/core/utils/responsive_helper.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Portraits', 'Landscapes', 'Abstract', 'Digital', 'Traditional'];

  final List<Map<String, dynamic>> _artworks = [
    {
      'id': '1',
      'title': 'Portrait Study',
      'artist': 'Sarah_Artist',
      'likes': 24,
      'category': 'Portraits',
    },
    {
      'id': '2',
      'title': 'Mountain View',
      'artist': 'Mike_Draws',
      'likes': 18,
      'category': 'Landscapes',
    },
    {
      'id': '3',
      'title': 'Color Experiment',
      'artist': 'Emma_Art',
      'likes': 32,
      'category': 'Abstract',
    },
    {
      'id': '4',
      'title': 'Digital Portrait',
      'artist': 'Alex_Digital',
      'likes': 15,
      'category': 'Digital',
    },
    {
      'id': '5',
      'title': 'Watercolor Landscape',
      'artist': 'Nature_Lover',
      'likes': 28,
      'category': 'Traditional',
    },
    {
      'id': '6',
      'title': 'Abstract Forms',
      'artist': 'Modern_Artist',
      'likes': 41,
      'category': 'Abstract',
    },
  ];

  List<Map<String, dynamic>> get _filteredArtworks {
    if (_selectedCategory == 'All') {
      return _artworks;
    }
    return _artworks.where((artwork) => artwork['category'] == _selectedCategory).toList();
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Upload feature coming soon!')),
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
                    selectedColor: AppTheme.primaryBlue.withOpacity(0.2),
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
              itemCount: _filteredArtworks.length,
              itemBuilder: (context, index) {
                return _buildArtworkCard(_filteredArtworks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtworkCard(Map<String, dynamic> artwork) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      elevation: 0,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Icon(
                Icons.image,
                size: 48,
                color: AppTheme.primaryBlue,
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
                  Text(
                    artwork['title'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'by ${artwork['artist']}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        size: 16,
                        color: AppTheme.primaryPink,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${artwork['likes']}',
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
          ),
        ],
      ),
    );
  }
}
