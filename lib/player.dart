import 'package:just_audio/just_audio.dart';
import 'package:navidrome_player/api_service.dart';
import 'package:miniplayer/miniplayer.dart';
import 'constants.dart';
import 'model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'styles.dart';
import 'package:audio_service/audio_service.dart';

const url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3';

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });
  final Duration progress;
  final Duration buffered;
  final Duration? total;
}

class Player {
  final player = AudioPlayer();
  Duration? duration;
  final playlist = ConcatenatingAudioSource(children: []);
  Stream<DurationState>? durationState;

  Player() {
    player.setAudioSource(playlist);
    // player.playbackEventStream.listen((event) {},
    //     onError: (Object e, StackTrace st) {
    //   if (e is PlayerException) {
    //     print('Error code: ${e.code}');
    //     print('Error message: ${e.message}');
    //   } else {
    //     print('An error occurred: $e');
    //   }
    // });
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
        (position, playbackEvent) => DurationState(
              progress: position,
              buffered: playbackEvent.bufferedPosition,
              total: playbackEvent.duration,
            )).asBroadcastStream();
  }

  void dispose() {
    player.dispose();
  }

  UriAudioSource songAudioSource({required Song song}) {
    var streamUri =
        Uri.http(Api.baseUrl, Api.stream, {...Api.auth, 'id': song.id});
    var coverArtUri =
        Uri.http(Api.baseUrl, Api.getCoverArt, {...Api.auth, 'id': song.id});
    bool liked = song.starred != null;

    var audioSource = AudioSource.uri(
      streamUri,
      tag: MediaItem(
        rating: Rating.newHeartRating(liked),
        // Specify a unique ID for each media item:
        id: song.id!,
        // Metadata to display in the notification:
        album: song.album,
        title: song.title!,
        artist: song.artist,
        artUri: coverArtUri,
      ),
    );
    return audioSource;
  }

  void play() async {
    await player.play();
  }

  void next() async {
    await player.seekToNext();
  }

  void prev() async {
    await player.seekToPrevious();
  }

  void pause() async {
    await player.pause();
  }

  void stop() async {
    await player.stop();
  }

  void seek(Duration seekTime) async {
    await player.seek(seekTime);
  }

  void addToQueue({Album? album, Song? song}) async {
    if (album != null) {
      print('added ${album.album} to queue');
      List<UriAudioSource> audioSources = album.song!.map((song) {
        return songAudioSource(song: song);
      }).toList();
      playlist.addAll(audioSources);
    }
    if (song != null) {
      print('added ${song.title} to queue');
      playlist.add(songAudioSource(song: song));
    }
    queue();
  }

  void playNext({Album? album, Song? song}) async {
    var index = (playlist.children.isEmpty) ? 0 : player.currentIndex! + 1;
    if (album != null) {
      print('playing ${album.album} next');
      List<UriAudioSource> audioSources = album.song!.map((song) {
        return songAudioSource(song: song);
      }).toList();
      playlist.insertAll(index, audioSources);
    }
    if (song != null) {
      print('playing ${song.title} next');
      playlist.insert(index, songAudioSource(song: song));
    }
    queue();
  }

  void playNow({Album? album, Song? song}) async {
    playlist.clear();
    player.seek(Duration.zero);
    if (album != null) {
      print('playing ${album.album} now');
      List<UriAudioSource> audioSources = album.song!.map((song) {
        return songAudioSource(song: song);
      }).toList();
      playlist.addAll(audioSources);
    }
    if (song != null) {
      print('playing ${song.title} now');
      playlist.add(songAudioSource(song: song));
    }
    player.load();
    queue();
  }

  List<MediaItem> queue() {
    print('-----------------------------------------------------');
    print('Queue');
    List<MediaItem> mediaItems = playlist.sequence.map((indexedAudioSource) {
      var mediaItem = indexedAudioSource.tag as MediaItem;
      print(mediaItem.title);
      return mediaItem;
    }).toList();
    print('-----------------------------------------------------');

    return mediaItems;
  }

  int currentIndex() {
    return player.currentIndex!;
  }

  StreamBuilder<PlayerState> playButton(ThemeData theme, {double buttonSize = 60.0}) {
    var iconColor = theme.colorScheme.primary;
    return StreamBuilder<PlayerState>(
      stream: player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: buttonSize,
            height: buttonSize,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(Icons.play_circle),
            color: iconColor,
            iconSize: buttonSize,
            onPressed: player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause_circle),
            color: iconColor,
            iconSize: buttonSize,
            onPressed: player.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            color: iconColor,
            iconSize: buttonSize,
            onPressed: () => player.seek(Duration.zero),
          );
        }
      },
    );
  }

  StreamBuilder<DurationState> progressBar(
      {double thumbRadius = 0, bool text = true}) {
    return StreamBuilder<DurationState>(
      stream: durationState,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        var timeLabelLocation = TimeLabelLocation.sides;
        if (!text) {
          timeLabelLocation = TimeLabelLocation.none;
        }
        return ProgressBar(
          timeLabelTextStyle: Styles.subtitleStyle,
          progress: progress,
          buffered: buffered,
          total: total,
          onSeek: player.seek,
          onDragUpdate: (details) {
            print('${details.timeStamp}, ${details.localPosition}');
          },
          barCapShape: BarCapShape.square,
          barHeight: 2,
          thumbRadius: thumbRadius,
          timeLabelLocation: timeLabelLocation,
          // barHeight: _barHeight,
          // baseBarColor: _baseBarColor,
          // progressBarColor: _progressBarColor,
          // bufferedBarColor: _bufferedBarColor,
          // thumbColor: _thumbColor,
          // thumbGlowColor: _thumbGlowColor,
          // barCapShape: _barCapShape,
          // thumbRadius: _thumbRadius,
          // thumbCanPaintOutsideBar: _thumbCanPaintOutsideBar,
          // timeLabelLocation: _labelLocation,
          // timeLabelType: _labelType,
          // timeLabelTextStyle: _labelStyle,
          // timeLabelPadding: _labelPadding,
        );
      },
    );
  }
}

