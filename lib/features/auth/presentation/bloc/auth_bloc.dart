import 'package:flutter_bloc/flutter_bloc.dart';

// Mock user data
class MockUser {
  final String email;
  final String password;
  final String username;
  final bool isAdmin;

  const MockUser({
    required this.email,
    required this.password,
    required this.username,
    this.isAdmin = false,
  });
}

// Default users for testing
const List<MockUser> _mockUsers = [
  MockUser(
    email: 'user@example.com',
    password: 'password',
    username: 'Regular User',
    isAdmin: false,
  ),
  MockUser(
    email: 'admin@example.com',
    password: 'admin123',
    username: 'Admin User',
    isAdmin: true,
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

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final bool isAdmin;
  final String username;

  AuthAuthenticated({required this.isAdmin, required this.username});
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthLoginRequested>(_onAuthLoginRequested);
    on<AuthRegisterRequested>(_onAuthRegisterRequested);
    on<AuthLogoutRequested>(_onAuthLogoutRequested);
  }

  void _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) {
    // TODO: Check if user is authenticated
    emit(AuthUnauthenticated());
  }

  void _onAuthLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Check against mock users
      final user = _mockUsers.firstWhere(
        (user) => user.email == event.email && user.password == event.password,
        orElse: () => throw Exception('Invalid credentials'),
      );

      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      emit(AuthAuthenticated(isAdmin: user.isAdmin, username: user.username));
    } catch (e) {
      emit(AuthError('Login failed: Invalid email or password'));
    }
  }

  void _onAuthRegisterRequested(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // Check if user already exists
      final existingUser = _mockUsers.firstWhere(
        (user) => user.email == event.email,
        orElse: () => MockUser(email: '', password: '', username: '', isAdmin: false),
      );

      if (existingUser.email.isNotEmpty) {
        throw Exception('User already exists');
      }

      // For demo purposes, create a new regular user
      print('Registering user: ${event.username}, ${event.email}');
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      emit(AuthAuthenticated(isAdmin: false, username: event.username));
    } catch (e) {
      emit(AuthError('Registration failed: ${e.toString()}'));
    }
  }

  void _onAuthLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) {
    // TODO: Implement logout logic
    emit(AuthUnauthenticated());
  }
}