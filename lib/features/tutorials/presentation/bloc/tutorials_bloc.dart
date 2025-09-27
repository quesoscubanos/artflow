import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

// Events
abstract class TutorialsEvent {}

class LoadTutorials extends TutorialsEvent {}

class UploadTutorial extends TutorialsEvent {
  final String title;
  final String description;
  final String author;
  final String level;
  final String duration;
  final XFile image;

  UploadTutorial({
    required this.title,
    required this.description,
    required this.author,
    required this.level,
    required this.duration,
    required this.image,
  });
}

// States
abstract class TutorialsState {}

class TutorialsInitial extends TutorialsState {}

class TutorialsLoading extends TutorialsState {}

class TutorialsLoaded extends TutorialsState {
  final List<Map<String, dynamic>> tutorials;

  TutorialsLoaded(this.tutorials);
}

class TutorialsError extends TutorialsState {
  final String message;

  TutorialsError(this.message);
}

// BLoC
class TutorialsBloc extends Bloc<TutorialsEvent, TutorialsState> {
  final List<Map<String, dynamic>> _tutorials = [
    {
      'id': '1',
      'title': 'Drawing Fundamentals',
      'description': 'Learn the basics of drawing',
      'author': 'ArtFlowRise Team',
      'level': 'Beginner',
      'duration': '45 min',
      'isOfficial': true,
      'imagePath': null,
    },
    {
      'id': 'perspective-drawing',
      'title': 'Drawing with Perspective',
      'description': 'Master perspective techniques',
      'author': 'ArtFlowRise Team',
      'level': 'Intermediate',
      'duration': '60 min',
      'isOfficial': true,
      'imagePath': null,
    },
    {
      'id': '3',
      'title': 'Color Theory',
      'description': 'Understanding colors and harmony',
      'author': 'Color_Expert',
      'level': 'Beginner',
      'duration': '30 min',
      'isOfficial': true,
      'imagePath': null,
    },
    {
      'id': '4',
      'title': 'Portrait Techniques',
      'description': 'Drawing realistic portraits',
      'author': 'Portrait_Master',
      'level': 'Advanced',
      'duration': '90 min',
      'isOfficial': true,
      'imagePath': null,
    },
  ];

  TutorialsBloc() : super(TutorialsInitial()) {
    on<LoadTutorials>(_onLoadTutorials);
    on<UploadTutorial>(_onUploadTutorial);
  }

  void _onLoadTutorials(LoadTutorials event, Emitter<TutorialsState> emit) {
    emit(TutorialsLoaded(_tutorials));
  }

  Future<void> _onUploadTutorial(UploadTutorial event, Emitter<TutorialsState> emit) async {
    emit(TutorialsLoading());

    try {
      // Validate image size (max 5MB)
      final file = File(event.image.path);
      final fileSize = await file.length();
      const maxSize = 5 * 1024 * 1024; // 5MB in bytes

      if (fileSize > maxSize) {
        emit(TutorialsError('Image size exceeds 5MB limit'));
        return;
      }

      // Add new tutorial
      final newTutorial = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': event.title,
        'description': event.description,
        'author': event.author,
        'level': event.level,
        'duration': event.duration,
        'isOfficial': true,
        'imagePath': event.image.path, // Store file path for demo
      };

      _tutorials.add(newTutorial);
      emit(TutorialsLoaded(_tutorials));
    } catch (e) {
      emit(TutorialsError('Failed to upload tutorial: ${e.toString()}'));
    }
  }
}