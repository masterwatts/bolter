import 'dart:math';

import 'package:bolter_flutter/main_menu.dart';
import 'package:bolter_flutter/question.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  List<Question> questions;
  int points;
  bool calculus;
  ResultScreen({
    super.key,
    required this.questions,
    required this.points,
    required this.calculus,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    super.initState();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  Colors.white,
                  Colors.red,
                  Colors.yellow,
                  Colors.blue,
                  Colors.purple,
                  Colors.green,
                ],
                createParticlePath: (size) {
                  // Method to convert degrees to radians
                  double degToRad(double deg) => deg * (pi / 180.0);

                  const numberOfPoints = 5;
                  final halfWidth = size.width / 2;
                  final externalRadius = halfWidth;
                  final internalRadius = halfWidth / 2.5;
                  final degreesPerStep = degToRad(360 / numberOfPoints);
                  final halfDegreesPerStep = degreesPerStep / 2;
                  final path = Path();
                  final fullAngle = degToRad(360);
                  path.moveTo(size.width, halfWidth);

                  for (double step = 0;
                      step < fullAngle;
                      step += degreesPerStep) {
                    path.lineTo(halfWidth + externalRadius * cos(step),
                        halfWidth + externalRadius * sin(step));
                    path.lineTo(
                        halfWidth +
                            internalRadius * cos(step + halfDegreesPerStep),
                        halfWidth +
                            internalRadius * sin(step + halfDegreesPerStep));
                  }
                  path.close();
                  return path;
                },
              ),
            ),
            ListView(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Congratulations!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "You got: ${widget.points} points!",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Key practice areas:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...widget.questions.reversed.map((q) {
                  if (q.marks != 2 && !widget.calculus) {
                    return Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "You need to practice multiplication table no. ${q.table}. (question no. ${q.questionNumber}) - dropped ${2 - q.marks}/2 marks.",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                const SizedBox(
                  height: 50,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Questions:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ...widget.questions.reversed.map((q) {
                  return Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Question ${q.questionNumber}:",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text("Prompt: ${q.questionPrompt}"),
                        Text("Achieved points: ${q.marks}"),
                        const SizedBox(
                          height: 10,
                        ),
                      ]
                          .map(
                            (w) => Align(
                              alignment: Alignment.centerLeft,
                              child: w,
                            ),
                          )
                          .toList(),
                    ),
                  );
                }),
                Align(
                  alignment: Alignment.bottomRight,
                  child: MaterialButton(
                    color: Colors.white30,
                    child: const Text("Home screen"),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MainMenu(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
