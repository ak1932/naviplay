import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:navidrome_player/player.dart';
import '../main.dart';
import '../model.dart';
import '../styles.dart';

class AlbumListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    var client = appState.client;
    var player = appState.player;
    final type = ModalRoute.of(context)!.settings.arguments as String;

    return Stack(children: [
      Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
            title: Text(type),
          ),
          SliverList.list(children: [
            FutureBuilder<List<Album>?>(
                future: client.getAlbumList(type: type, size: '25'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Album>? albumList = snapshot.data;

                    if (albumList != null) {
                      print(AlbumList);
                      return GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                mainAxisExtent: 200,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 10),
                        itemCount: albumList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final album = albumList[index];
                          return ClipRRect(
                              borderRadius: Styles.borderRadius,
                              child: GestureDetector(
                                child: GridTile(
                                  footer: GridTileBar(
                                      backgroundColor: Colors.black,
                                      title: Text(album.album!,
                                          overflow: TextOverflow.ellipsis),
                                      subtitle: Text(album.artist!.toString(),
                                          style: Styles.smallSubtitleStyle(
                                              theme))),
                                  child: Hero(
                                      tag: album.id!,
                                      child: client.cachedImage(id: album.id!)),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, '/AlbumView',
                                      arguments: album.id!);
                                },
                              ));
                        },
                        padding: const EdgeInsets.all(20),
                      );
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
            const SizedBox(height: 75),
          ])
        ]),
      ),
        PlayingPreview(
            client: client, player: player, context: context, theme: theme)
    ]);
  }
}
