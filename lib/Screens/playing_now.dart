// ignore_for_file: camel_case_types, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class playingNow extends StatefulWidget {
  const playingNow(
      {Key? key,
      required this.songModel,
      required this.audioPlayer,
      required this.index})
      : super(key: key);
  final List<SongModel> songModel;
  final int index;
  final AudioPlayer audioPlayer;
  @override
  State<playingNow> createState() => _playingNowState();
}

class _playingNowState extends State<playingNow> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  String musicName = '';
  String artistName = '';
  bool _isplaying = false;
  int currentIndex = 0;
  int nextIndex = 0;
  int artworkId = 0;
  @override
  void initState() {
    super.initState();
    playSong(widget.index);
    currentIndex = widget.index;
    musicName = widget.songModel[widget.index].displayNameWOExt.toString();
    artistName = widget.songModel[widget.index].artist.toString();
    artworkId = widget.songModel[widget.index].id;
  }

  void playSong(int index) {
    try {
      widget.audioPlayer.setAudioSource(
          AudioSource.uri(Uri.parse(widget.songModel[index].uri!)));
      widget.audioPlayer.play();
      _isplaying = true;
    } catch (e) {
      print("Error playing song");
    }
    widget.audioPlayer.durationStream.listen((d) {
      setState(() {
        _duration = d!;
      });
    });
    widget.audioPlayer.positionStream.listen((p) {
      setState(() {
        _position = p;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
            ),
            SizedBox(
              height: 25,
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 56, 26, 95),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 3,
                            blurRadius: 10,
                          )
                        ]),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 100,
                      child: Icon(
                        Icons.music_note,
                        size: 80,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    musicName,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white60),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    widget.songModel[widget.index].artist.toString() ==
                            "<unknown>"
                        ? "Unknown Artist"
                        : artistName,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: TextStyle(fontSize: 20, color: Colors.white60),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Text(
                        _position.toString().split(".")[0],
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Slider(
                            thumbColor: Colors.black,
                            value: _position.inSeconds.toDouble(),
                            max: _duration.inSeconds.toDouble(),
                            min: Duration(microseconds: 0).inSeconds.toDouble(),
                            onChanged: (value) {
                              setState(() {
                                changeToSeconds(value.toInt());
                                value = value;
                              });
                            }),
                      ),
                      Text(
                        _duration.toString().split(".")[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black45,
                        radius: 30,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (currentIndex == 0) {
                                currentIndex = widget.songModel.length;
                                playSong(currentIndex);
                                musicName = widget
                                    .songModel[currentIndex].displayNameWOExt
                                    .toString();
                                artistName = widget
                                    .songModel[currentIndex].artist
                                    .toString();
                                artworkId = widget.songModel[currentIndex].id;
                              } else {
                                nextIndex = currentIndex - 1;
                                widget.audioPlayer.pause();
                                playSong(nextIndex);
                                currentIndex = nextIndex;
                                musicName = widget
                                    .songModel[nextIndex].displayNameWOExt
                                    .toString();
                                artistName = widget.songModel[nextIndex].artist
                                    .toString();
                                artworkId = widget.songModel[nextIndex].id;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.skip_previous,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 82, 8, 8),
                        radius: 40,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_isplaying) {
                                widget.audioPlayer.pause();
                              } else {
                                widget.audioPlayer.play();
                              }
                              _isplaying = !_isplaying;
                            });
                          },
                          icon: Icon(
                            _isplaying ? Icons.pause : Icons.play_arrow,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.black45,
                        radius: 30,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (currentIndex == widget.songModel.length - 1) {
                                currentIndex = 0;
                                playSong(currentIndex);
                                musicName = widget
                                    .songModel[currentIndex].displayNameWOExt
                                    .toString();
                                artistName = widget
                                    .songModel[currentIndex].artist
                                    .toString();
                                artworkId = widget.songModel[currentIndex].id;
                              } else {
                                nextIndex = currentIndex + 1;
                                widget.audioPlayer.pause();
                                playSong(nextIndex);
                                currentIndex = nextIndex;
                                musicName = widget
                                    .songModel[nextIndex].displayNameWOExt
                                    .toString();
                                artistName = widget.songModel[nextIndex].artist
                                    .toString();
                                artworkId = widget.songModel[nextIndex].id;
                              }
                            });
                          },
                          icon: Icon(
                            Icons.skip_next,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
