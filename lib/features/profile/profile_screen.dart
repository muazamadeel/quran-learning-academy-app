import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quran_learning_app/core/theme/app_theme.dart';
import 'package:quran_learning_app/provider/auth/auth_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _imageController = TextEditingController(text: user?.profileImage ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    final success = await ref.read(authProvider.notifier).updateProfile(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      profileImage: _imageController.text.trim(),
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
        context.pop(); // Go back after updating
      } else {
        final error = ref.read(authProvider).error ?? 'Failed to update profile';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.rejected,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    
    if (user == null) {
      return const Scaffold(body: Center(child: Text('No user found')));
    }

    final isStudent = user.role == 'student';
    final roleText = isStudent ? 'Student' : 'Teacher';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Update Profile'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.white,
      ),
      body: authState.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Image Preview
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
                            backgroundImage: _imageController.text.trim().isNotEmpty 
                                ? NetworkImage(_imageController.text.trim()) 
                                : null,
                            child: _imageController.text.trim().isEmpty
                                ? Text(
                                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                                    style: const TextStyle(
                                      fontSize: 40,
                                      color: AppColors.primaryGreen,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : null,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: AppColors.primaryGreen,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.camera_alt, color: AppColors.white, size: 20),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Role Badge
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '$roleText Profile',
                          style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: const Icon(Icons.person_outline, color: AppColors.primaryGreen),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                        ),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Phone Field
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primaryGreen),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Image URL Field
                    TextFormField(
                      controller: _imageController,
                      decoration: InputDecoration(
                        labelText: 'Profile Image URL (Optional)',
                        prefixIcon: const Icon(Icons.image_outlined, color: AppColors.primaryGreen),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
                        ),
                      ),
                      onChanged: (_) => setState(() {}), // Refresh preview
                    ),
                    const SizedBox(height: 16),

                    // Email Field (Read-only)
                    TextFormField(
                      initialValue: user.email,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        fillColor: Colors.grey.shade100,
                        filled: true,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Update Button
                    ElevatedButton(
                      onPressed: _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
