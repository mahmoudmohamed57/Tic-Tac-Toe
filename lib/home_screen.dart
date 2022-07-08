import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String activePlayer = 'X', result = '';
  bool gameOver = false, isSwitched = false;
  int turn = 0;
  Game game = Game();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                children: [
                  block1(),
                  block2(),
                  const SizedBox(
                    height: 15.0,
                  ),
                  block3(),
                  block4(),
                  const SizedBox(
                    height: 15.0,
                  ),
                  block5(),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        block1(),
                        const SizedBox(
                          height: 15.0,
                        ),
                        block2(),
                        const SizedBox(
                          height: 15.0,
                        ),
                        block4(),
                        const SizedBox(
                          height: 15.0,
                        ),
                        block5(),
                      ],
                    ),
                  ),
                  block3(),
                ],
              ),
      ),
    );
  }

  Widget block1() {
    return SwitchListTile(
      title: const Text(
        'Auto Play / Two Player',
        style: TextStyle(
          color: Colors.white,
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
      value: isSwitched,
      onChanged: (bool newValue) {
        setState(() {
          isSwitched = newValue;
        });
      },
    );
  }

  Widget block2() {
    return Text(
      'it\'s $activePlayer turn',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 50.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget block3() {
    return Expanded(
      child: GridView.count(
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 1.0,
        crossAxisCount: 3,
        children: List.generate(
          9,
          (index) => InkWell(
            borderRadius: BorderRadius.circular(15.0),
            onTap: () => onTap(index),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).shadowColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Text(
                Player.playerX.contains(index)
                    ? 'X'
                    : Player.playerO.contains(index)
                        ? 'O'
                        : '',
                style: TextStyle(
                  color: Player.playerX.contains(index)
                      ? Colors.blue
                      : Colors.pink,
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget block4() {
    return Text(
      result,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget block5() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          Player.playerX = [];
          Player.playerO = [];
          activePlayer = 'X';
          result = '';
          gameOver = false;
          isSwitched = false;
          turn = 0;
        });
      },
      icon: const Icon(Icons.replay),
      label: const Text('Repeat The Game'),
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).shadowColor),
      ),
    );
  }

  void onTap(int index) async {
    if (!gameOver) {
      if (!Player.playerX.contains(index) && !Player.playerO.contains(index)) {
        game.playGame(index, activePlayer);
        updateState();
        if (!isSwitched) {
          await game.autoPlay(activePlayer);
          updateState();
        }
      }
    }
  }

  void updateState() {
    setState(() {
      turn++;
      activePlayer = activePlayer == 'X' ? 'O' : 'X';
      String ans = game.checkWinner();
      if (ans == '') {
        result = 'it\'s Draw';
        if (turn < 9) {
          result = '';
        }
      } else {
        gameOver = true;
        result = 'Player $ans is the Winner';
      }
    });
  }
}
