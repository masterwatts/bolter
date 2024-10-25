class Question {
  String questionPrompt;
  int questionNumber, marks, attempts;
  int? table;
  String? additionalInfo;
  dynamic correctAnswer;

  Question({
    required this.questionNumber,
    required this.questionPrompt,
    required this.additionalInfo,
    required this.correctAnswer,
    required this.marks,
    this.attempts = 0,
    this.table,
  });
}
