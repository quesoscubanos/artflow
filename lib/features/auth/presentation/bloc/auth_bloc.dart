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
final List<MockUser> _users = [
  MockUser(
    email: 'usuario1@gmail.com',
    password: 'P@ssw0rd1!',
    username: 'User1',
    isAdmin: false,
  ),
  MockUser(
    email: 'admin@gmail.com',
    password: 'AdminP@ss1!',
    username: 'Admin',
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
      // Check against users
      final user = _users.firstWhere(
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
      final existingUser = _users.firstWhere(
        (user) => user.email == event.email,
        orElse: () => MockUser(email: '', password: '', username: '', isAdmin: false),
      );

      if (existingUser.email.isNotEmpty) {
        throw Exception('User already exists');
      }

      // Add new user
      _users.add(MockUser(
        email: event.email,
        password: event.password,
        username: event.username,
        isAdmin: false,
      ));

      print('Registered user: ${event.username}, ${event.email}');
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