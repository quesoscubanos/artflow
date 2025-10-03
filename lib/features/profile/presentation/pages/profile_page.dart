import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:artflowrise/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:artflowrise/core/theme/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  final _displayNameController = TextEditingController();
  final _biographyController = TextEditingController();
  String _artisticLevel = 'Principiante';
  File? _profileImage;
  String? _profileImagePath;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    // Get current user ID from AuthBloc
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _currentUserId = authState.userId;
      await _loadProfileData();
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _biographyController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileData() async {
    if (_currentUserId == null) return;

    final prefs = await SharedPreferences.getInstance();

    // Load profile image
    final imagePath = prefs.getString('profile_image_path_$_currentUserId');
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (await file.exists()) {
        _profileImagePath = imagePath;
        _profileImage = file;
      }
    }

    // Load other profile data
    final displayName = prefs.getString('display_name_$_currentUserId');
    final biography = prefs.getString('biography_$_currentUserId');
    final artisticLevel = prefs.getString('artistic_level_$_currentUserId');

    setState(() {
      _displayNameController.text = displayName ?? 'Amante del Arte';
      _biographyController.text = biography ?? 'Apasionado por aprender arte y explorar diferentes técnicas. Me encanta la acuarela y el dibujo!';
      _artisticLevel = artisticLevel ?? 'Principiante';
    });
  }

  Future<void> _saveProfileImage(String path) async {
    if (_currentUserId == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path_$_currentUserId', path);
  }

  Future<void> _saveProfileData() async {
    if (_currentUserId == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('display_name_$_currentUserId', _displayNameController.text);
    await prefs.setString('biography_$_currentUserId', _biographyController.text);
    await prefs.setString('artistic_level_$_currentUserId', _artisticLevel);
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final imagePath = image.path;
        await _saveProfileImage(imagePath);
        setState(() {
          _profileImagePath = imagePath;
          _profileImage = File(imagePath);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al seleccionar imagen')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Perfil',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppTheme.errorColor),
            onPressed: _logout,
            tooltip: 'Cerrar Sesión',
          ),
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Guardar',
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      backgroundImage: _profileImagePath != null ? FileImage(File(_profileImagePath!)) : null,
                      child: _profileImagePath == null
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _displayNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre para Mostrar',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _biographyController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Biografía',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _artisticLevel,
              decoration: const InputDecoration(
                labelText: 'Nivel Artístico',
                border: OutlineInputBorder(),
              ),
              items: ['Principiante', 'Intermedio', 'Avanzado']
                  .map((level) => DropdownMenuItem(
                        value: level,
                        child: Text(level),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _artisticLevel = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    await _saveProfileData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Perfil guardado!')),
    );
  }

  void _logout() {
    context.read<AuthBloc>().add(AuthLogoutRequested());
    context.go('/welcome');
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuración'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar Perfil'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('¡Función de editar perfil próximamente!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.errorColor),
              title: const Text('Cerrar Sesión', style: TextStyle(color: AppTheme.errorColor)),
              onTap: () {
                Navigator.pop(context);
                context.read<AuthBloc>().add(AuthLogoutRequested());
                context.go('/welcome');
              },
            ),
          ],
        ),
      ),
    );
  }
}
