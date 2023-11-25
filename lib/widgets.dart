import 'package:flutter/material.dart';
import 'package:navidrome_player/player.dart';

import 'package:navidrome_player/api_service.dart';
import 'package:navidrome_player/model.dart';

class SongActions extends StatelessWidget {
  const SongActions({
    super.key,
    required this.player,
    required this.song,
    required this.client,
  });

  final DioClient client;
  final Player player;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: (context) {
      return <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
            value: 0,
            child: ListTile(
                leading: Icon(Icons.play_arrow), title: Text('Play Now'))),
        const PopupMenuItem<int>(
            value: 1,
            child: ListTile(
                leading: Icon(Icons.queue_play_next),
                title: Text('Play Next'))),
        const PopupMenuItem<int>(
            value: 2,
            child: ListTile(
                leading: Icon(Icons.add_to_queue),
                title: Text('Add to Queue'))),
        PopupMenuItem<int>(
            value: 3,
            child: song.starred == null
                ? const ListTile(
                    leading: Icon(Icons.favorite), title: Text('Favorite'))
                : const ListTile(
                    leading: Icon(Icons.favorite_outline),
                    title: (Text("Unfavorite")),
                  )),
      ];
    }, onSelected: (selection) {
      switch (selection) {
        case 0:
          player.playNow(song: song);
          break;
        case 1:
          player.playNext(song: song);
          break;
        case 2:
          player.addToQueue(song: song);
          break;
        case 3:
          song.starred == null
              ? client.star(id: song.id!)
              : client.unstar(id: song.id!);
      }
    });
  }
}

class AlbumActions extends StatelessWidget {
  const AlbumActions({
    super.key,
    required this.player,
    required this.album,
  });

  final Player player;
  final Album album;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(itemBuilder: (context) {
      return const <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
            value: 0,
            child: ListTile(
                leading: Icon(Icons.play_arrow), title: Text('Play Now'))),
        PopupMenuItem<int>(
            value: 1,
            child: ListTile(
                leading: Icon(Icons.queue_play_next),
                title: Text('Play Next'))),
        PopupMenuItem<int>(
            value: 2,
            child: ListTile(
                leading: Icon(Icons.add_to_queue),
                title: Text('Add to Queue'))),
      ];
    }, onSelected: (selection) {
      switch (selection) {
        case 0:
          player.playNow(album: album);
          break;
        case 1:
          player.playNext(album: album);
          break;
        case 2:
          player.addToQueue(album: album);
          break;
      }
    });
  }
}
