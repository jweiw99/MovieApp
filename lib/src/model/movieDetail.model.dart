import 'package:movieapp/src/api/apiConfig.dart';
import 'package:movieapp/src/model/cast.model.dart';
import 'package:movieapp/src/model/crew.model.dart';

class MovieDetail {
  bool adult;
  String backdropPath;
  BelongsToCollection belongsToCollection;
  int budget;
  List<Genre> genres;
  String homepage;
  int id;
  String imdbId;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String posterPath;
  List<ProductionCompanie> productionCompanies;
  List<ProductionCountrie> productionCountries;
  String releaseDate;
  int revenue;
  int runtime;
  List<SpokenLanguage> spokenLanguages;
  String status;
  String tagLine;
  String title;
  bool video;
  double voteAverage;
  int voteCount;
  List<Cast> casts;
  List<Crew> crews;

  MovieDetail(
      {this.adult,
      this.backdropPath,
      this.belongsToCollection,
      this.budget,
      this.genres,
      this.homepage,
      this.id,
      this.imdbId,
      this.originalLanguage,
      this.originalTitle,
      this.overview,
      this.popularity,
      this.posterPath,
      this.productionCompanies,
      this.productionCountries,
      this.releaseDate,
      this.revenue,
      this.runtime,
      this.spokenLanguages,
      this.status,
      this.tagLine,
      this.title,
      this.video,
      this.voteAverage,
      this.voteCount,
      this.casts,
      this.crews});

  MovieDetail.fromMapObject(Map<dynamic, dynamic> map) {
    adult = map['adult'].toString() == "true" ? true : false;
    backdropPath = APIConfig.imagePath + map['backdrop_path'].toString();

    belongsToCollection = map['belongs_to_collection'] == null
        ? null
        : BelongsToCollection.fromMapObject(map['belongs_to_collection']);

    budget = int.parse(map['budget'].toString());

    this.genres = map['genres'] != null ? [] : null;
    for (var item in genres != null ? map['genres'] : []) {
      this.genres.add(item != null ? Genre.fromMapObject(item) : null);
    }

    homepage = map['homepage'].toString();
    id = int.parse(map['id'].toString());
    imdbId = map['imdb_id'].toString();
    originalLanguage = map['original_language'].toString();
    originalTitle = map['original_title'].toString();
    overview = map['overview'].toString();
    popularity = double.parse(map['popularity'].toString());
    posterPath = APIConfig.imagePath + map['poster_path'].toString();

    productionCompanies = map['production_companies'] != null ? [] : null;
    for (var item
        in productionCompanies != null ? map['production_companies'] : []) {
      productionCompanies
          .add(item != null ? ProductionCompanie.fromMapObject(item) : null);
    }

    productionCountries = map['production_countries'] != null ? [] : null;
    for (var item
        in productionCountries != null ? map['production_countries'] : []) {
      productionCountries
          .add(item != null ? ProductionCountrie.fromMapObject(item) : null);
    }

    releaseDate = map['release_date'].toString();
    revenue = int.parse(map['revenue'].toString());
    runtime = int.parse(map['runtime'].toString());

    spokenLanguages = map['spoken_languages'] != null ? [] : null;
    for (var item in spokenLanguages != null ? map['spoken_languages'] : []) {
      spokenLanguages
          .add(item != null ? SpokenLanguage.fromMapObject(item) : null);
    }

    status = map['status'].toString();
    tagLine = map['tagline'].toString();
    title = map['title'].toString();
    video = map['video'].toString() == "true" ? true : false;
    voteAverage = double.parse(map['vote_average'].toString());
    voteCount = int.parse(map['vote_count'].toString());
    casts = [];
    crews = [];
  }
}

class BelongsToCollection {
  int id;
  String backdropPath;
  String name;
  String posterPath;

  BelongsToCollection({this.id, this.backdropPath, this.name, this.posterPath});

  BelongsToCollection.fromMapObject(Map<dynamic, dynamic> map) {
    id = int.parse(map['id'].toString());
    backdropPath = APIConfig.imagePath + map['backdrop_path'].toString();
    name = map['name'].toString();
    posterPath = APIConfig.imagePath + map['poster_path'].toString();
  }
}

class Genre {
  int id;
  String name;

  Genre({this.id, this.name});

  Genre.fromMapObject(Map<dynamic, dynamic> map) {
    id = int.parse(map['id'].toString());
    name = map['name'].toString();
  }
}

class ProductionCompanie {
  int id;
  String logoPath;
  String name;
  String originCountry;

  ProductionCompanie({this.id, this.logoPath, this.name, this.originCountry});

  ProductionCompanie.fromMapObject(Map<dynamic, dynamic> map) {
    id = int.parse(map['id'].toString());
    logoPath = APIConfig.imagePath + map['logo_path'].toString();
    name = map['name'].toString();
    originCountry = map['origin_country'].toString();
  }
}

class ProductionCountrie {
  String iso_3166_1;
  String name;

  ProductionCountrie({this.iso_3166_1, this.name});

  ProductionCountrie.fromMapObject(Map<dynamic, dynamic> map) {
    iso_3166_1 = map['iso_3166_1'].toString();
    name = map['name'].toString();
  }
}

class SpokenLanguage {
  String iso_639_1;
  String name;

  SpokenLanguage({this.iso_639_1, this.name});

  SpokenLanguage.fromMapObject(Map<dynamic, dynamic> map) {
    iso_639_1 = map['iso_639_1'].toString();
    name = map['name'].toString();
  }
}
