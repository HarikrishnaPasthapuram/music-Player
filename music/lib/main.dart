import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:music/progressbar.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: StackBuilder()),
    );
  }
}

class StackBuilder extends StatefulWidget {
  StackBuilder({Key key}) : super(key: key);

  _StackBuilderState createState() => _StackBuilderState();
}

class _StackBuilderState extends State<StackBuilder>
    with TickerProviderStateMixin {
  AnimationController paneController;
  AnimationController playPauseController;
  AnimationController songCompletedController;
  Animation<double> paneAnimation;
  Animation<double> albumImageAnimation;
  Animation<double> albumImageBlurAnimation;
  Animation<Color> songsContainerColorAnimation;
  Animation<Color> songsContainerTextColorAnimation;
  Animation<double> songCompletedAnimation;

  bool isAnimCompleted = false;
  bool isSongPlaying = false;

  double songCompleted = 0.0;
  double circleRadius = 5.0;

  @override
  void initState() {
    super.initState();

    paneController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    songCompletedController =
    AnimationController(vsync: this, duration: Duration(seconds: 360))
      ..addListener(() {
        setState(() {
          songCompleted = songCompletedAnimation.value;
        });
      });
    paneAnimation = Tween<double>(begin: -300, end: 0.0)
        .animate(CurvedAnimation(parent: paneController, curve: Curves.easeIn));
    albumImageAnimation = Tween<double>(begin: 1.0, end: 0.5)
        .animate(CurvedAnimation(parent: paneController, curve: Curves.easeIn));
    albumImageBlurAnimation = Tween<double>(begin: 0.0, end: 10.0)
        .animate(CurvedAnimation(parent: paneController, curve: Curves.easeIn));
    songsContainerColorAnimation =
        ColorTween(begin: Colors.black87, end: Colors.white.withOpacity(0.5))
            .animate(paneController);
    songsContainerTextColorAnimation =
        ColorTween(begin: Colors.white, end: Colors.black87)
            .animate(paneController);

    playPauseController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    songCompletedAnimation =
        Tween<double>(begin: 0.0, end: 400).animate(songCompletedController);
  }

  animationInit() {
    if (isAnimCompleted) {
      paneController.reverse();
    } else {
      paneController.forward();
    }
    isAnimCompleted = !isAnimCompleted;
  }

  playSong() {
    if (isSongPlaying) {
      playPauseController.reverse();
      songCompletedController.reverse();
    } else {
      playPauseController.forward();
      songCompletedController.forward();
    }
    isSongPlaying = !isSongPlaying;
  }

  Widget songContainer(BuildContext context) {
    return Positioned(
      bottom: paneAnimation.value,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          var drag = details.primaryDelta / MediaQuery.of(context).size.height;
          paneController.value = paneController.value - 3 * drag;
          if (paneController.value >= 0.5) {
            paneController.fling(velocity: 1);
          } else {
            paneController.fling(velocity: -1);
          }
        },
        child: Container(
          alignment: Alignment.bottomCenter,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            color: songsContainerColorAnimation.value,
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Now Playing",
                  style: prefix0.TextStyle(
                      color: songsContainerTextColorAnimation.value),
                ),
              ),
              Text(
                "sachin sachin...|Sachin a billion Dreams",
                style: prefix0.TextStyle(
                    color: songsContainerTextColorAnimation.value,
                    fontSize: 16.0),
              ),
              Text(
                "Nakash Aziz",
                style: prefix0.TextStyle(
                    color: songsContainerTextColorAnimation.value,
                    fontSize: 12.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: GestureDetector(
                  onHorizontalDragStart: (details) {
                    setState(() {
                      circleRadius = 7.0;
                    });
                  },
                  onHorizontalDragUpdate: (details) {
                    var drag = details.primaryDelta /
                        MediaQuery.of(context).size.height;
                    songCompletedController.value = songCompletedController.value + 2 * drag;
                  },
                  onHorizontalDragEnd: (details) {
                    setState(() {
                      circleRadius = 5.0;
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30.0,
                    child: CustomPaint(
                      painter: ProgressBar(
                          progressBarColor:
                          songsContainerTextColorAnimation.value,
                          songCompleted: songCompleted,
                          circleRadius: circleRadius),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.skip_previous,
                        size: 40.0,
                        color: songsContainerTextColorAnimation.value),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          playSong();
                        },
                        child: AnimatedIcon(
                          icon: AnimatedIcons.play_pause,
                          progress: playPauseController,
                          color: songsContainerTextColorAnimation.value,
                          size: 40.0,
                        ),
                      ),
                    ),
                    RotatedBox(
                        quarterTurns: 2,
                        child: Icon(Icons.skip_previous,
                            size: 40.0,
                            color: songsContainerTextColorAnimation.value)),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, index) {
                    return Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 60.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: ExactAssetImage('image/sachin.jpg'),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("play Another songs",
                                style: prefix0.TextStyle(
                                  color: songsContainerTextColorAnimation.value,
                                )),
                            Text(" Singer Name  | 4:50",
                                style: prefix0.TextStyle(
                                  color: songsContainerTextColorAnimation.value,
                                ))
                          ],
                        )
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget stackBody(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        FractionallySizedBox(
          alignment: Alignment.topCenter,
          heightFactor: albumImageAnimation.value,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('image/sachin.jpg'),
                    fit: BoxFit.cover)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: albumImageBlurAnimation.value,
                  sigmaY: albumImageBlurAnimation.value),
              child: Container(
                color: Colors.white.withOpacity(0.0),
              ),
            ),
          ),
        ),
        songContainer(context)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: paneController,
      builder: (BuildContext context, widget) {
        return stackBody(context);
      },
    );
  }
}