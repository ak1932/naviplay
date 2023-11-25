import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../styles.dart';
import '../main.dart';

class Queue extends StatefulWidget {
  const Queue({Key? key}) : super(key: key);

  @override
  State<Queue> createState() => _QueueState();
}

class _QueueState extends State<Queue> {
  final GlobalKey<ReorderableListState> _key = GlobalKey();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();
    var queue = appState.player.queue();
    // var currentIndex = appState.player.currentIndex();

    print("$currentIndex");
    return Scaffold(
        appBar: AppBar(title: const Text('Queue')),
        body: StreamBuilder(
            stream: appState.player.player.currentIndexStream.asBroadcastStream(),
            builder: (context, snapshot) {
                int currentIndex = snapshot.data ?? 0;
                return GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.direction <= 0) {
                        Navigator.pushReplacementNamed(context, '/PlayerView');
                      }
                    },
                    child: ReorderableListView.builder(
                        key: _key,
                        itemCount: queue.length,
                        itemBuilder: (context, index) {
                          var mediaItem = queue[index];
                          TextStyle? textStyle;
                          if (index < currentIndex) {
                            textStyle = Styles.queuePrevIndexStyle(theme);
                          } else if (index == currentIndex) {
                            textStyle = Styles.queueCurrentIndexStyle;
                          }
                          return ListTile(
                              key: Key(index.toString()),
                              leading: Text((index + 1).toString(),
                                  style: textStyle),
                              title: Text(mediaItem.title, style: textStyle));
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          print('$oldIndex ---- $newIndex');
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                          });
                          appState.player.playlist.move(oldIndex, newIndex);
                        }));
            }));
  }
}
