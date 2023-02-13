import 'package:flutter/material.dart';
import 'package:pelicula_flutter_application/models/model.dart';
import 'package:pelicula_flutter_application/providers/movies_providers.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  Widget _emptyContainer() {
    return const Center(
        child: Icon(
      Icons.movie_outlined,
      size: 130,
      color: Colors.grey,
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }

    final movieProvider = Provider.of<MoviesProvider>(context, listen: false);
    movieProvider.getSuggetionsByQuery(query);

    return StreamBuilder(
      stream: movieProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> asyncSnapshot) {
        // print(asyncSnapshot);

        if (!asyncSnapshot.hasData) return _emptyContainer();

        final List<Movie>? movies = asyncSnapshot.data;

        return ListView.builder(
          itemCount: movies?.length,
          itemBuilder: (_, int index) {
            return MovieItem(
              movie: movies![index],
            );
          },
        );
      },
    );
  }
}

class MovieItem extends StatelessWidget {
  final Movie movie;
  const MovieItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${movie.id}';
    return ListTile(
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: () {
          Navigator.pushNamed(context, 'details', arguments: movie);
        },
        leading: Hero(
          tag: movie.heroId!,
          child: FadeInImage(
            placeholder: const AssetImage("assets/no-image.jpg"),
            image: NetworkImage(movie.fullPosterImg),
            width: 50,
            fit: BoxFit.contain,
          ),
        ));
  }
}
