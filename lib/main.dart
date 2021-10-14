import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';

class IntroText extends StatelessWidget {
  IntroText({this.opacity});

  // This variable will be responsible for animating the opacity of this widget
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      // We adjust the opacity based on the value of the animation variable
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

class Space extends StatefulWidget {
  Space({@required this.opacity});

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

    // We generate our stars in this method so that it builds only once
    // but after the initState method has finished running.
    _stars = _generateStars();
  }

  List<Widget> _generateStars() {
    return List.generate(_starCount, (index) {
      List<double> xy = _getRandomPosition(context);
      return Positioned(
        top: xy[0],
        left: xy[1],
        child: TwinkleLittleStar(),
      );
    });
  }

  List<double> _getRandomPosition(BuildContext context) {
    // We get the dimensions of the screen and use them to generate random coordinates
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

class StarWarsLogo extends StatelessWidget {
  StarWarsLogo({this.size, this.opacity});

  // This time there is an extra animation variable which will animate the size of the logo,
  // progressively making it smaller and smaller to simulate it moving away.
  final Animation<double> size;
  final Animation<double> opacity;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: opacity.value,
        // We get the image straight from the net. This is a sci-fi after all...
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

  // The `topMargin` and `bottomMargin` values are what are used to acheive the crawling effect
  final Animation<double> topMargin;
  final Animation<double> bottomMargin;
  final Animation<double> opacity;

  final TextStyle _crawlingTextStyle = TextStyle(
    color: Color(0xFFFFC500),
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    final double maxWidthConstraint = MediaQuery.of(context).size.width * 0.6;

    return Opacity(
      opacity: opacity.value,
      child: Center(
        child: Transform(
          // This transformation adjusts it's child to achieve the perspective angle we want
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.007)
            ..rotateX(5.6),
          alignment: FractionalOffset.center,
          child: Container(
            // Adjust the margins above and below the text to make it simulate upward movement
            margin: EdgeInsets.only(
                top: topMargin.value, bottom: bottomMargin.value),
            child: FittedBox(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: maxWidthConstraint < 500
                      ? MediaQuery.of(context).size.width
                      : maxWidthConstraint,
                ),
                padding: EdgeInsets.symmetric(horizontal: 64.0),
                child: Column(
                  children: [
                    Text(
                      'Episode VII\nTHE FORCE AWAKENS',
                      textAlign: TextAlign.center,
                      style: _crawlingTextStyle,
                    ),
                    Text(
                      "\nLuke Skywalker has vanished. In his absence, the sinister FIRST ORDER has risen from the ashes of the Empire and will not rest until Skywalker, the last Jedi, has been destroyed."
                      "\n\nWith the support of the REPUBLIC, General Leia Organa leads a brave RESISTANCE. She is desperate to find her brother Luke and gain his help in restoring peace and justice to the galaxy."
                      "\n\nLeia has sent her most daring pilot on a secret mission to Jakku, where an old ally has discovered a clue to Luke's whereabouts.…",
                      textAlign: TextAlign.justify,
                      style: _crawlingTextStyle,
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // We listen to the controller and stop the music when the animation ends
  void _controllerListener() {
    if (_controller.value == 1) MyAudioPlayer.stopMusic();
  }

  // The animation will play to the end and then reset
  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
      _controller.reset();
    } on TickerCanceled {
      // the animation got canceled, probably because it was disposed of
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 80.0; // Time Dilation reduces the speed of the animation
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              // We simultaneously play the animation and the music when a tap is recognized
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

class StarWarsIntroAnimation extends StatelessWidget {
  StarWarsIntroAnimation({Key key, this.controller, this.size})
      // Each property that is going to be animated has a `Tween` created for it
      // The main AnimationController is passed to each of them and their
      // interval of animation is specified
      : introTextOpacityShow = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            // The interval are two values from 0.0 to 1.0 which will take up a
            // fraction of the AnimationCOntroller's total interval and
            // specify at which values of the AnimationController this `Tween` will animate
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
            // We use two different Tweens to animate the same property
            // at different intervals in the animation as required
            // Here the opacity property will listen to the value of the introTextOpacityHide`
            // if the controller's value is more than 0.09 and listen to the value of `introTextOpacityShow` otherwise
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

void main() {
  runApp(
    MaterialApp(
      title: 'Star Wars Intro',
      home: SetupPage(),
      // home: TempView(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
    ),
  );
}

class TempView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            // CrawlingText(
            //   opacity: AlwaysStoppedAnimation<double>(1),
            //   topMargin: AlwaysStoppedAnimation<double>(400),
            //   bottomMargin: AlwaysStoppedAnimation<double>(000),
            // ),
            Space(
              opacity: AlwaysStoppedAnimation(1),
            ),
          ],
        ),
      ),
    );
  }
}

class SetupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Space(opacity: AlwaysStoppedAnimation(1.0)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(32.0),
                constraints: BoxConstraints(maxWidth: 600.0),
                child: Text(
                  'Welcome to Star Wars Intro with Flutter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFC500),
                    fontSize: 48.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(maxHeight: 500.0, maxWidth: 300.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  border: Border.all(
                    width: 1.5,
                    color: Color(0xFFFFC500),
                  ),
                ),
                child: TextField(
                  cursorWidth: 3.0,
                  style: TextStyle(
                    color: Color(0xFFFFC500),
                    fontSize: 32.0,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Color(0xFFFFC500),
                ),
                child: Center(
                  child: Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 32.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
