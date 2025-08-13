import 'package:flutter/material.dart';
import 'package:guarda_costas_wifi/features/adaptive_mode/domain/services/adaptive_learning_service.dart';
import 'package:guarda_costas_wifi/core/widgets/loading_indicator.dart';

class AdaptiveModeScreen extends StatefulWidget {
  const AdaptiveModeScreen({super.key});

  @override
  State<AdaptiveModeScreen> createState() => _AdaptiveModeScreenState();
}

class _AdaptiveModeScreenState extends State<AdaptiveModeScreen> {
  final AdaptiveLearningService _service = AdaptiveLearningService();
  late Future<List<LearnedPattern>> _patternsFuture;

  @override
  void initState() {
    super.initState();
    _patternsFuture = _service.fetchLearnedPatterns();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modo Adaptativo da IA")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Nossa IA aprende com seus hábitos e sugere automações para tornar sua vida mais fácil e sua casa mais eficiente. Aprove as sugestões que gostar.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<LearnedPattern>>(
                future: _patternsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Nenhuma sugestão nova no momento."));
                  }
                  final patterns = snapshot.data!;
                  return ListView.builder(
                    itemCount: patterns.length,
                    itemBuilder: (context, index) {
                      final pattern = patterns[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: Icon(pattern.icon, size: 40),
                                title: Text(pattern.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(pattern.description),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(child: const Text("Ignorar"), onPressed: () {}),
                                  const SizedBox(width: 8),
                                  FilledButton.icon(
                                    icon: const Icon(Icons.auto_awesome, size: 18),
                                    label: const Text("Criar Automação"),
                                    onPressed: () {},
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}