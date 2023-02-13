import 'package:flutter/material.dart';
import 'package:pelicula_flutter_application/providers/movies_providers.dart';
import 'package:pelicula_flutter_application/search/search_delegate.dart';

import 'package:pelicula_flutter_application/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProviders = Provider.of<MoviesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: MovieSearchDelegate()),
            icon: const Icon(Icons.search_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwiper(movies: moviesProviders.onDisplaysMovies),
            MovieSlider(
              title: "Populars",
              onNextPage: () => moviesProviders.getPopulars(),
            )
          ],
        ),
      ),
    );
  }
}
