import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SlidePuzz extends StatefulWidget {
  const SlidePuzz({super.key});

  @override
  State<SlidePuzz> createState() => _SlidePuzzState();
}

class _SlidePuzzState extends State<SlidePuzz> {
  List<int> puzzle = List.generate(9, (index) => index + 1)..last = 0;
  final List<int> solved = [1, 2, 3, 4, 5, 6, 7, 8, 0];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    shuffle();
  }

  void savePuzzle() async {
    final prefs = await SharedPreferences.getInstance();
    final puzzleString = jsonEncode(puzzle);
    await prefs.setString('savedPuzzle', puzzleString);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('パズルが保存されました！')));
  }

  void restorePuzzle() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final puzzleString = prefs.getString('savedPuzzle');

    if (puzzleString != null) {
      final List<dynamic> jsonList = jsonDecode(puzzleString);
      final List<int> restoredPuzzle = jsonList.cast<int>();

      setState(() {
        puzzle = restoredPuzzle;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('パズルが復元されました！')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('保存されたパズルはありません。')));
    }
  }

  void shuffle() {
    setState(() {
      puzzle = List.from(solved);
      for (int i = 0; i < 100; i++) {
        final blankIndex = puzzle.indexOf(0);
        final neighbors = <int>[];

        if (blankIndex % 3 != 0) neighbors.add(blankIndex - 1); // 左
        if (blankIndex % 3 != 2) neighbors.add(blankIndex + 1); // 右
        if (blankIndex ~/ 3 != 0) neighbors.add(blankIndex - 3); // 上
        if (blankIndex ~/ 3 != 2) neighbors.add(blankIndex + 3); // 下

        final swapIndex = neighbors[_random.nextInt(neighbors.length)];
        final temp = puzzle[blankIndex];
        puzzle[blankIndex] = puzzle[swapIndex];
        puzzle[swapIndex] = temp;
      }
    });
  }

  void move(int index) {
    final blankIndex = puzzle.indexOf(0);

    if ((index % 3 == blankIndex % 3 && (index - blankIndex).abs() == 3) ||
        (index ~/ 3 == blankIndex ~/ 3 && (index - blankIndex).abs() == 1)) {
      setState(() {
        final temp = puzzle[blankIndex];
        puzzle[blankIndex] = puzzle[index];
        puzzle[index] = temp;
      });
    }
  }

  bool isSolved() {
    for (int i = 0; i < puzzle.length; i++) {
      if (puzzle[i] != solved[i]) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('スライドパズル'),
        actions: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: restorePuzzle,
              ),
              IconButton(icon: const Icon(Icons.save), onPressed: savePuzzle),
            ],
          ),
        ],
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              height: 400,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: puzzle.length,
                itemBuilder: (context, index) {
                  if (puzzle[index] == 0) {
                    return const SizedBox();
                  }
                  final Color panelColor = isSolved()
                      ? Colors.green
                      : Colors.blue;

                  return GestureDetector(
                    onTap: () => move(index),
                    child: Container(
                      color: panelColor,
                      alignment: Alignment.center,
                      child: Text(
                        '${puzzle[index]}',
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 150),
            ElevatedButton.icon(
              onPressed: shuffle,
              icon: const Icon(Icons.shuffle),
              label: const Text('シャッフル'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(400, 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
