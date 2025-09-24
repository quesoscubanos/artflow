import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:artflowrise/core/theme/app_theme.dart';

// Tutorial data model
class Tutorial {
  final String id;
  final String title;
  final List<TutorialStep> steps;

  const Tutorial({
    required this.id,
    required this.title,
    required this.steps,
  });

  int get totalSteps => steps.length;
}

class TutorialStep {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  const TutorialStep({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}

// Mock tutorial data
final Tutorial sampleTutorial = Tutorial(
  id: 'perspective-drawing',
  title: 'Drawing with Perspective',
  steps: [
    TutorialStep(
      id: 'step-1',
      title: 'Draw the Horizon Line',
      description: 'Start by drawing a horizontal line across your paper. This represents the eye level and will be the foundation for your perspective drawing.',
      imageUrl: 'https://via.placeholder.com/400x300/6B9EFF/FFFFFF?text=Horizon+Line',
    ),
    TutorialStep(
      id: 'step-2',
      title: 'Add Vanishing Points',
      description: 'Mark two points on the horizon line, one on each side. These will be your vanishing points where all parallel lines converge.',
      imageUrl: 'https://via.placeholder.com/400x300/FF6B9E/FFFFFF?text=Vanishing+Points',
    ),
    TutorialStep(
      id: 'step-3',
      title: 'Draw Perspective Lines',
      description: 'Connect the vanishing points to create diagonal lines that will guide your drawing. These lines show how objects appear to get smaller as they recede.',
      imageUrl: 'https://via.placeholder.com/400x300/95A5A6/FFFFFF?text=Perspective+Lines',
    ),
    TutorialStep(
      id: 'step-4',
      title: 'Add Basic Shapes',
      description: 'Using the perspective lines as guides, draw basic shapes like cubes or boxes. Make sure the edges align with your perspective lines.',
      imageUrl: 'https://via.placeholder.com/400x300/2D3436/FFFFFF?text=Basic+Shapes',
    ),
    TutorialStep(
      id: 'step-5',
      title: 'Refine the Drawing',
      description: 'Add details and refine your shapes. Remember that objects closer to you should appear larger and more detailed.',
      imageUrl: 'https://via.placeholder.com/400x300/6B9EFF/FFFFFF?text=Refine+Drawing',
    ),
    TutorialStep(
      id: 'step-6',
      title: 'Add Shading',
      description: 'Add shadows and highlights to give your drawing depth and dimension. Light sources should be consistent throughout your drawing.',
      imageUrl: 'https://via.placeholder.com/400x300/FF6B9E/FFFFFF?text=Add+Shading',
    ),
    TutorialStep(
      id: 'step-7',
      title: 'Final Touches',
      description: 'Review your work and add any final details. Your perspective drawing should now show proper depth and realism.',
      imageUrl: 'https://via.placeholder.com/400x300/95A5A6/FFFFFF?text=Final+Touches',
    ),
  ],
);

class TutorialDetailPage extends StatefulWidget {
  final String tutorialId;
  final int initialStep;

  const TutorialDetailPage({
    super.key,
    required this.tutorialId,
    this.initialStep = 0,
  });

  @override
  State<TutorialDetailPage> createState() => _TutorialDetailPageState();
}

class _TutorialDetailPageState extends State<TutorialDetailPage> {
  late int currentStepIndex;
  late Tutorial tutorial;

  @override
  void initState() {
    super.initState();
    // In a real app, you'd fetch the tutorial by ID
    tutorial = sampleTutorial;
    currentStepIndex = widget.initialStep.clamp(0, tutorial.steps.length - 1);
  }

  TutorialStep get currentStep => tutorial.steps[currentStepIndex];
  double get progress => (currentStepIndex + 1) / tutorial.totalSteps;

  void _goToPrevious() {
    if (currentStepIndex > 0) {
      setState(() {
        currentStepIndex--;
      });
    }
  }

  void _goToNext() {
    if (currentStepIndex < tutorial.steps.length - 1) {
      setState(() {
        currentStepIndex++;
      });
    }
  }

  void _markAsCompleted() {
    // In a real app, you'd save progress to a database
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tutorial marked as completed!'),
        backgroundColor: AppTheme.primaryBlue,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => context.go('/tutorials'),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tutorial title
            Container(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                tutorial.title,
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
                    'Step ${currentStepIndex + 1} of ${tutorial.totalSteps}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppTheme.inputFillColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                  ),
                ],
              ),
            ),

            // Tutorial image
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
                minHeight: 200,
              ),
              child: Image.network(
                currentStep.imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: AppTheme.inputFillColor,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                      ),
                    ),
                  );
                },
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
                    currentStep.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Step description
                  Text(
                    currentStep.description,
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
                          onPressed: currentStepIndex < tutorial.steps.length - 1 ? _goToNext : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            currentStepIndex < tutorial.steps.length - 1 ? 'Next' : 'Complete',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Mark as completed button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _markAsCompleted,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppTheme.primaryPink),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Mark as Completed',
                        style: TextStyle(
                          color: AppTheme.primaryPink,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}