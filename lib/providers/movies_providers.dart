import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pelicula_flutter_application/helpers/debouncer.dart';
import 'package:pelicula_flutter_application/models/model.dart';
import 'package:pelicula_flutter_application/models/search_response.dart';

import '../models/populars_movie_response.dart';

class MoviesProvider extends ChangeNotifier {
  List<Movie> onDisplaysMovies = [];
  List<Movie> popularsMovies = [];
  final apiKey = "5110c2ffb961f60c4c011941a7662dd1";
  final language = "es-ES";
  int _popularPage = 0;

  Map<int, List<Cast>> movieCast = {};

  final debouncer = Debouncer(duration: const Duration(milliseconds: 500));

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  MoviesProvider() {
    // print("empece a funcionar osea inicialicé");
    getLatesMovies();
    getPopulars();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https('api.themoviedb.org', endpoint,
        {'api_key': apiKey, 'language': language, 'page': '$page'});
    var response = await http.get(url);
    return response.body;
  }

  getLatesMovies() async {
    // print("get Latest movies");
    final jsonData = await _getJsonData("3/movie/now_playing");
    final jsonResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplaysMovies = jsonResponse.results;
    notifyListeners();
  }

  getPopulars() async {
    _popularPage++;
    final jsonData = await _getJsonData("3/movie/popular", _popularPage);
    final jsonResponse = PopularMovieResponse.fromJson(jsonData);
    popularsMovies = [...popularsMovies, ...jsonResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getMovieCasts(int movieId) async {
    if (movieCast.containsKey(movieId)) return movieCast[movieId]!;
    final jsonData = await _getJsonData("3/movie/$movieId/credits");
    final castResponse = CreditsResponse.fromJson(jsonData);
    movieCast[movieId] = castResponse.cast;
    return castResponse.cast;
  }

  Future<List<Movie>> searchMovie(String query) async {
    var url = Uri.https('api.themoviedb.org', '3/search/movie',
        {'api_key': apiKey, 'language': language, 'query': query});
    var response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    // ignore: avoid_print
    print(searchResponse.results);
    return searchResponse.results;
  }

  void getSuggetionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      // ignore: avoid_print
      print('Tenemos valor a buscar: $value');

      final result = await searchMovie(value);
      _suggestionStreamController.add(result);
    };

    final timer = Timer.periodic(const Duration(microseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((value) => timer.cancel());
  }
}
