import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// external package
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:carousel_slider/carousel_slider.dart';

// internal
import 'package:movieapp/src/api/movieAPI_client.dart';
import 'package:movieapp/src/utils/toastMsg.dart';
import 'package:movieapp/src/model/movie.model.dart';
import 'package:movieapp/src/utils/imageRetrieve.dart';

// Widget
import 'package:movieapp/src/view/movieDetails.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MovieAPIClient movieAPIClient = MovieAPIClient(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: FutureBuilder(
          future: Future.wait([
            getNowPlayingMovieList(movieAPIClient, []),
            getUpcomingMovieList(movieAPIClient, [])
          ]),
          builder: (BuildContext context,
              AsyncSnapshot<List<List<Movie>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Container(
                  child: Center(
                    child: Text("Service Unavailable",
                        style: TextStyle(fontSize: 17.0)),
                  ),
                );
              } else if (snapshot.hasData) {
                return MovieList(
                    movieAPIClient: movieAPIClient,
                    nowPlayingMovieList: snapshot.data[0],
                    upcomingMovieList: snapshot.data[1]);
              } else {
                return Container(
                  child: Center(
                    child: Text("No Movie Available",
                        style: TextStyle(fontSize: 17.0)),
                  ),
                );
              }
            } else {
              return Container(
                  child: Center(child: CircularProgressIndicator()));
            }
          }),
    );
  }
}

class MovieList extends StatefulWidget {
  const MovieList(
      {Key key,
      @required this.movieAPIClient,
      @required this.nowPlayingMovieList,
      @required this.upcomingMovieList})
      : super(key: key);

  final MovieAPIClient movieAPIClient;
  final List<Movie> nowPlayingMovieList;
  final List<Movie> upcomingMovieList;

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> with TickerProviderStateMixin {
  int page;
  bool pageEnd = false;
  List<Movie> nowPlayingMovieList = [];

  @override
  void initState() {
    page = 1;
    nowPlayingMovieList = widget.nowPlayingMovieList;
    super.initState();
  }

  bool _lazyLoad(ScrollNotification notification) {
    if (notification is ScrollEndNotification && !pageEnd) {
      if (notification.metrics.extentAfter == 0) {
        int prevDataSize = nowPlayingMovieList.length;
        getNowPlayingMovieList(widget.movieAPIClient, nowPlayingMovieList,
                page: ++page, nextpage: true)
            .then((onValue) {
          // if more movie return
          if (onValue.length != prevDataSize) {
            setState(() {
              nowPlayingMovieList = onValue;
            });
          } else {
            ToastMsg.toToastBottom("Page End");
            pageEnd = true;
          }
        });
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 30),
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Column(children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                        child: Row(children: <Widget>[
                          Container(
                            height: 25,
                            width: 3,
                            decoration: BoxDecoration(
                              color: Theme.of(context).secondaryHeaderColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                            child: Text(
                              'Comming Soon',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1.2,
                                fontSize: 15,
                              ),
                            ),
                          ))
                        ])),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      color: Theme.of(context).backgroundColor,
                      child: CarouselSlider.builder(
                          itemCount: widget.upcomingMovieList.length,
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height / 3.5,
                            viewportFraction: 0.95,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 1500),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          ),
                          itemBuilder: (BuildContext context, int index) {
                            return getMovieBanner(
                                widget.upcomingMovieList[index]);
                          }),
                    )
                  ]);
                }, childCount: 1),
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: TabBar(
                  getMovieBar(),
                ),
              ),
            ];
          },
          body: Container(
              child: NotificationListener<ScrollNotification>(
                  onNotification: _lazyLoad,
                  child: ScrollConfiguration(
                    behavior: ScrollMovieListBehavior(),
                    child: GridView.builder(
                        padding: const EdgeInsets.all(3),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: nowPlayingMovieList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height),
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return getMovieListScreen(nowPlayingMovieList[index]);
                        }),
                  ))),
        ));
  }

  Widget getMovieBanner(Movie movie) {
    String releaseDate = DateFormat("MMM d")
        .format(DateFormat("yyyy-MM-dd").parse(movie.releaseDate));
    return Padding(
        padding: const EdgeInsets.all(0),
        child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MovieDetails(movie.id);
                  }));
                },
                child: Stack(children: <Widget>[
                  Container(
                      width: double.infinity,
                      child: ImageRetrieve.request(movie.posterPath)),
                  Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(movie.title,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.title),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Release $releaseDate",
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                movie.overview,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.subtitle,
                              ),
                            ]),
                      ))
                ]))));
  }

  Widget getMovieBar() {
    return Stack(children: <Widget>[
      Container(
          color: Theme.of(context).backgroundColor,
          child: Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 4),
              child: Row(children: <Widget>[
                Container(
                  height: 25,
                  width: 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                    child: Text(
                      'Now Playing',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ])))
    ]);
  }

  Widget getMovieListScreen(Movie movie) {
    return Container(
        padding: const EdgeInsets.all(3),
        child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MovieDetails(movie.id);
              }));
            },
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: AspectRatio(
                          aspectRatio: 0.7,
                          child: ImageRetrieve.request(movie.posterPath))),
                  Container(
                      padding: const EdgeInsets.only(top: 8, left: 3),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              movie.title,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            Row(
                              children: <Widget>[
                                SmoothStarRating(
                                  allowHalfRating: false,
                                  starCount: 5,
                                  rating: (movie.voteAverage / 10) * 5,
                                  size: 10,
                                  color: Theme.of(context).primaryColor,
                                  borderColor: Theme.of(context).primaryColor,
                                  isReadOnly: true,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  movie.voteAverage.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ])),
                ])));
  }
}

class TabBar extends SliverPersistentHeaderDelegate {
  TabBar(
    this.tabBar,
  );
  final Widget tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return tabBar;
  }

  @override
  double get maxExtent => 55.0;

  @override
  double get minExtent => 55.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class ScrollMovieListBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

Future<List<Movie>> getNowPlayingMovieList(
    MovieAPIClient movieAPIClient, List<Movie> movieList,
    {int page = 1, bool nextpage = false}) async {
  if (movieList.length > 0 && nextpage) {
    movieList.addAll(await movieAPIClient.getNowPlayingMovie(page: page));
  } else if (movieList.length == 0) {
    movieList = await movieAPIClient.getNowPlayingMovie(page: page);
  }
  return movieList;
}

Future<List<Movie>> getUpcomingMovieList(
    MovieAPIClient movieAPIClient, List<Movie> movieList,
    {int page = 1, nextpage = false}) async {
  movieList = movieList.length == 0
      ? await movieAPIClient.getUpcomingMovie(page: page)
      : movieList;
  return movieList;
}
