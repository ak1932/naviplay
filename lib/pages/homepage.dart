import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api_service.dart';
import 'package:navidrome_player/player.dart';

import '../main.dart';
import '../model.dart';
import '../styles.dart';

enum AlbumListType { frequent, recent, newest }

class HomePage extends StatelessWidget {
  static const routeName = '/homePage';
  FutureBuilder discover_grid({required DioClient client}) {
    return FutureBuilder(
        future: client.getAlbumList(type: 'random', size: '6'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Album> albums = snapshot.data!;
            return GridView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 350,
                  mainAxisSpacing: 0,
                  mainAxisExtent: 70,
                  crossAxisSpacing: 0),
              children: albums.map((album) {
                return Center(
                    child: ListTile(
                  onTap: (() {
                    Navigator.pushNamed(context, '/AlbumView',
                        arguments: album.id!);
                  }),
                  leading: AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                          borderRadius: Styles.borderRadius,
                          child: client.cachedImage(id: album.id!))),
                  title: Text(album.title!,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ));
              }).toList(),
            );
          }
          return const CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final client = appState.client;
    final player = appState.player;
    final theme = Theme.of(context);
    return Scaffold(
        body: Stack(children: [
      CustomScrollView(slivers: [
        SliverAppBar(
            leading: const Icon(Icons.library_music),
            title: const Text('Naviplay', style: Styles.albumStyle),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/SearchScreen');
                  },
                  icon: const Icon(Icons.search))
            ]),
        SliverList(
          delegate: SliverChildListDelegate.fixed([
            const ListTile(
              dense: true,
              title: Text('Discover', style: Styles.albumStyle),
            ),
            discover_grid(client: client),
            ...albumListPreview(
                type: AlbumListType.frequent,
                context: context,
                appState: appState,
                client: client),
            ...albumListPreview(
                type: AlbumListType.recent,
                context: context,
                appState: appState,
                client: client),
            ...albumListPreview(
                type: AlbumListType.newest,
                context: context,
                appState: appState,
                client: client),
            const SizedBox(height: 75),
          ]),
        )
      ]),
      PlayingPreview(
          client: client, player: player, context: context, theme: theme),
    ]));
  }
}

FutureBuilder<List<Album>?> albumListPreviewImages(
    {required String type,
    required DioClient client,
    required MyAppState appState}) {
  return FutureBuilder<List<Album>?>(
      future: client.getAlbumList(type: type, size: '10'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Album> albums = snapshot.data!;
          return SizedBox(
              height: 150,
              child: ListView(
                  padding: const EdgeInsets.all(10.0),
                  scrollDirection: Axis.horizontal,
                  children: albums.map((album) {
                    return GestureDetector(
                        child: albumBox(client: client, album: album),
                        onTap: () {
                          Navigator.pushNamed(context, '/AlbumView',
                              arguments: album.id!);
                        });
                  }).toList()));
        }
        return const Center(child: CircularProgressIndicator());
      });
}

Padding albumBox({required Album album, required DioClient client}) {
  return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: Styles.borderRadius,
        child: client.cachedImage(id: album.id!, fit: BoxFit.fill),
      ));
}

List<Widget> albumListPreview(
    {required AlbumListType type,
    required DioClient client,
    required MyAppState appState,
    required BuildContext context}) {
  String categoryText, listCategory;
  switch (type) {
    case AlbumListType.newest:
      {
        categoryText = 'Recently Added';
        listCategory = 'newest';
        break;
      }
    case AlbumListType.frequent:
      {
        categoryText = 'Most Played';
        listCategory = 'frequent';
        break;
      }
    case AlbumListType.recent:
      {
        categoryText = 'Last Played';
        listCategory = 'recent';
        break;
      }
  }
  return [
    ListTile(
        trailing: const Icon(Icons.arrow_right),
        dense: true,
        title: Text(categoryText, style: Styles.albumStyle),
        onTap: () {
          Navigator.pushNamed(context, '/AlbumListPage',
              arguments: listCategory);
        }),
    albumListPreviewImages(
        type: listCategory, client: client, appState: appState),
  ];
}
