import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const QuizApp());
}

class QuizController extends GetxController {
  var currentQuestionIndex = 0.obs;
  var score = 0.obs;

  final List<Map<String, Object>> questions = [
    {
      'question': 'Jika YES adalah YA maka NO berarti?',
      'answers': [
        {'text': 'Boleh', 'score': 0},
        {'text': 'Jangan', 'score': 1},
      ],
    },
    {
      'question': 'Apakah Matahari terbit dari timur?',
      'answers': [
        {'text': 'Ya', 'score': 1},
        {'text': 'Tidak', 'score': 0},
      ],
    },
    {
      'question': 'Berapa jumlah bulan dalam setahun?',
      'answers': [
        {'text': '12', 'score': 1},
        {'text': '10', 'score': 0},
      ],
    },
  ];

  void answerQuestion(int score) {
    this.score.value += score;
    currentQuestionIndex.value++;
  }

  void resetQuiz() {
    score.value = 0;
    currentQuestionIndex.value = 0;
  }
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Quizederhana',
          style: TextStyle(fontSize: 24),),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: GetX<QuizController>(
          init: QuizController(),
          builder: (controller) {
            return controller.currentQuestionIndex.value < controller.questions.length
                ? Quiz(
                    question: controller.questions[controller.currentQuestionIndex.value]['question'] as String,
                    answers: controller.questions[controller.currentQuestionIndex.value]['answers'] as List<Map<String, Object>>,
                    answerQuestion: controller.answerQuestion,
                  )
                : Result(
                    totalScore: controller.score.value,
                    resetQuiz: controller.resetQuiz,
                  );
          },
        ),
      ),
    );
  }
}

class Quiz extends StatelessWidget {
  final String question;
  final List<Map<String, Object>> answers;
  final Function answerQuestion;

  const Quiz({super.key, 
    required this.question,
    required this.answers,
    required this.answerQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            question,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 38),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              question,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Pilih jawaban anda!',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: answers.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, Object> answer = entry.value;

              // Atur warna tombol berdasarkan urutan jawaban
              Color buttonColor = index == 0 ? Colors.blue : Colors.red;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () => answerQuestion(answer['score']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: Text(
                    answer['text'] as String,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class Result extends StatelessWidget {
  final int totalScore;
  final VoidCallback resetQuiz;

  const Result({
    required this.totalScore,
    required this.resetQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Quizederhana',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Skor Anda',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 332,
              height: 117,
              padding: const EdgeInsets.symmetric(vertical: 31, horizontal: 28),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1,color: Color(0xFF2c2c2c)),
                  borderRadius: BorderRadius.circular(24),
                )
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '$totalScore',
                    style: TextStyle(
                      color: Color(0xFF1E1E1E),
                      fontSize: 40,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            const Text(
              'Ingin coba lagi?',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetQuiz,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              child: const Text(
                'Ya',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}