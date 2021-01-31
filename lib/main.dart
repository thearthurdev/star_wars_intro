import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      home: StarWarsIntro(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    ),
  );
}

class StarWarsIntroAnimation extends StatelessWidget {
  StarWarsIntroAnimation({Key key, this.controller, this.size})
      : introTextOpacityShow = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.01,
              curve: Curves.ease,
            ),
          ),
        ),
        introTextOpacityHide = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.08,
              0.1,
              curve: Curves.ease,
            ),
          ),
        ),
        spaceOpacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.12,
              0.12,
              curve: Curves.ease,
            ),
          ),
        ),
        starWarsLogoOpacityShow = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.12,
              0.12,
              curve: Curves.ease,
            ),
          ),
        ),
        starWarsLogoOpacityHide = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.25,
              0.3,
              curve: Curves.ease,
            ),
          ),
        ),
        starWarsLogoSize = Tween<double>(
          begin: size.width,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.09,
              0.35,
              curve: Curves.decelerate,
            ),
          ),
        ),
        crawlingTextPositionTop = Tween<double>(
          begin: size.height,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0,
              0.8,
              curve: Curves.linear,
            ),
          ),
        ),
        crawlingTextPositionBottom = Tween<double>(
          begin: 0.0,
          end: size.height * 0.7,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.4,
              1.0,
              curve: Curves.linear,
            ),
          ),
        ),
        crawlingTextOpacity = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.9,
              1.0,
              curve: Curves.linear,
            ),
          ),
        ),
        super(key: key);

  final Size size;
  final AnimationController controller;
  final Animation<double> spaceOpacity;
  final Animation<double> introTextOpacityShow;
  final Animation<double> introTextOpacityHide;
  final Animation<double> starWarsLogoOpacityShow;
  final Animation<double> starWarsLogoOpacityHide;
  final Animation<double> starWarsLogoSize;
  final Animation<double> crawlingTextOpacity;
  final Animation<double> crawlingTextPositionTop;
  final Animation<double> crawlingTextPositionBottom;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Space(opacity: spaceOpacity),
          IntroText(
            opacity: controller.value > 0.09
                ? introTextOpacityHide
                : introTextOpacityShow,
          ),
          StarWarsLogo(
            opacity: controller.value > 0.2
                ? starWarsLogoOpacityHide
                : starWarsLogoOpacityShow,
            size: starWarsLogoSize,
          ),
          CrawlingText(
            topMargin: crawlingTextPositionTop,
            bottomMargin: crawlingTextPositionBottom,
            opacity: crawlingTextOpacity,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class Space extends StatefulWidget {
  Space({this.opacity});

  final Animation<double> opacity;

  @override
  _SpaceState createState() => _SpaceState();
}

class _SpaceState extends State<Space> {
  final int _starCount = 300;

  List<Widget> _stars;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _stars = List.generate(_starCount, (index) {
      List<double> xy = getRandomPosition(context);
      return Positioned(
        top: xy[0],
        left: xy[1],
        child: TwinkleLittleStar(),
      );
    });
  }

  List<double> getRandomPosition(BuildContext context) {
    double x = MediaQuery.of(context).size.height;
    double y = MediaQuery.of(context).size.width;

    double randomX =
        double.parse((math.Random().nextDouble() * x).toStringAsFixed(3));
    double randomY =
        double.parse((math.Random().nextDouble() * y).toStringAsFixed(3));

    return [randomX, randomY];
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.opacity.value,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          color: Colors.black,
          child: Stack(
            children: _stars,
          ),
        ),
      ),
    );
  }
}

class TwinkleLittleStar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.0,
      height: 1.0,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }
}

class IntroText extends StatelessWidget {
  IntroText({this.opacity});

  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.value,
      child: Center(
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Text(
              'A long time ago in a galaxy far,\nfar away....',
              style: TextStyle(
                color: Color(0xFF11B2A3),
                fontSize: 72.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StarWarsLogo extends StatelessWidget {
  StarWarsLogo({this.size, this.opacity});

  final Animation<double> size;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: opacity.value,
        child: Image.network(
          'https://logos-download.com/wp-content/uploads/2016/09/Star_Wars_logo-1.png',
          width: size.value,
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}

class CrawlingText extends StatelessWidget {
  CrawlingText({this.topMargin, this.bottomMargin, this.opacity});

  final Animation<double> topMargin;
  final Animation<double> bottomMargin;
  final Animation<double> opacity;

  final TextStyle crawlingTextStyle = TextStyle(
    color: Color(0xFFFFC500),
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity.value,
      child: Center(
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.007)
            ..rotateX(5.6),
          alignment: FractionalOffset.center,
          child: Container(
            margin: EdgeInsets.only(
                top: topMargin.value, bottom: bottomMargin.value),
            child: FittedBox(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                padding: EdgeInsets.symmetric(horizontal: 64.0),
                child: Column(
                  children: [
                    Text(
                      'Episode VII\nTHE FORCE AWAKENS',
                      textAlign: TextAlign.center,
                      style: crawlingTextStyle,
                    ),
                    Text(
                      "\nLuke Skywalker has vanished. In his absence, the sinister FIRST ORDER has risen from the ashes of the Empire and will not rest until Skywalker, the last Jedi, has been destroyed."
                      "\nWith the support of the REPUBLIC, General Leia Organa leads a brave RESISTANCE. She is desperate to find her brother Luke and gain his help in restoring peace and justice to the galaxy."
                      "\nLeia has sent her most daring pilot on a secret mission to Jakku, where an old ally has discovered a clue to Luke's whereabouts.…",
                      textAlign: TextAlign.justify,
                      style: crawlingTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StarWarsIntro extends StatefulWidget {
  @override
  _StarWarsIntroState createState() => _StarWarsIntroState();
}

class _StarWarsIntroState extends State<StarWarsIntro>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..addListener(_controllerListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    MyAudioPlayer.stopMusic();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _controllerListener() {
    if (_controller.value == 1) MyAudioPlayer.stopMusic();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      _controller.reset();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 80.0;
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _playAnimation();
              MyAudioPlayer.playMusic();
            },
            child: StarWarsIntroAnimation(
              controller: _controller,
              size: MediaQuery.of(context).size,
            ),
          ),
        ],
      ),
    );
  }
}

class MyAudioPlayer {
  static AudioPlayer audioPlayer = AudioPlayer();

  static Future<void> playMusic() async {
    int result = await audioPlayer.play(
        "https://s.cdpn.io/1202/Star_Wars_original_opening_crawl_1977.mp3");
    if (result == 1) {
      // success
    }
  }

  static Future<void> stopMusic() async {
    int result = await audioPlayer.stop();
    if (result == 1) {
      // success
    }
  }
}
