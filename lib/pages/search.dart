import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:navidrome_player/main.dart';
import 'package:navidrome_player/player.dart';
import 'package:navidrome_player/widgets.dart';
import 'package:navidrome_player/model.dart';
import 'package:navidrome_player/styles.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen();
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? query;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<MyAppState>();
    final client = appState.client;
    final player = appState.player;

    return Stack(children: [
      Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
              title: SearchBar(
                  trailing: const [Icon(Icons.search)],
                  hintText: 'Search for tracks, albums, artists',
                  onChanged: (searchInput) {
                    setState(() {
                      query = searchInput;
                    });
                  })),
          SliverList.list(children: [
            (query != null && query!.length > 1)
                ? FutureBuilder<SearchResult3?>(
                    // if query is not null then search the query else display nothing
                    future: client.search(query: query!),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        SearchResult3 searchResult3 = snapshot.data!;
                        List<Album> albumResults = searchResult3.album!;
                        List<Song> songResults = searchResult3.song!;
                        List<Artist> artistResults = searchResult3.artist!;

                        List<ListTile> listTiles = [];

                        if (albumResults.isNotEmpty) {
                          listTiles.addAll([
                            const ListTile(
                              title: Text('Albums', style: Styles.albumStyle),
                            ),
                            ...albumResults.map((album) {
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
                                  subtitleTextStyle: Styles.subtitleStyle,
                                  trailing: AlbumActions(
                                      player: player, album: album),
                                  onTap: () {
                                    Navigator.pushNamed(context, '/AlbumView',
                                        arguments: album.id!);
                                  });
                              return tile;
                            }),
                          ]);
                        }

                        if (songResults.isNotEmpty) {
                          listTiles.addAll([
                            const ListTile(
                                title: Text('Songs', style: Styles.albumStyle),
                                dense: true),
                            ...songResults.map((song) {
                              var tile = ListTile(
                                  leading: AspectRatio(
                                      aspectRatio: 1,
                                      child: client.cachedImage(
                                          id: song.coverArt!)),
                                  title: Text(
                                    song.title!,
                                    style: Styles.results(theme),
                                  ),
                                  subtitle: Text(song.artist!),
                                  subtitleTextStyle: Styles.subtitleStyle,
                                  trailing: SongActions(
                                      player: player,
                                      song: song,
                                      client: client),
                                  onTap: () {
                                    appState.player.playNow(song: song);
                                    appState.player.play();
                                  },
                                  onLongPress: () {
                                    appState.player.playNext(song: song);
                                  });
                              return tile;
                            }),
                          ]);
                        }

                        if (artistResults.isNotEmpty) {
                          listTiles.addAll([
                            const ListTile(
                                title:
                                    Text('Artists', style: Styles.albumStyle),
                                dense: true),
                            ...artistResults.map((artist) {
                              var tile = ListTile(
                                  onTap: (() {
                                    print('${artist.name} tapped!');
                                    Navigator.pushNamed(context, '/ArtistView',
                                        arguments: artist.id!);
                                  }),
                                  leading: AspectRatio(
                                      aspectRatio: 1,
                                      child: client.cachedImage(
                                          id: artist.coverArt!)),
                                  title: Text(artist.name!,
                                      style: Styles.results(theme)));
                              return tile;
                            }),
                          ]);
                        }

                        if (listTiles.isEmpty) {
                          listTiles = [
                            const ListTile(
                                title: Center(child: Text('No results found')))
                          ];
                        }

                        return ListView(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: listTiles,
                        );
                      }
                      return (const Center(child: CircularProgressIndicator()));
                    })
                : const SizedBox.shrink(),
            const SizedBox(height: 75),
          ])
        ]),
      ),
      PlayingPreview(
          client: client, player: player, context: context, theme: theme)
    ]);
  }
}
