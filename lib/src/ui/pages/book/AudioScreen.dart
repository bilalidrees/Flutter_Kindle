import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:hiltonSample/src/model/Book.dart';
import 'package:hiltonSample/src/model/Part.dart';
import 'package:hiltonSample/src/resource/networkConstant.dart';

import 'package:hiltonSample/src/bloc/utility/AppConfig.dart';
import 'package:hiltonSample/src/bloc/ThemeBloc.dart';
import 'package:hiltonSample/src/bloc/AudioBloc.dart';
import 'package:hiltonSample/src/ui/ui_constants/theme/AppColors.dart';

class AudioScreen extends StatefulWidget {
  Book book;
  Part episode;

  AudioScreen({this.book, this.episode});

  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> with WidgetsBindingObserver {
  ThemeBloc themeBloc;
  bool darkThemeSelected;
  AudioPlayer audioPlayer = AudioPlayer();
  AudioBloc audioBloc;
  Duration totalDuration;
  Duration position;
  String audioState = "NotStarted";
  bool isAudioComplete = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    themeBloc = ThemeBloc.getInstance();
    audioBloc = AudioBloc();
    audioBloc.initAudio();
    darkThemeSelected = themeBloc.isDarkThemeSelected;
    themeBloc.darkThemeIsEnabled.listen((value) {
      setState(() {
        darkThemeSelected = value;
      });
    });
    audioBloc.audioStateStream.listen((status) {
      setState(() {
        audioState = status;
      });
    });
    audioBloc.updatedPositionStream.listen((event) {
      position = event;
      if (position.toString().split(".").first ==
          totalDuration.toString().split(".").first) {
        setState(() {
          position = event;
          audioState = "NotStarted";
        });
      } else {
        setState(() {
          position = event;
        });
      }
    });

    audioBloc.totalDurationStream.listen((event) {
      setState(() {
        totalDuration = event;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    audioBloc.stopAudio();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      audioBloc.stopAudio();
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: darkThemeSelected ? Color(0xFF353434) : Colors.grey[200],
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    height: AppConfig.of(context).appWidth(60),
                    width: AppConfig.of(context).appWidth(60),
                    padding: EdgeInsets.all(AppConfig.of(context).appWidth(1)),
                    margin: EdgeInsets.symmetric(
                        horizontal: AppConfig.of(context).appWidth(3),
                        vertical: AppConfig.of(context).appWidth(6)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          "${NetworkConstants.BASE_URL}${widget.book.image.url}",
                          fit: BoxFit.fill,
                        )),
                    decoration: BoxDecoration(
                      color: AppColors.timberWolf,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.mainScreenColorGradient1,
                            offset: Offset(1, 1),
                            spreadRadius: 1,
                            blurRadius: 30),
                        BoxShadow(
                            color: AppColors.mainScreenColorGradient2,
                            offset: Offset(1, 1),
                            spreadRadius: -7,
                            blurRadius: 30)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(6),
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Center(
                        child: Text(
                          widget.episode.title,
                          style: Theme.of(context).textTheme.headline2,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(2),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: AppConfig.of(context).appWidth(3),
                        right: AppConfig.of(context).appWidth(3)),
                    // height: AppConfig.of(context).appWidth(16),
                    child: Text(
                      widget.episode.description,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline3,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  SizedBox(
                    height: AppConfig.of(context).appWidth(13),
                  ),
                  Expanded(
                    child: Container(
                      // height: AppConfig.of(context).appWidth(50),
                      padding: EdgeInsets.only(
                          top: AppConfig.of(context).appWidth(5)),
                      decoration: BoxDecoration(
                        color: darkThemeSelected
                            ? Colors.black26
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left: AppConfig.of(context).appWidth(3)),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Center(
                                    child: Text(
                                      position == null
                                          ? "0:00:00"
                                          : position
                                              .toString()
                                              .split(".")
                                              .first,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: SliderTheme(
                                    data: SliderThemeData(
                                        trackHeight: 5,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 5)),
                                    child: Slider(
                                      value: position == null
                                          ? 0
                                          : position.inMilliseconds.toDouble(),
                                      activeColor:
                                          AppColors.mainScreenColorGradient1,
                                      inactiveColor: AppColors
                                          .mainScreenColorGradient2
                                          .withOpacity(0.3),
                                      onChanged: (value) {
                                        audioBloc.seekAudio(Duration(
                                            milliseconds: value.toInt()));
                                      },
                                      onChangeEnd: (value) {
                                        print(
                                            "${Duration(milliseconds: value.toInt())}");
                                      },
                                      onChangeStart: (value) {
                                        print(
                                            "${Duration(milliseconds: value.toInt())}");
                                      },
                                      min: 0,
                                      max: totalDuration == null
                                          ? 20
                                          : totalDuration.inMilliseconds
                                              .toDouble(),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    right: AppConfig.of(context).appWidth(3)),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Center(
                                    child: Text(
                                      totalDuration == null
                                          ? "0:00:00"
                                          : totalDuration
                                              .toString()
                                              .split(".")
                                              .first,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainScreenColorGradient1,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors
                                              .mainScreenColorGradient2
                                              .withOpacity(0.5),
                                          offset: Offset(5, 10),
                                          spreadRadius: 3,
                                          blurRadius: 5),
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-3, -4),
                                          spreadRadius: -1,
                                          blurRadius: 5)
                                    ],
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: AppColors
                                                        .mainScreenColorGradient2
                                                        .withOpacity(0.5),
                                                    offset: Offset(5, 10),
                                                    spreadRadius: 3,
                                                    blurRadius: 5),
                                                BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(-3, -4),
                                                    spreadRadius: -1,
                                                    blurRadius: 5)
                                              ]),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: AppColors
                                                  .mainScreenColorGradient2,
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Icon(
                                            Icons.skip_previous,
                                            size: 30,
                                            color: AppColors.white,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    audioState == "NotStarted" ||
                                            audioState == "Paused"
                                        ? audioBloc.playAudio(
                                            "${NetworkConstants.BASE_URL}${widget.episode.audio.url}")
                                        : audioBloc.pauseAudio();
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: AppColors.mainScreenColorGradient1,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: AppColors
                                                .mainScreenColorGradient2
                                                .withOpacity(0.5),
                                            offset: Offset(5, 10),
                                            spreadRadius: 3,
                                            blurRadius: 5),
                                        BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(-3, -4),
                                            spreadRadius: -1,
                                            blurRadius: 5)
                                      ],
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Center(
                                          child: Container(
                                            margin: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: AppColors
                                                    .mainScreenColorGradient2,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: AppColors
                                                          .mainScreenColorGradient1
                                                          .withOpacity(0.4),
                                                      offset: Offset(5, 10),
                                                      spreadRadius: 3,
                                                      blurRadius: 10),
                                                  BoxShadow(
                                                      color: Colors.white,
                                                      offset: Offset(-3, -4),
                                                      spreadRadius: -2,
                                                      blurRadius: 20)
                                                ]),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            margin: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                                color: AppColors
                                                    .mainScreenColorGradient2,
                                                shape: BoxShape.circle),
                                            child: Center(
                                                child: Icon(
                                              audioState == "NotStarted" ||
                                                      audioState == "Paused"
                                                  ? Icons.play_arrow
                                                  : Icons.pause,
                                              size: 50,
                                              color: AppColors.white,
                                            )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.mainScreenColorGradient1,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors
                                              .mainScreenColorGradient2
                                              .withOpacity(0.5),
                                          offset: Offset(5, 10),
                                          spreadRadius: 3,
                                          blurRadius: 10),
                                      BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-3, -4),
                                          spreadRadius: -2,
                                          blurRadius: 20)
                                    ],
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    color: AppColors
                                                        .mainScreenColorGradient2
                                                        .withOpacity(0.5),
                                                    offset: Offset(5, 10),
                                                    spreadRadius: 3,
                                                    blurRadius: 10),
                                                BoxShadow(
                                                    color: Colors.white,
                                                    offset: Offset(-3, -4),
                                                    spreadRadius: -2,
                                                    blurRadius: 20)
                                              ]),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: AppColors
                                                  .mainScreenColorGradient2,
                                              shape: BoxShape.circle),
                                          child: Center(
                                              child: Icon(
                                            Icons.skip_next,
                                            size: 30,
                                            color: AppColors.white,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
