import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_learning_app/core/service/notification_service.dart';
import 'package:quran_learning_app/models/auth/user_model.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  bool get isAuthenticated => user != null;
  bool get isStudent => user?.role == 'student';
  bool get isTeacher => user?.role == 'teacher';

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  @override
  AuthState build() {
    _listenToAuth();
    return const AuthState(isLoading: true);
  }

  void _listenToAuth() {
    _auth.authStateChanges().listen((firebaseUser) async {
      if (firebaseUser == null) {
        state = const AuthState(isLoading: false);
        return;
      }
      try {
        final doc = await _db.collection('users').doc(firebaseUser.uid).get();
        if (doc.exists && doc.data() != null) {
          final data = <String, dynamic>{'id': firebaseUser.uid, ...doc.data()!};
          if (data['createdAt'] is Timestamp) {
            data['createdAt'] =
                (data['createdAt'] as Timestamp).toDate().toIso8601String();
          }
          state = AuthState(user: UserModel.fromJson(data));
        } else {
          state = const AuthState(isLoading: false);
        }
      } catch (e) {
        state = AuthState(isLoading: false, error: e.toString());
      }
    });
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    Map<String, dynamic>? extraData,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = cred.user!.uid;
      final userModel = UserModel(
        id: uid,
        email: email.trim(),
        name: name.trim(),
        role: role,
        createdAt: DateTime.now().toIso8601String(),
      );
      await _db.collection('users').doc(uid).set({
        ...userModel.toJson(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      await cred.user!.updateDisplayName(name.trim());
      
      // Update FCM Token
      await _updateFCMToken(uid);
      
      state = AuthState(user: userModel);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: _mapError(e.code));
      return false;
    } catch (_) {
      state = state.copyWith(
          isLoading: false, error: 'Something went wrong. Please try again.');
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Update FCM Token
      await _updateFCMToken(cred.user!.uid);

      // Fetch user explicitly to avoid race condition with authStateChanges
      final doc = await _db.collection('users').doc(cred.user!.uid).get();
      if (doc.exists && doc.data() != null) {
        final data = <String, dynamic>{'id': cred.user!.uid, ...doc.data()!};
        if (data['createdAt'] is Timestamp) {
          data['createdAt'] =
              (data['createdAt'] as Timestamp).toDate().toIso8601String();
        }
        state = AuthState(user: UserModel.fromJson(data), isLoading: false);
      } else {
        state = const AuthState(isLoading: false);
      }
      
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: _mapError(e.code));
      return false;
    } catch (_) {
      state = state.copyWith(
          isLoading: false, error: 'Something went wrong. Please try again.');
      return false;
    }
  }

  Future<void> _updateFCMToken(String uid) async {
    try {
      final token = await NotificationService.getFCMToken();
      if (token != null) {
        await _db.collection('users').doc(uid).update({
          'fcmToken': token,
          'lastTokenUpdate': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {
      // Non-critical, ignore
    }
  }

  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(isLoading: false, error: _mapError(e.code));
      return false;
    } catch (_) {
      state = state.copyWith(
          isLoading: false, error: 'Failed to send reset email. Try again.');
      return false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? profileImage,
  }) async {
    final user = state.user;
    if (user == null) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name.trim();
      if (phone != null) updates['phone'] = phone.trim();
      if (profileImage != null) updates['profileImage'] = profileImage;

      if (updates.isEmpty) {
        state = state.copyWith(isLoading: false);
        return true;
      }

      await _db.collection('users').doc(user.id).update(updates);
      
      if (name != null) {
        await _auth.currentUser?.updateDisplayName(name.trim());
      }
      if (profileImage != null) {
        await _auth.currentUser?.updatePhotoURL(profileImage);
      }

      final updatedUser = user.copyWith(
        name: name?.trim() ?? user.name,
        phone: phone?.trim() ?? user.phone,
        profileImage: profileImage ?? user.profileImage,
      );
      
      state = AuthState(user: updatedUser);
      return true;
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Failed to update profile.');
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = const AuthState(isLoading: false);
  }

  String _mapError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'invalid-credential':
      case 'wrong-password':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
