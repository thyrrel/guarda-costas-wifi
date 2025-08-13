import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guarda_costas_wifi/core/providers/monitoring_provider.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MonitoringProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status do Monitoramento',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              provider.isMonitoring ? 'Ativo' : 'Inativo',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: provider.isMonitoring ? Colors.green : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: provider.isMonitoring,
                        onChanged: (value) {
                          if (value) {
                            provider.startMonitoring();
                          } else {
                            provider.stopMonitoring();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sessões Ativas (${provider.activeSessions.length})',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: provider.activeSessions.isEmpty
                              ? const Center(
                                  child: Text('Nenhuma sessão ativa'),
                                )
                              : ListView.builder(
                                  itemCount: provider.activeSessions.length,
                                  itemBuilder: (context, index) {
                                    final session = provider.activeSessions[index];
                                    return ListTile(
                                      leading: const Icon(Icons.monitor_heart),
                                      title: Text('Sessão ${session.id}'),
                                      subtitle: Text(
                                        'Duração: ${session.duration.inMinutes}min',
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.stop),
                                        onPressed: () {
                                          provider.removeSession(session.id);
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}