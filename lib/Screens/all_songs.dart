// ignore_for_file: prefer_const_constructors, unused_field, camel_case_types
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musikrow/Screens/about_me.dart';
import 'package:musikrow/Screens/playing_now.dart';
import 'package:on_audio_query/on_audio_query.dart';

class showAllSongs extends StatefulWidget {
  const showAllSongs({Key? key}) : super(key: key);

  @override
  State<showAllSongs> createState() => _showAllSongsState();
}

class _showAllSongsState extends State<showAllSongs> {
  List<SongModel> songs = [];
  String currentSongTitle = '';
  int currentIndex = 0;
  final _audioQuery = OnAudioQuery();
  final _audioPlayer = AudioPlayer();
  playSong(String? uri) {
    try {
      _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } catch (e) {
      print("Error parsing song");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Music Row"),
        // ignore: prefer_const_literals_to_create_immutables
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => aboutMe()))),
              child: Text(
                "About US",
                style: TextStyle(color: Colors.red),
              ),
            )),
          )
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          if (item.data!.isEmpty) {
            return Center(
              child: Text(
                "no Songs found",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );
          }
          songs.clear();
          songs = item.data!;
          return ListView.builder(
            itemBuilder: ((context, index) => Container(
                  margin: EdgeInsets.fromLTRB(7, 10, 7, 0),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5)),
                  child: ListTile(
                      leading: Icon(
                        Icons.music_note,
                        color: Colors.white,
                      ),
                      title: Text(
                        item.data![index].displayNameWOExt,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        item.data![index].artist.toString(),
                        style: TextStyle(
                            color: Color.fromARGB(255, 161, 107, 247)),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                          color: Color.fromARGB(255, 161, 96, 245),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    backgroundColor: Colors.black38,
                                    title: Text("Delete this Song?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          try {
                                            File songToDelete = File(item
                                                .data![index].uri
                                                .toString());
                                            songToDelete.delete();
                                          } catch (e) {
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                      content:
                                                          Text(e.toString()),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context),
                                                            child: Text("Ok"))
                                                      ],
                                                    ));
                                          }
                                        },
                                        child: Text("Yes"),
                                      ),
                                    ],
                                    content: Text(
                                      "Do you want to delete this song?",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ));
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => playingNow(
                                      index: index,
                                      audioPlayer: _audioPlayer,
                                      songModel: songs,
                                    )));
                        //playSong(songs[index].uri);
                        /*setState(() {
                          currentSongTitle = songs[index].displayNameWOExt;
                          _isplaying = true;
                          _audioPlayer.durationStream.listen((d) {
                            setState(() {
                              _duration = d!;
                            });
                          });
                        });*/
                      }),
                )),
            itemCount: songs.length,
          );
        },
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    _audioPlayer.seek(duration);
  }
}
