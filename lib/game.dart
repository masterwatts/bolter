import 'dart:math';

import 'package:bolter_flutter/question.dart';
import 'package:bolter_flutter/question_bank.dart';
import 'package:bolter_flutter/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:tex_text/tex_text.dart';

class Game extends StatefulWidget {
  String playerName;
  int age;
  bool calculus;
  int maxTable;
  int points;

  List<Question> questions = [];

  Game(
      {super.key,
      required this.playerName,
      required this.age,
      required this.calculus,
      required this.maxTable,
      this.points = 0});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final List<TextEditingController> _textEditControllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    createNewQuestion(0, widget.calculus, widget.maxTable);
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _textEditControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void createNewQuestion(int lastQuestionNo, bool calculus, int maxTable) {
    if (calculus) {
      var values = QuestionBank().limitsAndContinuityQuestions.values.toList();
      int questionIndex = Random().nextInt(values.length);

      widget.questions.insert(
          0,
          Question(
            questionNumber: lastQuestionNo + 1,
            questionPrompt: "Determine the limit.",
            additionalInfo: QuestionBank()
                .limitsAndContinuityQuestions
                .keys
                .toList()[questionIndex],
            correctAnswer: values[questionIndex],
            marks: 3,
          ));
      _textEditControllers.insert(0, TextEditingController());
      _focusNodes.insert(0, FocusNode());
      _focusNodes[0].requestFocus();
      setState(() {});
    } else {
      int itemsNo = Random().nextInt(13);
      int table = Random().nextInt(maxTable - 1) + 2;

      String item = (QuestionBank().items..shuffle()).first;
      widget.questions.insert(
        0,
        Question(
          questionNumber: lastQuestionNo + 1,
          questionPrompt:
              "In the ${(QuestionBank().rooms..shuffle()).first}, you see $table ${(QuestionBank().containers..shuffle()).first} containing $itemsNo $item. How many $item do you have?",
          correctAnswer: itemsNo * table,
          marks: 2,
          additionalInfo: null,
          table: table,
        ),
      );
      _textEditControllers.insert(0, TextEditingController());
      _focusNodes.insert(0, FocusNode());
      _focusNodes[0].requestFocus();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: ListView(
          reverse: true,
          children: [
            ...widget.questions.map(
              (q) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.7,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: q.questionNumber.toString(),
                                    style: const TextStyle(
                                      fontFamily: "Arial",
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: "    ",
                                    style: TextStyle(
                                      fontFamily: "Arial",
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text: q.questionPrompt,
                                    style: const TextStyle(
                                      fontFamily: "Arial",
                                      fontSize: 20,
                                      color: Colors.black,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    q.additionalInfo == null
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: TexText(
                                  q.additionalInfo!,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    widget.calculus
                        ? const SizedBox.shrink()
                        : const SizedBox(
                            height: 10,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextField(
                            enabled:
                                (widget.questions.length) - q.questionNumber ==
                                    0,
                            focusNode: _focusNodes[
                                widget.questions.length - q.questionNumber],
                            controller: _textEditControllers[
                                (widget.questions.length) - q.questionNumber],
                            style: const TextStyle(
                              fontFamily: "Arial",
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                            onSubmitted: (value) {
                              q.attempts++;
                              if (value == q.correctAnswer ||
                                  int.tryParse(value) == q.correctAnswer ||
                                  double.tryParse(value) == q.correctAnswer) {
                                widget.points += q.marks;
                                if (q.questionNumber >= 10) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ResultScreen(
                                        questions: widget.questions,
                                        points: widget.points,
                                        calculus: widget.calculus,
                                      ),
                                    ),
                                  );
                                } else {
                                  createNewQuestion(q.questionNumber,
                                      widget.calculus, widget.maxTable);
                                }
                              } else {
                                if (q.marks - 1 == 0) {
                                  createNewQuestion(q.questionNumber,
                                      widget.calculus, widget.maxTable);
                                  q.marks = 0;
                                } else if (!widget.calculus) {
                                  q.marks--;
                                }

                                setState(
                                  () {
                                    _textEditControllers[0].clear();
                                    _focusNodes[0].requestFocus();
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "[${q.marks}]",
                          style: const TextStyle(
                            fontFamily: "Arial",
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    widget.calculus
                        ? const SizedBox.shrink()
                        : const SizedBox(
                            height: 20,
                          ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
