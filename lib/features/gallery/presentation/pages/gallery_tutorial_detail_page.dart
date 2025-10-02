import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:artflowrise/core/theme/app_theme.dart';
import 'package:artflowrise/core/data/tutorial_data.dart';
import 'package:artflowrise/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:artflowrise/features/tutorials/presentation/pages/tutorial_detail_page.dart';

class GalleryTutorialDetailPage extends StatefulWidget {
  final bool isAdmin;

  const GalleryTutorialDetailPage({super.key, this.isAdmin = false});

  @override
  State<GalleryTutorialDetailPage> createState() => _GalleryTutorialDetailPageState();
}

class _GalleryTutorialDetailPageState extends State<GalleryTutorialDetailPage> {
  final ImagePicker _picker = ImagePicker();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  String _selectedCategory = 'Drawing';
  String _selectedDifficulty = 'Beginner';
  final List<String> _selectedTags = [];
  final List<Map<String, String>> _uploadedImages = []; // Holds {'path': filePath, 'description': description}

  final List<String> _categories = [
    'Drawing',
    'Painting',
    'Digital Art',
    'Sculpture',
    'Photography',
    'Mixed Media'
  ];

  final List<String> _difficulties = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _addTag() {
    if (_tagsController.text.isNotEmpty && !_selectedTags.contains(_tagsController.text)) {
      setState(() {
        _selectedTags.add(_tagsController.text);
        _tagsController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  Future<void> _selectImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isEmpty) return;

      // Validate selection count (3-25 per selection)
      if (images.length < 3) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select at least 3 images')),
          );
        }
        return;
      }

      if (images.length > 25) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Maximum 25 images per selection')),
          );
        }
        return;
      }

      // Check if adding these would exceed total limit
      final remainingSlots = 25 - _uploadedImages.length;
      if (images.length > remainingSlots) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Can only add $remainingSlots more images (max 25 total)')),
          );
        }
        return;
      }

      // Validate each image size and add valid ones
      int addedCount = 0;
      for (final image in images) {
        final file = File(image.path);
        final fileSize = await file.length();
        const maxSize = 5 * 1024 * 1024; // 5MB in bytes

        if (fileSize > maxSize) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${image.name} exceeds 5MB limit - skipped')),
            );
          }
          continue; // Skip this image
        }

        setState(() {
          _uploadedImages.add({'path': image.path, 'description': ''});
        });
        addedCount++;
      }

      if (mounted && addedCount > 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added $addedCount image(s). Total: ${_uploadedImages.length}/25')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to select images')),
        );
      }
    }
  }

  void _publishTutorial() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description')),
      );
      return;
    }

    if (_uploadedImages.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least 3 images')),
      );
      return;
    }

    if (_uploadedImages.length > 25) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 25 images allowed')),
      );
      return;
    }

    if (widget.isAdmin) {
      // For admin, create official tutorial
      final tutorialId = 'admin-${DateTime.now().millisecondsSinceEpoch}';

      // Add to official tutorials list
      final newTutorial = {
        'id': tutorialId,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'author': 'ArtFlowRise Team',
        'level': _selectedDifficulty,
        'duration': '${_uploadedImages.length * 5} min', // Estimate duration
        'isOfficial': true,
      };

      officialTutorials.add(newTutorial);

      // Also add to allTutorialsData for detail view
      final steps = _uploadedImages.map((image) {
        return TutorialStep(
          id: 'step-${_uploadedImages.indexOf(image) + 1}',
          title: 'Step ${_uploadedImages.indexOf(image) + 1}',
          description: image['description']!.isNotEmpty ? image['description']! : 'Follow this step in the tutorial.',
          imageUrl: image['path']!,
        );
      }).toList();

      allTutorialsData[tutorialId] = Tutorial(
        id: tutorialId,
        title: _titleController.text,
        steps: steps,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Official tutorial published successfully!')),
      );
    } else {
      // Get current user from AuthBloc
      final authState = context.read<AuthBloc>().state;
      final currentUsername = authState is AuthAuthenticated ? authState.username : 'Unknown User';

      // Add to user tutorials list
      final newTutorial = {
        'id': 'user-${DateTime.now().millisecondsSinceEpoch}',
        'title': _titleController.text,
        'description': _descriptionController.text,
        'author': currentUsername,
        'level': _selectedDifficulty,
        'duration': 'TBD', // Could be calculated or user input
        'isOfficial': false,
        'images': _uploadedImages, // Store the image data with descriptions
      };

      userTutorials.add(newTutorial);

      // Notify listeners so dashboard updates immediately without copying data.
      try {
        userTutorialsNotifier.value = userTutorials;
      } catch (_) {
        // If for any reason notifier isn't available, ignore to avoid crash.
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutorial published successfully!')),
      );
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create Tutorial',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                hintText: 'Enter a short, descriptive title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryBlue),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            const SizedBox(height: 24),

            // Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              textDirection: TextDirection.ltr,
              decoration: InputDecoration(
                hintText: 'Provide details about your tutorial',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryBlue),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
            if (_uploadedImages.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Selected Images (${_uploadedImages.length}/25)',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _uploadedImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(File(_uploadedImages[index]['path']!)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Image ${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _uploadedImages[index]['description']!.isEmpty
                                        ? 'No description added'
                                        : _uploadedImages[index]['description']!,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _uploadedImages[index]['description']!.isEmpty
                                          ? AppTheme.textLight
                                          : AppTheme.textSecondary,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _uploadedImages.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.delete, color: Colors.red),
                              iconSize: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          initialValue: _uploadedImages[index]['description'],
                          textDirection: TextDirection.ltr,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            hintText: 'Add description for this image',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: AppTheme.primaryBlue),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          maxLines: 2,
                          onChanged: (value) {
                            _uploadedImages[index]['description'] = value;
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 24),

            // Category
            const Text(
              'Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryBlue),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(
                    category,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 24),

            // Steps/Images
            const Text(
              'Steps',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add at least 3 images per selection (max 25 per selection, 25 total). Each image must be under 5 MB.',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _selectImages,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade50,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 48,
                      color: AppTheme.primaryBlue,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Select Images',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Difficulty (Optional)
            const Text(
              'Difficulty (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.primaryBlue),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              items: _difficulties.map((difficulty) {
                return DropdownMenuItem(
                  value: difficulty,
                  child: Text(
                    difficulty,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value!;
                });
              },
            ),
            const SizedBox(height: 24),

            // Tags (Optional)
            const Text(
              'Tags (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tagsController,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      hintText: 'Add tags to help others find your tutorial',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppTheme.primaryBlue),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                    onSubmitted: (_) => _addTag(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addTag,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedTags.map((tag) {
                return Chip(
                  label: Text(tag),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => _removeTag(tag),
                  backgroundColor: AppTheme.primaryBlue.withOpacity(0.1),
                  labelStyle: const TextStyle(color: AppTheme.primaryBlue),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),

            // Publish Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _publishTutorial,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryPink,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Publish Tutorial',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}