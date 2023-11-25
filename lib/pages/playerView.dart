import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:just_audio/just_audio.dart';
import 'package:navidrome_player/player.dart';

import 'package:navidrome_player/main.dart';
import 'package:navidrome_player/styles.dart';

class PlayerView extends StatefulWidget {
  const PlayerView({Key? key}): super(key: key);
  @override
  _PlayerViewState createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  Widget progressBar = const SizedBox();

// @override
//   void dispose() {
// SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     super.dispose();
//   }
    
//   @override
//   initState() {
// SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//     super.initState();
//   }

   int currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<MyAppState>();
    final player = appState.player;
    final client = appState.client;
    final playlist = player.player.sequence!;

    player.player.currentIndexStream.asBroadcastStream().listen((index) {
            
            setState(() {
                        currentIndex = index ?? 0;
                    });
            // switch(event.processingState) {
            //     case ProcessingState.loading: setState(() {});
            //     default: print('nothing');
            // }
            },
        onError: (Object e, StackTrace st) {
      if (e is PlayerException) {
        print('Error code: ${e.code}');
        print('Error message: ${e.message}');
      } else {
        print('An error occurred: $e');
      }
    });

    if(playlist.isEmpty) {
        return const Center(child: Text('Nothing Playing!', style: Styles.albumStyle));
    }
    final currentTag = playlist[currentIndex].tag as MediaItem;
    progressBar = appState.player.progressBar();

    return Scaffold(
        // appBar: AppBar(title: const Text('Player'), actions: [
        //   IconButton(
        //       icon: const Icon(Icons.queue_music),
        //       onPressed: () {
        //         Navigator.pushNamed(context, '/Queue');
        //       }),
        //   IconButton(
        //       icon: const Icon(Icons.search),
        //       onPressed: () {
        //         Navigator.pushNamed(context, '/SearchScreen');
        //       })
        // ]),
        body: GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.direction >= 0) {
                Navigator.pushReplacementNamed(context, '/Queue');
              }
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Expanded(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: ClipRRect(
                              borderRadius: Styles.borderRadius,
                              child: Hero(
                                  tag: currentTag.id,
                                  child:
                                      client.cachedImage(id: currentTag.id)))),
                          Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(currentTag.title, style: Styles.albumStyle),
                            Text('${currentTag.artist}',
                                style: Styles.subtitleStyle),
                          ],
                        ),
                    ])),
                    Container(child: progressBar),
                    ControlBar(client: client, theme: theme, songId: currentTag.id, player: player, rating: currentTag.rating),
                  ],
                ))));
  }
}
