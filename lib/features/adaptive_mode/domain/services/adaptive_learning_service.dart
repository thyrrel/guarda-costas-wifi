"import 'package:flutter/material.dart';

class LearnedPattern {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  bool isAccepted;

  LearnedPattern({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isAccepted = false,
  });
}

class AdaptiveLearningService {
  Future<List<LearnedPattern>> fetchLearnedPatterns() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      LearnedPattern(
        id: 'p1',
        title: \"Rotina Matinal de Trabalho\",
        description: \"Notei que todo dia de semana, por volta das 9h, você liga a luz do escritório e o ar-condicionado. Deseja automatizar isso?\",
        icon: Icons.work_outline_rounded,
      ),
      LearnedPattern(
        id: 'p2',
        title: \"Otimização de Energia Noturna\",
        description: \"Percebi que a TV da sala e o console ficam em stand-by a noite toda. Posso desligá-los completamente da tomada para economizar energia?\",
        icon: Icons.power_settings_new_rounded,
      ),
      LearnedPattern(
        id: 'p3',
        title: \"Ajuste de Conforto\",
        description: \"Notei que você sempre aumenta a intensidade da luz da sala às 20h. Gostaria de adicionar isso à sua cena 'Relaxar'?\",
        icon: Icons.lightbulb_outline_rounded,
      ),
    ];
  }
}"