import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:navidrome_player/player.dart';
import '../main.dart';
import '../model.dart';
import '../styles.dart';

class ArtistView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<MyAppState>();
    final player = appState.player;
    final client = appState.client;
    final artistID = ModalRoute.of(context)!.settings.arguments as String;

    return Stack(children: [Scaffold(appBar: AppBar(title: Text('Artist'), actions:[IconButton(icon: const Icon(Icons.queue_music), onPressed: () {Navigator.pushNamed(context, '/Queue');}), IconButton(icon: const Icon(Icons.search), onPressed: () {Navigator.pushNamed(context, '/SearchScreen');})]), body: FutureBuilder<Artist?>(
        future: client.getArtist(id: artistID),
        builder: (context, snapshot) {
            if(snapshot.hasData) {
                Artist artist = snapshot.data!;
                // List<Song> songList = album.song!;
                List<Album> albumList = artist.album!;
                // final albumDurationSeconds = album.duration!;
                // final albumDuration = (albumDurationSeconds > 3600)? "${(albumDurationSeconds~/3600).toString().padLeft(2, '0')}h ${((albumDurationSeconds~/60)%60).toString().padLeft(2,'0')}m" : "${((albumDurationSeconds~/60)%60).toString().padLeft(2,'0')}m";


                return SingleChildScrollView(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(
                children: [
                    Padding(padding: const EdgeInsets.symmetric(vertical: 50), child: ClipRRect(borderRadius: Styles.borderRadius, child: Hero(tag: artist.id!, child:client.cachedImage(id: artist.coverArt!, fit: BoxFit.fill),))),
                    const ListTile(
                      title: Text('Albums', style: Styles.albumStyle),
                    ),
                    ...albumList.map((album) {
                      var tile = ListTile(
                          leading: AspectRatio(
                              aspectRatio: 1,
                              child: Hero(
                                  tag: album.id!,
                                  child: client.cachedImage(
                                      id: album.coverArt!))),
                          title: Text(album.album!,
                              style: Styles.results(theme)),
                          subtitle: Text(album.artist!),
                          subtitleTextStyle:
                              Styles.subtitleStyle,
                          onTap: () {
                            Navigator.pushNamed(context, '/AlbumView',
                                arguments: album.id!);
                          });
                      return tile;
                    }),
                    ],
                )));
            }
            return const CircularProgressIndicator();
        }
    )),
    PlayingPreview(client: client, player: player, context: context, theme: theme)]);
  }
}
