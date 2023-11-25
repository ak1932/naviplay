import 'package:flutter/material.dart';
import 'package:navidrome_player/player.dart';
import 'package:provider/provider.dart';

import 'package:navidrome_player/widgets.dart';
import 'package:navidrome_player/main.dart';
import 'package:navidrome_player/model.dart';
import 'package:navidrome_player/styles.dart';

class AlbumView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<MyAppState>();
    final player = appState.player;
    final client = appState.client;
    final albumId = ModalRoute.of(context)!.settings.arguments as String;

    print('albumID = $albumId');

    return Scaffold(
        body: Stack(
      children: [
        CustomScrollView(slivers: [
          SliverAppBar(title: const Text('Album'), actions: [
            IconButton(
                icon: const Icon(Icons.queue_music),
                onPressed: () {
                  Navigator.pushNamed(context, '/Queue');
                }),
            IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.pushNamed(context, '/SearchScreen');
                })
          ]),
          SliverList.list(children: [
            FutureBuilder<Album?>(
                future: client.getAlbum(id: albumId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    Album album = snapshot.data!;
                    List<Song> songList = album.song!;
                    String albumId = album.id!;
                    String albumCoverArt = album.coverArt!;
                    String artistId = album.id ?? '';
                    String albumArtist = album.artist ?? '';

                    print(AlbumList);
                    final albumDurationSeconds = album.duration ?? 0;
                    final albumDuration = (albumDurationSeconds > 3600)
                        ? "${(albumDurationSeconds ~/ 3600).toString().padLeft(2, '0')}h ${((albumDurationSeconds ~/ 60) % 60).toString().padLeft(2, '0')}m"
                        : "${((albumDurationSeconds ~/ 60) % 60).toString().padLeft(2, '0')}m";

                    return SingleChildScrollView(
                        child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 50, horizontal: 20),
                            child: ClipRRect(
                                borderRadius: Styles.borderRadius,
                                child: Hero(
                                  tag: albumId,
                                  child: client.cachedImage(
                                      id: albumCoverArt, fit: BoxFit.fill),
                                ))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(album.name!, style: Styles.albumStyle),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/ArtistView',
                                          arguments: artistId);
                                    },
                                    child: Text(
                                        '$albumArtist • ${album.songCount} tracks • $albumDuration')),
                              ],
                            )),
                            IconButton(
                                icon: const Icon(Icons.play_circle),
                                iconSize: 40,
                                onPressed: () {
                                  player.playNow(album: album);
                                  player.play();
                                })
                          ]),
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: songList.length,
                            itemBuilder: (BuildContext context, int index) {
                              var song = songList[index];
                              var artist = song.artist ?? '';
                              var songDuration = song.duration ?? 0;
                              var trackNumber = song.track ?? 0;
                              var title = song.title ?? '';
                              var duration =
                                  '${(songDuration ~/ 60).toString().padLeft(2, '0')}:${(songDuration % 60).toString().padLeft(2, '0')}';
                              return ListTile(
                                  leading: Text(trackNumber.toString(),
                                      style: Styles.albumStyle),
                                  title: Text(title,
                                      overflow: TextOverflow.ellipsis),
                                  subtitle: Text("$duration • $artist",
                                      style: Styles.subtitleStyle),
                                  trailing:
                                      SongActions(player: player, song: song, client: client),
                                  onTap: () {
                                    player.playNow(song: song);
                                    player.play();
                                  },
                                  onLongPress: () {
                                    player.addToQueue(song: song);
                                    player.play();
                                  });
                            }),
                        const SizedBox(height: 75),
                      ],
                    ));
                  }
                  return const CircularProgressIndicator();
                })
          ])
        ]),
        PlayingPreview(
            client: client, player: player, context: context, theme: theme)
      ],
    ));
  }
}

