import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:artflowrise/core/theme/app_theme.dart';

class UserPublicationDetailPage extends StatefulWidget {
  final Map<String, dynamic> publication;

  const UserPublicationDetailPage({
    super.key,
    required this.publication,
  });

  @override
  State<UserPublicationDetailPage> createState() => _UserPublicationDetailPageState();
}

class _UserPublicationDetailPageState extends State<UserPublicationDetailPage> {
  int currentStepIndex = 0;

  List<Map<String, String>> get images => List<Map<String, String>>.from(widget.publication['images'] ?? []);
  int get totalSteps => images.length;
  double get progress => totalSteps > 0 ? (currentStepIndex + 1) / totalSteps : 0;

  void _goToPrevious() {
    if (currentStepIndex > 0) {
      setState(() {
        currentStepIndex--;
      });
    }
  }

  void _goToNext() {
    if (currentStepIndex < images.length - 1) {
      setState(() {
        currentStepIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Publication Detail'),
        ),
        body: const Center(
          child: Text('No images available'),
        ),
      );
    }

    final currentImage = images[currentStepIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.publication['title'] ?? 'Publication',
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Publication title
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                widget.publication['title'] ?? 'Untitled Publication',
                textDirection: TextDirection.ltr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),

            // Progress indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step ${currentStepIndex + 1} of $totalSteps',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.primaryPink,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                  ),
                ],
              ),
            ),

            // Publication image
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
                minHeight: 200,
              ),
              child: Image.file(
                File(currentImage['path']!),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppTheme.inputFillColor,
                    child: const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 64,
                        color: AppTheme.textLight,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Step content
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step title
                  Text(
                    'Image ${currentStepIndex + 1}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Step description
                  Text(
                    currentImage['description']?.isNotEmpty == true
                        ? currentImage['description']!
                        : 'No description provided for this image.',
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Navigation buttons
                  Row(
                    children: [
                      // Previous button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: currentStepIndex > 0 ? _goToPrevious : null,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppTheme.primaryBlue),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Previous',
                            style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Next button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: currentStepIndex < images.length - 1 ? _goToNext : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            currentStepIndex < images.length - 1 ? 'Next' : 'Complete',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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
    );
  }
}