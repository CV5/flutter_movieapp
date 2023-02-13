// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:pelicula_flutter_application/models/model.dart';
import 'package:provider/provider.dart';
import '../providers/movies_providers.dart';

class MovieSlider extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final title;
  final Function onNextPage;

  const MovieSlider({super.key, this.title, required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      print(scrollController.position.pixels);
      print(scrollController.position.maxScrollExtent);

      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 700) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final popularProvider = Provider.of<MoviesProvider>(context);

    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: popularProvider.popularsMovies.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => _MoviePoster(
                popularsMovies: popularProvider.popularsMovies,
                index: index,
                heroId:
                    '${widget.title}-${index.toString()}-${popularProvider.popularsMovies[index].id}',
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final List<Movie> popularsMovies;
  // ignore: prefer_typing_uninitialized_variables
  final index;
  // ignore: prefer_typing_uninitialized_variables
  final heroId;

  const _MoviePoster(
      {required this.popularsMovies, required this.index, this.heroId});

  @override
  Widget build(BuildContext context) {
    popularsMovies[index].heroId = heroId;
    return Container(
        width: 130,
        height: 190,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, 'details',
              arguments: popularsMovies[index]),
          child: Column(
            children: [
              Hero(
                tag: popularsMovies[index].heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                      width: 130,
                      height: 190,
                      fit: BoxFit.cover,
                      placeholder: const AssetImage("assets/no-image.jpg"),
                      image: NetworkImage(popularsMovies[index].fullPosterImg)),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                popularsMovies[index].title,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ));
  }
}
