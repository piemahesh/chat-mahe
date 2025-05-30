import 'package:flutter/material.dart';
import 'package:flutter_my_app/core/services/index.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../auth/bloc/auth_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});



  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              AppStrings.appTitle,
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              context.pop(); // Close the drawer
              context.go('/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About'),
            onTap: () {
              context.pop();
              context.go('/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Terms and Conditions'),
            onTap: () {
              context.pop();
              context.go('/terms');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // context.read<AuthBloc>().add(AuthLogoutRequested())
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
