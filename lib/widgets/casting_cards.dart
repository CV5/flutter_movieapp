import 'package:flutter/cupertino.dart';
import 'package:pelicula_flutter_application/models/credits_response.dart';
import 'package:pelicula_flutter_application/providers/movies_providers.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movieID;

  const CastingCards({super.key, required this.movieID});
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    return FutureBuilder(
        future: moviesProvider.getMovieCasts(movieID),
        builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 180,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 30),
              child: const CupertinoActivityIndicator(),
            );
          }

          final List<Cast> casts = snapshot.data!;
          return Container(
              margin: const EdgeInsets.only(bottom: 30),
              width: double.infinity,
              height: 180,
              child: ListView.builder(
                itemCount: casts.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => _CastingCards(
                  cast: casts[index],
                ),
              ));
        });
  }
}

class _CastingCards extends StatelessWidget {
  final Cast cast;

  const _CastingCards({required this.cast});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 110,
        height: 100,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, 'details', arguments: 'movie-'),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                    height: 140,
                    width: 100,
                    fit: BoxFit.cover,
                    placeholder: const AssetImage("assets/no-image.jpg"),
                    image: NetworkImage(cast.fullPosterImg)),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                cast.name,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ));
  }
}
