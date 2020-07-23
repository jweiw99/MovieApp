import 'package:flutter/material.dart';

// external package
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

// internal
import 'package:movieapp/src/api/movieAPI_client.dart';
import 'package:movieapp/src/model/crew.model.dart';
import 'package:movieapp/src/model/movieDetail.model.dart';
import 'package:movieapp/src/utils/imageRetrieve.dart';

class MovieDetails extends StatelessWidget {
  const MovieDetails(this.movieID, {Key key}) : super(key: key);

  final int movieID;

  Future<MovieDetail> getMovieDetails(BuildContext context) async {
    MovieDetail movie = await MovieAPIClient(context).getMovieDetails(movieID,
        'keywords,recommendations,credits,external_ids,release_dates,images,videos');
    movie = await getCastList(context, movie);
    return movie;
  }

  Future<MovieDetail> getCastList(
      BuildContext context, MovieDetail movie) async {
    MovieDetail data = await MovieAPIClient(context).getCastList(movieID);
    movie.casts = data.casts;
    movie.crews = data.crews;
    return movie;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getMovieDetails(context),
        builder: (BuildContext context, AsyncSnapshot<MovieDetail> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              //print(snapshot.error);
              return getErrorWidget(context, 'Service Unavailable');
            } else if (snapshot.hasData) {
              MovieDetail movieDetail = snapshot.data;
              return Container(
                  color: Theme.of(context).backgroundColor,
                  child: Stack(children: <Widget>[
                    getPosterBanner(context, movieDetail),
                    Scaffold(
                        backgroundColor: Colors.transparent,
                        extendBodyBehindAppBar: true,
                        appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          brightness: Brightness.dark,
                        ),
                        body: SingleChildScrollView(
                            child: Stack(
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.only(top: 230),
                                child: getMovieBody(context, movieDetail)),
                            Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, top: 170),
                                child: getMovieButton(context, movieDetail)),
                            Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 163),
                                child: getMovieTitle(context, movieDetail)),
                          ],
                        )))
                  ]));
            } else {
              return getErrorWidget(context, 'Not Available');
            }
          } else {
            return Container(child: Center(child: CircularProgressIndicator()));
          }
        });
  }

  Widget getErrorWidget(BuildContext context, String msg) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Colors.transparent,
          elevation: 0,
          brightness: Brightness.light,
        ),
        body: Container(
          child: Center(
            child: Text(msg,
                style: TextStyle(
                  fontSize: 17.0,
                )),
          ),
        ));
  }

  Widget getPosterBanner(BuildContext context, MovieDetail movieDetail) {
    return Container(
        height: 250,
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(children: <Widget>[
            Container(
                width: double.infinity,
                child: ImageRetrieve.request(movieDetail.backdropPath)),
            Container(
                width: double.infinity,
                color: Colors.black.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // poster area
                      ]),
                ))
          ]);
        }));
  }

  Widget getMovieButton(BuildContext context, MovieDetail movieDetail) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            movieDetail.homepage.isNotEmpty
                ? IconButton(
                    icon: Image.asset('assets/images/button/homepage.png'),
                    iconSize: 45,
                    onPressed: () => launchURL(movieDetail.homepage),
                  )
                : SizedBox(),
            movieDetail.imdbId.isNotEmpty
                ? IconButton(
                    icon: Image.asset('assets/images/button/imdb.png'),
                    iconSize: 45,
                    onPressed: () => launchURL(
                        'https://www.imdb.com/title/' + movieDetail.imdbId),
                  )
                : SizedBox()
          ],
        ));
  }

  Widget getMovieTitle(BuildContext context, MovieDetail movieDetail) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(
              width: 120,
              height: 180,
              child: ImageRetrieve.requestWithError(movieDetail.posterPath)),
          Container(
              width: MediaQuery.of(context).size.width / 1.6,
              padding: const EdgeInsets.all(8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (movieDetail.adult ? "(R18) " : "") + movieDetail.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '(Dir) ' + getDirectorName(movieDetail),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        fontSize: 13,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        SmoothStarRating(
                          allowHalfRating: false,
                          starCount: 5,
                          rating: (movieDetail.voteAverage / 10) * 5,
                          size: 15,
                          color: Theme.of(context).iconTheme.color,
                          borderColor: Theme.of(context).iconTheme.color,
                          isReadOnly: true,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          movieDetail.voteAverage.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: Theme.of(context).iconTheme.color),
                        ),
                      ],
                    ),
                    Text(
                      getGenreList(movieDetail),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      movieDetail.releaseDate,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        fontSize: 12,
                      ),
                    ),
                  ]))
        ]);
  }

  Widget getMovieBody(BuildContext context, MovieDetail movieDetail) {
    return ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        child: Container(
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor,
            child: Padding(
                padding: const EdgeInsets.only(top: 110),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(children: <Widget>[
                            Icon(
                              Icons.arrow_downward,
                              color: Theme.of(context).primaryColor,
                              size: 15,
                            ),
                            Expanded(
                                child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                    child: Text(
                                      "Details",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                        fontSize: 14,
                                      ),
                                    )))
                          ])),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            movieDetail.overview,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              fontSize: 12,
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(children: <Widget>[
                                Text(
                                  "Running Time : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  movieDetail.runtime.toString() + " minutes",
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                    fontSize: 12,
                                  ),
                                ),
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              Row(children: <Widget>[
                                Text(
                                  "Production country : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  getProductionCountry(movieDetail),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                    fontSize: 12,
                                  ),
                                )
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              Row(children: <Widget>[
                                Text(
                                  "Language : ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  getSpokenLang(movieDetail),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                    fontSize: 12,
                                  ),
                                )
                              ]),
                            ],
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      getCastBody(context, movieDetail),
                      SizedBox(height: 50),
                    ]))));
  }

  Widget getCastBody(BuildContext context, MovieDetail movieDetail) {
    return Visibility(
        visible: movieDetail.casts.length > 0,
        child: SizedBox(
            height: 170,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(children: <Widget>[
                        Icon(
                          Icons.arrow_downward,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                        Expanded(
                            child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5, 10, 5, 10),
                                child: Text(
                                  "Casts",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    fontSize: 14,
                                  ),
                                )))
                      ])),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: movieDetail.casts.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                width: 80.0,
                                height: 80.0,
                                padding: const EdgeInsets.only(right: 10),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                          child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(15.0)),
                                              child: ImageRetrieve.request(
                                                  movieDetail.casts[index]
                                                      .profilePath))),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Text(
                                            movieDetail.casts[index].name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 1,
                                              fontSize: 10,
                                            ),
                                          )),
                                    ]));
                          })),
                ])));
  }

  String getDirectorName(MovieDetail movieDetail) {
    List<Crew> crew =
        movieDetail.crews.where((val) => val.job == "Director").toList();
    return crew.length > 0 ? crew[0].name : "-";
  }

  String getGenreList(MovieDetail movieDetail) {
    List<String> genres = movieDetail.genres.map((val) => val.name).toList();
    String data = genres.join(" & ");
    return data.isNotEmpty ? data : "-";
  }

  String getSpokenLang(MovieDetail movieDetail) {
    List<String> lang =
        movieDetail.spokenLanguages.map((val) => val.name).toList();
    String data = lang.join(", ");
    return data.isNotEmpty ? data : "-";
  }

  String getProductionCountry(MovieDetail movieDetail) {
    List<String> lang =
        movieDetail.productionCountries.map((val) => val.name).toList();
    String data = lang.join(", ");
    return data.isNotEmpty ? data : "-";
  }

  launchURL(url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } on Error catch (e) {}
  }
}
