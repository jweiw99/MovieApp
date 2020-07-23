import 'package:flutter/material.dart';

//Api
import 'package:movieapp/src/api/httpRequest.dart';
import 'package:movieapp/src/api/apiConfig.dart';

// Model
import 'package:movieapp/src/model/movie.model.dart';
import 'package:movieapp/src/model/movieDetail.model.dart';
import 'package:movieapp/src/model/cast.model.dart';
import 'package:movieapp/src/model/crew.model.dart';

class MovieAPIClient {
  MovieAPIClient(this._context);

  BuildContext _context;
  final HttpRequest _httpRequest = HttpRequest(APIConfig.apiurl);

  Future<List<Movie>> getNowPlayingMovie({int page = 1}) async {
    final String language = Localizations.localeOf(_context).languageCode;
    final String countryCode = Localizations.localeOf(_context).countryCode;
    final String param =
        '/movie/now_playing?api_key=${APIConfig.apikey}&language=$language&page=$page&region=$countryCode';
    final responseData = await _httpRequest.getData(param) ?? [];
    final data =
        responseData['results'].map((item) => Movie.fromMapObject(item));

    // convert to movie
    final List<Movie> movie = [];
    for (Movie m in data) {
      movie.add(m);
    }
    return movie;
  }

  Future<List<Movie>> getUpcomingMovie({int page = 1}) async {
    final String language = Localizations.localeOf(_context).languageCode;
    final String countryCode = Localizations.localeOf(_context).countryCode;
    final String param =
        '/movie/upcoming?api_key=${APIConfig.apikey}&language=$language&page=$page&region=$countryCode';
    final responseData = await _httpRequest.getData(param) ?? [];
    final data =
        responseData['results'].map((item) => Movie.fromMapObject(item));

    // convert to movie
    final List<Movie> movie = [];
    for (Movie m in data) {
      movie.add(m);
    }
    return movie;
  }

  Future<MovieDetail> getMovieDetails(
      int movieID, String appendToResponse) async {
    final String language = Localizations.localeOf(_context).languageCode;
    final String param =
        '/movie/$movieID?api_key=${APIConfig.apikey}&language=$language&append_to_response=$appendToResponse';
    final responseData = await _httpRequest.getData(param) ?? MovieDetail();
    final MovieDetail movie = MovieDetail.fromMapObject(responseData);
    return movie;
  }

  Future<MovieDetail> getCastList(int movieID) async {
    final String param = '/movie/$movieID/credits?api_key=${APIConfig.apikey}';
    final responseData = await _httpRequest.getData(param) ?? [];
    final castdata =
        responseData['cast'].map((item) => Cast.fromMapObject(item));
    final crewdata =
        responseData['crew'].map((item) => Crew.fromMapObject(item));

    // convert to cast
    final List<Cast> cast = [];
    for (Cast m in castdata) {
      cast.add(m);
    }
    final List<Crew> crew = [];
    for (Crew m in crewdata) {
      crew.add(m);
    }

    // add into moviedetail
    MovieDetail movieDetail = MovieDetail();
    movieDetail.casts = cast;
    movieDetail.crews = crew;
    return movieDetail;
  }
}
