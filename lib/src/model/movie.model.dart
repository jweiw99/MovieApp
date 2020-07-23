import 'package:movieapp/src/api/apiConfig.dart';

class Movie {
  double popularity;
  int voteCount;
  bool video;
  String posterPath;
  int id;
  bool adult;
  String backdropPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String title;
  double voteAverage;
  String overview;
  String releaseDate;

  Movie({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });

  Movie.fromMapObject(Map<dynamic, dynamic> map) {
    this.popularity = double.parse(map['popularity'].toString());
    this.voteCount = int.parse(map['vote_count'].toString());
    this.video = map['video'].toString() == "true" ? true : false;
    this.posterPath = APIConfig.imagePath + map['poster_path'].toString();
    this.id = int.parse(map['id'].toString());
    this.adult = map['adult'].toString() == "true" ? true : false;
    this.backdropPath = APIConfig.imagePath +
        (map['backdrop_path'] == null
            ? map['poster_path'].toString()
            : map['backdrop_path'].toString());
    this.originalLanguage = map['original_language'].toString();
    this.originalTitle = map['original_title'].toString();
    this.title = map['title'].toString();
    this.voteAverage = double.parse(map['vote_average'].toString());
    this.overview = map['overview'].toString();
    this.releaseDate = map['release_date'].toString();

    this.genreIds = map['genre_ids'] != null ? [] : null;
    for (int item in genreIds != null ? map['genre_ids'] : []) {
      this.genreIds.add(item);
    }
  }
}
