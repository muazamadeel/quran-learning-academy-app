import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/navigation/app_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Drawer(
      child: Container(
        color: AppColors.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.darkGreen, AppColors.primaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                user?.name ?? 'User',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white24,
                child: Text(
                  user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 24, color: AppColors.white),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: AppColors.primaryGreen),
              title: const Text('Profile'),
              onTap: () {
                context.pop(); // Close drawer
                context.push(AppRoutes.profile);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.rejected),
              title: const Text(
                'Log Out',
                style: TextStyle(color: AppColors.rejected, fontWeight: FontWeight.w600),
              ),
              onTap: () async {
                context.pop(); // Close drawer first
                await ref.read(authProvider.notifier).signOut();
                if (context.mounted) {
                  context.go(AppRoutes.login);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
