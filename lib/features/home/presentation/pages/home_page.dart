import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guarda_costas_wifi/core/providers/wifi_provider.dart';
import 'package:guarda_costas_wifi/core/providers/monitoring_provider.dart';
import 'package:guarda_costas_wifi/features/wifi_scanner/presentation/pages/wifi_scanner_page.dart';
import 'package:guarda_costas_wifi/features/monitoring/presentation/pages/monitoring_page.dart';
import 'package:guarda_costas_wifi/features/settings/presentation/pages/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeTabView(),
    const WifiScannerPage(),
    const MonitoringPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guarda-Costas WiFi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<WifiProvider>().scanNetworks();
            },
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi_find),
            label: 'Scanner',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor),
            label: 'Monitor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Config.',
          ),
        ],
      ),
    );
  }
}

class HomeTabView extends StatelessWidget {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WifiProvider, MonitoringProvider>(
      builder: (context, wifiProvider, monitoringProvider, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCards(context, wifiProvider, monitoringProvider),
              const SizedBox(height: 20),
              _buildQuickActions(context),
              const SizedBox(height: 20),
              _buildRecentActivity(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusCards(BuildContext context, WifiProvider wifiProvider, MonitoringProvider monitoringProvider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.wifi,
                        size: 32,
                        color: wifiProvider.connectedNetwork != null 
                            ? Colors.green 
                            : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        wifiProvider.connectedNetwork?.ssid ?? 'Desconectado',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'WiFi',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.monitor_heart,
                        size: 32,
                        color: monitoringProvider.isMonitoring 
                            ? Colors.green 
                            : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        monitoringProvider.isMonitoring ? 'Ativo' : 'Inativo',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Monitoramento',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ações Rápidas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickActionButton(
                  context,
                  Icons.wifi_find,
                  'Escanear',
                  () => Navigator.pushNamed(context, '/wifi-scanner'),
                ),
                _buildQuickActionButton(
                  context,
                  Icons.play_circle,
                  'Monitor',
                  () => context.read<MonitoringProvider>().startMonitoring(),
                ),
                _buildQuickActionButton(
                  context,
                  Icons.location_on,
                  'Localização',
                  () => Navigator.pushNamed(context, '/location'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context, 
    IconData icon, 
    String label, 
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 32),
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atividade Recente',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.wifi),
              title: const Text('Rede WiFi detectada'),
              subtitle: const Text('2 minutos atrás'),
              trailing: Icon(
                Icons.circle,
                size: 12,
                color: Theme.of(context).primaryColor,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Localização atualizada'),
              subtitle: const Text('5 minutos atrás'),
              trailing: Icon(
                Icons.circle,
                size: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}