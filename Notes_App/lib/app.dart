import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'presentation/screens/login_screen.dart';
import 'presentation/screens/signup_screen.dart';
import 'presentation/screens/notes_screen.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/note_cubit.dart';
// ← Correct this import:
import 'data/repositories/note_repository.dart';

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(FirebaseAuth.instance),
        ),
        BlocProvider(
          create: (_) => NoteCubit(NoteRepository(FirebaseFirestore.instance)),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mini Notes App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/notes': (context) => const NotesScreen(),
        },
      ),
    );
  }
}
