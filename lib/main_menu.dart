import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:bolter_flutter/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  List<String> items = ["Easy 😋", "Normal 😲", "Master 🤯", "Calculus 😱"];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  late final SingleSelectController difficultyController;

  @override
  void initState() {
    difficultyController = SingleSelectController("Easy 😋");
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    difficultyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          bottom: 40,
          left: 30,
          right: 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              children: [
                Text(
                  "⚡️🤓",
                  style: TextStyle(
                    fontSize: 100,
                    height: 1,
                  ),
                ),
                Text(
                  "Bolter",
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),
                Text(
                  "Are you faster than a 5th grader?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      flex: 1,
                      child: Text(
                        "Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 15,
                          ),
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey.withAlpha(
                              150,
                            ),
                          ),
                          hintText: "Enter your name",
                          fillColor: Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "Age",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: TextField(
                            controller: ageController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 15,
                              ),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey.withAlpha(
                                  150,
                                ),
                              ),
                              hintText: "Enter your age",
                              fillColor: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(
                            "Difficulty",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: CustomDropdown(
                            controller: difficultyController,
                            items: items,
                            hintText: "Select",
                            onChanged: (value) {},
                            decoration: CustomDropdownDecoration(
                              closedBorder: Border.all(
                                color: Colors.grey.shade900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Game(
                            playerName: nameController.text,
                            age: int.tryParse(ageController.text)!,
                            calculus:
                                difficultyController.value == "Calculus 😱",
                            maxTable: difficultyController.value == "Easy 😋"
                                ? 2
                                : difficultyController.value == "Normal 😲"
                                    ? 5
                                    : 20,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      "Let's start!",
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
