import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsi/network/base_network.dart';
import 'package:responsi/presenters/favorite_presenter.dart';
import 'package:responsi/presenters/movie_presenter.dart';
import 'package:responsi/views/movie_list_screen.dart';
import 'package:responsi/views/favorite_screen.dart';
import 'package:responsi/utils/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = SharedPrefs();
  
  runApp(
    MultiProvider(
      providers: [
        Provider<SharedPrefs>(create: (_) => sharedPrefs),
        Provider<BaseNetwork>(create: (_) => BaseNetwork()),
        ChangeNotifierProvider(
          create: (context) => MoviePresenter(context.read<BaseNetwork>()),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoritePresenter(sharedPrefs)
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MovieListScreen(),
        '/favorites': (context) => const FavoriteScreen()
      },
    );
  }
}