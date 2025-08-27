import 'package:flutter/material.dart';
import 'next_page.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slide Puzzle',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MySlidePuzzle(title: 'Slide Puzzle'),
    );
  }
}

class MySlidePuzzle extends StatefulWidget {
  const MySlidePuzzle({super.key, required this.title});
  final String title;
  @override
  State<MySlidePuzzle> createState() => _MySlidePuzzle();
}

class _MySlidePuzzle extends State<MySlidePuzzle> {
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.setSource(AssetSource('audio/bgm.mp3'));
    player.setReleaseMode(ReleaseMode.loop);
    player.resume();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('スライドパズル', style: TextStyle(fontSize: 30.0)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                player.pause();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SlidePuzz()),
                ).then((_) {
                  player.resume();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text('スタート'),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
