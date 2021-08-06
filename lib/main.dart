import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/ui/pages/home/home_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/providers/profile_provider.dart';
import 'core/repository/repository_provider.dart';
import 'ui/pages/auth/providers/auth_view_model_provider.dart';
import 'ui/pages/welcome/welcome_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final auth = watch(authViewModelProvider);
    return MaterialApp(
      title: 'Grocery',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        accentColor: Colors.indigo,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        )
      ),
      home: auth.user == null
          ? WelcomePage()
          : Builder(
              builder: (context) {
                final profileAsync = watch(profileProvider);
                final repository = context.read(repositoryProvider);
                return profileAsync.when(
                  data: (profile) => HomePage(),
                  loading: () => Scaffold(
                    backgroundColor: Colors.amber,
                  ),
                  error: (e, s) {
                    repository.createProfile().whenComplete(() {
                      context.refresh(profileProvider);
                    });
                    return Scaffold(
                      backgroundColor: Colors.yellow,
                    );
                  },
                );
              },
            ),
    );
  }
}