class PlayingPreview extends StatefulWidget {
  final DioClient client;
  final Player player;
  final BuildContext context;
  final ThemeData theme;

  PlayingPreview(
      {Key? key,
      required this.client,
      required this.player,
      required this.context,
      required this.theme})
      : super(key: key);
  @override
  _PlayingPreviewState createState() => _PlayingPreviewState();
}

class _PlayingPreviewState extends State<PlayingPreview> {
  int? currentIndex;
  @override
  Widget build(BuildContext context) {
    final player = widget.player;
    final playlist = widget.player.playlist;
    final theme = widget.theme;
    final client = widget.client;
    const iconSize = 25.0;

    return Miniplayer(
        minHeight: 75,
        maxHeight: 75,
        builder: (height, percentage) {
          var currentPlaylist = playlist.sequence;
          player.player.currentIndexStream.listen((index) {
                  setState(() {
                            // print('updating miniplayer');
                            currentIndex = index;
                          });
          }, onError: (Object e, StackTrace st) {
            if (e is PlayerException) {
              print('Error code: ${e.code}');
              print('Error message: ${e.message}');
            } else {
              print('An error occurred: $e');
            }
          });

          if (playlist.sequence.isEmpty) {
            return const Center(
                child: Text('Nothing Playing!', style: Styles.albumStyle));
          }

          final currentTag = currentPlaylist[currentIndex!].tag as MediaItem;
          return Column(children: [
            player.progressBar(thumbRadius: 0, text: false),
            ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/PlayerView');
                },
                leading: client.cachedImage(id: currentTag.id, height: 50),
                title: Text(currentTag.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: Styles.miniplayerTitle),
                subtitle: Text(currentTag.artist!, style: Styles.subtitleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: player.playButton(theme, buttonSize: iconSize),
                // trailing: SizedBox(width: 145,child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                //   IconButton(
                //       icon: const Icon(Icons.skip_previous),
                //       iconSize: iconSize,
                //       onPressed: () {
                //         player.player.seekToPrevious();
                //       }),
                //   player.playButton(theme, buttonSize: iconSize),
                //   IconButton(
                //   padding: const EdgeInsets.all(0),
                //       icon: const Icon(Icons.skip_next),
                //       iconSize: iconSize,
                //       onPressed: () {
                //         player.player.seekToNext();
                //       }),
                // ]))
          )]);
        });
  }
}

class ControlBar extends StatefulWidget {
  final String songId;
  final Player player;
  final ThemeData theme;
  final DioClient client;
  Rating? rating;
  ControlBar(
      {Key? key,
      required this.client,
      required this.songId,
      required this.player,
      required this.theme,
      required this.rating})
      : super(key: key);
  @override
  _ControlBarState createState() => _ControlBarState();
}

class _ControlBarState extends State<ControlBar> {
  var liked = true;
  @override
  Widget build(BuildContext context) {
      final player = widget.player;
    liked = widget.rating == const Rating.newHeartRating(true);
    var iconSize = 30.0;
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 50),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            selectedIcon: const Icon(Icons.favorite),
            isSelected: liked,
            onPressed: (() {
              widget.client.star(id: widget.songId);
              setState(() {
                if (liked) {
                  widget.client.unstar(id: widget.songId);
                  widget.rating = const Rating.newHeartRating(false);
                } else {
                  widget.client.star(id: widget.songId);
                  widget.rating = const Rating.newHeartRating(true);
                }
              });
            }),
          ),
          IconButton(
              icon: const Icon(Icons.skip_previous),
              iconSize: iconSize,
              onPressed: () {
                player.player.seekToPrevious();
              }),
          player.playButton(widget.theme),
          IconButton(
              icon: const Icon(Icons.skip_next),
              iconSize: iconSize,
              onPressed: () {
                player.player.seekToNext();
              }),
          IconButton(
            icon: const Icon(Icons.shuffle),
            selectedIcon: const Icon(Icons.shuffle_on),
            isSelected: false,
            onPressed: (() {}),
          ),
        ]));
  }

}
