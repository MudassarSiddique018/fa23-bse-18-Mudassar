import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const LudoFunApp());
}

class LudoFunApp extends StatelessWidget {
  const LudoFunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ludo Fun!',
      debugShowCheckedModeBanner: false,
      home: const LudoHomePage(),
    );
  }
}

class LudoHomePage extends StatefulWidget {
  const LudoHomePage({super.key});

  @override
  State<LudoHomePage> createState() => _LudoHomePageState();
}

class _LudoHomePageState extends State<LudoHomePage> {
  final TextEditingController playerNameController = TextEditingController();
  final List<String> players = [];
  final List<int> scores = [0, 0, 0, 0];
  int diceNumber = 1;
  int currentPlayer = 0;
  final random = Random();

  void addPlayer() {
    if (playerNameController.text.isNotEmpty && players.length < 4) {
      setState(() {
        players.add(playerNameController.text.trim());
        playerNameController.clear();
      });
    }
  }

  void rollDice() {
    setState(() {
      diceNumber = random.nextInt(6) + 1;
      scores[currentPlayer] += diceNumber;
      currentPlayer = (currentPlayer + 1) % players.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Ludo Fun!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.settings, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 30),

                // Player name input box
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Player Name',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: playerNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Enter player name',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.6)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.15),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: addPlayer,
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Add Player',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Turn text
                if (players.isNotEmpty)
                  Text(
                    "It’s ${players[currentPlayer]}'s Turn!",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  )
                else
                  const Text(
                    "Add Players to Start!",
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),

                const SizedBox(height: 25),

                // Dice display
                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage('assets/dice_$diceNumber.png'),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {},
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$diceNumber',
                    style: const TextStyle(
                      fontSize: 60,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(blurRadius: 10, color: Colors.black54)
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Roll Dice button
                ElevatedButton.icon(
                  onPressed: players.length >= 2 ? rollDice : null,
                  icon: const Icon(Icons.casino, color: Colors.deepPurple),
                  label: const Text(
                    'Roll Dice',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Scoreboard
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Scoreboard',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 15),
                      ...List.generate(players.length, (i) {
                        final colors = [
                          Colors.red,
                          Colors.blue,
                          Colors.green,
                          Colors.amber
                        ];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: colors[i].withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                players[i],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                scores[i].toString(),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
