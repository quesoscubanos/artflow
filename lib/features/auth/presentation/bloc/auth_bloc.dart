import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Mock user data
class MockUser {
  final String id;
  final String email;
  final String password;
  final String username;
  final bool isAdmin;
  final String joinDate;

  const MockUser({
    required this.id,
    required this.email,
    required this.password,
    required this.username,
    this.isAdmin = false,
    required this.joinDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'username': username,
      'isAdmin': isAdmin,
      'joinDate': joinDate,
    };
  }

  factory MockUser.fromJson(Map<String, dynamic> json) {
    return MockUser(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      username: json['username'],
      isAdmin: json['isAdmin'] ?? false,
      joinDate: json['joinDate'],
    );
  }
}

// Default users for testing
List<MockUser> _users = [
  MockUser(
    id: '1',
    email: 'usuario1@gmail.com',
    password: 'P@ssw0rd1!',
    username: 'User1',
    isAdmin: false,
    joinDate: '2024-01-15',
  ),
  MockUser(
    id: '2',
    email: 'admin@gmail.com',
    password: 'AdminP@ss1!',
    username: 'Admin',
    isAdmin: true,
    joinDate: '2024-01-01',
  ),
];

// Events
abstract class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested({required this.email, required this.password});
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;

  AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.username,
  });
}

class AuthLogoutRequested extends AuthEvent {}

class AuthGetAllUsersRequested extends AuthEvent {}

class AuthUpdateUserRequested extends AuthEvent {
  final String userId;
  final String? username;
  final String? email;
  final bool? isAdmin;

  AuthUpdateUserRequested({
    required this.userId,
    this.username,
    this.email,
    this.isAdmin,
  });
}

class AuthDeleteUserRequested extends AuthEvent {
  final String userId;

  AuthDeleteUserRequested({required this.userId});
}

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final bool isAdmin;
  final String username;
  final String userId;

  AuthAuthenticated({required this.isAdmin, required this.username, required this.userId});
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    _loadUsers();
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
    on<AuthGetAllUsersRequested>(_onAuthGetAllUsersRequested);
    on<AuthUpdateUserRequested>(_onAuthUpdateUserRequested);
    on<AuthDeleteUserRequested>(_onAuthDeleteUserRequested);
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString('users');
    if (usersJson != null) {
      final usersList = jsonDecode(usersJson) as List;
      _users = usersList.map((user) => MockUser.fromJson(user)).toList();
    }
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = jsonEncode(_users.map((user) => user.toJson()).toList());
    await prefs.setString('users', usersJson);
  }

  List<MockUser> getAllUsers() {
    return List.unmodifiable(_users);
  }

  Future<void> updateUser(String userId, {String? username, String? email, bool? isAdmin}) async {
    final userIndex = _users.indexWhere((user) => user.id == userId);
    if (userIndex != -1) {
      final updatedUser = MockUser(
        id: _users[userIndex].id,
        email: email ?? _users[userIndex].email,
        password: _users[userIndex].password,
        username: username ?? _users[userIndex].username,
        isAdmin: isAdmin ?? _users[userIndex].isAdmin,
        joinDate: _users[userIndex].joinDate,
      );
      _users[userIndex] = updatedUser;
      await _saveUsers();
    }
  }

  Future<void> deleteUser(String userId) async {
    _users.removeWhere((user) => user.id == userId);
    await _saveUsers();
  }

  Future<void> addUser(MockUser user) async {
    _users.add(user);
    await _saveUsers();
  }

  void _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }

  void _onAuthLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Check against users
      final user = _users.firstWhere(
        (user) => user.email == event.email && user.password == event.password,
        orElse: () => throw Exception('Invalid credentials'),
      );

      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      emit(AuthAuthenticated(isAdmin: user.isAdmin, username: user.username, userId: user.id));
    } catch (e) {
      emit(AuthError('Login failed: Invalid email or password'));
    }
  }

  void _onAuthRegisterRequested(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Check if user already exists
      final existingUser = _users.firstWhere(
        (user) => user.email == event.email,
        orElse: () => MockUser(id: '', email: '', password: '', username: '', isAdmin: false, joinDate: ''),
      );

      if (existingUser.email.isNotEmpty) {
        throw Exception('User already exists');
      }

      // Generate new user ID
      final newId = (_users.length + 1).toString();
      final joinDate = DateTime.now().toIso8601String().split('T').first;

      // Add new user
      _users.add(MockUser(
        id: newId,
        email: event.email,
        password: event.password,
        username: event.username,
        isAdmin: false,
        joinDate: joinDate,
      ));

      debugPrint('Registered user: ${event.username}, ${event.email}');
      await _saveUsers();
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      final newUser = _users.last; // The newly added user
      emit(AuthAuthenticated(isAdmin: false, username: event.username, userId: newUser.id));
    } catch (e) {
      emit(AuthError('Registration failed: ${e.toString()}'));
    }
  }

  void _onAuthLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }

  void _onAuthGetAllUsersRequested(AuthGetAllUsersRequested event, Emitter<AuthState> emit) {
    // This event doesn't change state, just provides data
    // The admin page will call getAllUsers() directly
  }

  void _onAuthUpdateUserRequested(AuthUpdateUserRequested event, Emitter<AuthState> emit) async {
    await updateUser(
      event.userId,
      username: event.username,
      email: event.email,
      isAdmin: event.isAdmin,
    );
    // Emit current state to trigger UI updates if needed
    // For now, admin page will handle the update
  }

  void _onAuthDeleteUserRequested(AuthDeleteUserRequested event, Emitter<AuthState> emit) async {
    await deleteUser(event.userId);
    // Emit current state to trigger UI updates if needed
  }
}