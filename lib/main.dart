import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ui/pages/auth/add_area_page.dart';
import 'ui/pages/auth/create_account_page.dart';
import 'ui/pages/home/home_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/providers/profile_provider.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Kisan Nest',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: Color(0xFFfcbf49),
        accentColor: Color(0xFF003049),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        buttonTheme: ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
        cardTheme: CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
      ),
      home: auth.user == null
          ? WelcomePage()
          : Builder(
              builder: (context) {
                final profileAsync = watch(profileProvider);
                return profileAsync.when(
                  data: (profile) =>
                      profile.ready ? HomePage() : AreaPickPage(),
                  loading: () => Scaffold(
                    backgroundColor: Colors.amber,
                  ),
                  error: (e, s) {
                    return CreateAccountPage();
                  },
                );
              },
            ),
    );
  }
}

