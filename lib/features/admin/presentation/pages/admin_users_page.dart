import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:artflowrise/core/theme/app_theme.dart';
import 'package:artflowrise/features/auth/presentation/bloc/auth_bloc.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  late AuthBloc _authBloc;
  List<MockUser> _users = [];

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _users = _authBloc.getAllUsers();
    });
  }

  void _showCreateUserDialog() {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Create New User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Create new user
              final newId = (_users.length + 1).toString();
              final joinDate = DateTime.now().toIso8601String().split('T').first;

              final newUser = MockUser(
                id: newId,
                email: emailController.text,
                password: passwordController.text, // In real app, hash this
                username: usernameController.text,
                isAdmin: false,
                joinDate: joinDate,
              );

              await _authBloc.addUser(newUser);
              _loadUsers(); // Refresh the list

              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User created successfully')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditUserDialog(MockUser user) {
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Edit User'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _authBloc.updateUser(
                user.id,
                username: usernameController.text,
                email: emailController.text,
              );
              _loadUsers(); // Refresh the list
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User updated successfully')),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(MockUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.username}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _authBloc.deleteUser(user.id);
              _loadUsers(); // Refresh the list
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User deleted successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
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
        title: const Text(
          'Users',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppTheme.primaryBlue),
            onPressed: _showCreateUserDialog,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: user.isAdmin ? AppTheme.primaryBlue : AppTheme.primaryPink,
                child: Icon(
                  user.isAdmin ? Icons.admin_panel_settings : Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Text(
                user.username,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.email),
                  Text(
                    'Joined: ${user.joinDate}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'edit':
                      _showEditUserDialog(user);
                      break;
                    case 'delete':
                      _deleteUser(user);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}