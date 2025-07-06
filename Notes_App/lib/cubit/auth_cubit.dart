import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoggedIn extends AuthState {
  final String userId;

  AuthLoggedIn(this.userId);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;

  AuthCubit(this._auth) : super(AuthInitial());

  Future<void> signUp(String email, String password) async {
    try {
      emit(AuthLoading());
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthLoggedIn(credentials.user!.uid));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Unknown sign up error'));
    } catch (_) {
      emit(AuthError('Unknown sign up error'));
    }
  }

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthLoggedIn(credentials.user!.uid));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Unknown login error'));
    } catch (_) {
      emit(AuthError('Unknown login error'));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    emit(AuthInitial());
  }
}