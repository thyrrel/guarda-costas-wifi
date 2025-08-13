import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guarda_costas_wifi/core/providers/wifi_provider.dart';
import 'package:guarda_costas_wifi/core/models/wifi_network.dart';

class WifiScannerPage extends StatefulWidget {
  const WifiScannerPage({super.key});

  @override
  State<WifiScannerPage> createState() => _WifiScannerPageState();
}

class _WifiScannerPageState extends State<WifiScannerPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WifiProvider>().scanNetworks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<WifiProvider>(
        builder: (context, provider, child) {
          if (provider.isScanning) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Escaneando redes WiFi...'),
                ],
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao escanear redes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.scanNetworks();
                    },
                    child: const Text('Tentar Novamente'),
                  ),
                ],
              ),
            );
          }

          if (provider.availableNetworks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off, size: 64),
                  SizedBox(height: 16),
                  Text('Nenhuma rede encontrada'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.scanNetworks(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.availableNetworks.length,
              itemBuilder: (context, index) {
                final network = provider.availableNetworks[index];
                return WifiNetworkTile(
                  network: network,
                  onTap: () => _showNetworkDetails(context, network),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<WifiProvider>().scanNetworks(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _showNetworkDetails(BuildContext context, WifiNetwork network) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => WifiNetworkDetailsSheet(network: network),
    );
  }
}

class WifiNetworkTile extends StatelessWidget {
  final WifiNetwork network;
  final VoidCallback onTap;

  const WifiNetworkTile({
    super.key,
    required this.network,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          _getWifiIcon(),
          color: _getSignalColor(),
        ),
        title: Text(
          network.ssid.isNotEmpty ? network.ssid : 'Rede Oculta',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sinal: ${network.signalQuality}'),
            Text('Segurança: ${network.security}'),
          ],
        ),
        trailing: network.isConnected 
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: onTap,
      ),
    );
  }

  IconData _getWifiIcon() {
    if (network.signalStrength >= -50) return Icons.wifi;
    if (network.signalStrength >= -60) return Icons.wifi_2_bar;
    if (network.signalStrength >= -70) return Icons.wifi_1_bar;
    return Icons.wifi_0_bar;
  }

  Color _getSignalColor() {
    if (network.signalStrength >= -50) return Colors.green;
    if (network.signalStrength >= -60) return Colors.orange;
    if (network.signalStrength >= -70) return Colors.red;
    return Colors.grey;
  }
}

class WifiNetworkDetailsSheet extends StatelessWidget {
  final WifiNetwork network;

  const WifiNetworkDetailsSheet({
    super.key,
    required this.network,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                network.ssid.isNotEmpty ? network.ssid : 'Rede Oculta',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              _buildDetailRow(context, 'BSSID', network.bssid),
              _buildDetailRow(context, 'Intensidade', '${network.signalStrength} dBm'),
              _buildDetailRow(context, 'Qualidade', network.signalQuality),
              _buildDetailRow(context, 'Segurança', network.security),
              _buildDetailRow(context, 'Frequência', '${network.frequency} MHz'),
              const SizedBox(height: 30),
              if (!network.isConnected)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showConnectDialog(context),
                    child: const Text('Conectar'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showConnectDialog(BuildContext context) {
    final passwordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Conectar a ${network.ssid}'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Senha',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final provider = Provider.of<WifiProvider>(context, listen: false);
              final success = await provider.connectToNetwork(
                network.ssid,
                passwordController.text,
              );
              
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success 
                          ? 'Conectado com sucesso!'
                          : 'Falha na conexão',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Conectar'),
          ),
        ],
      ),
    );
  }
}