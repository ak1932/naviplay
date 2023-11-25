// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter/services.dart';

import 'api_service.dart';
import 'player.dart';
import 'pages/queue.dart';
import 'pages/search.dart';
import 'pages/albumView.dart';
import 'pages/albumListPage.dart';
import 'pages/playerView.dart';
import 'pages/homepage.dart';
import 'pages/artist_view.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      final theme = ThemeData(
        useMaterial3: true,
        colorScheme:
            darkColorScheme ?? ColorScheme.fromSeed(seedColor: Colors.green),
      );
      return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Navidrome Player',
          routes: {
            '/HomePage': (context) => HomePage(),
            '/AlbumListPage': (context) => AlbumListPage(),
            '/AlbumView': (context) => AlbumView(),
            '/ArtistView': (context) => ArtistView(),
            '/Queue': (context) => Queue(),
            '/SearchScreen': (context) => SearchScreen(),
            '/PlayerView': (context) => PlayerView(),
          },
          theme: theme.copyWith(
              appBarTheme: AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: theme.colorScheme.background))),
          home: HomePage(),
        ),
      );
    });
  }
}

class MyAppState extends ChangeNotifier {
  String albumListType = 'frequent';
  final player = Player();
  Duration? duration;
  final client = DioClient();
}
