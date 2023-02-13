import 'package:flutter/material.dart';
import 'package:pelicula_flutter_application/providers/movies_providers.dart';
import 'package:provider/provider.dart';
import 'screens/screens.dart';

void main() => runApp(const MyStateApp());

//este widget me ayuda a manejar el estado de mi app
class MyStateApp extends StatelessWidget {
  const MyStateApp({super.key});

  @override
  Widget build(BuildContext context) {
    //se llama el widget multiprovider por si necesito mas provdores en un futuro.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MoviesProvider(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Películas App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (_) => const HomeScreens(),
        'details': (_) => const DetailsScreens()
      },
      theme: ThemeData.light()
          .copyWith(appBarTheme: const AppBarTheme(color: Colors.indigo)),
    );
  }
}
