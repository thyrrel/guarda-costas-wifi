import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _autoScan = true;
  bool _notifications = true;
  double _scanInterval = 30.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _autoScan = prefs.getBool('auto_scan') ?? true;
      _notifications = prefs.getBool('notifications') ?? true;
      _scanInterval = prefs.getDouble('scan_interval') ?? 30.0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_scan', _autoScan);
    await prefs.setBool('notifications', _notifications);
    await prefs.setDouble('scan_interval', _scanInterval);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Column(
            children: [
              ListTile(
                title: const Text('Escaneamento Automático'),
                subtitle: const Text('Escanear redes automaticamente'),
                trailing: Switch(
                  value: _autoScan,
                  onChanged: (value) {
                    setState(() => _autoScan = value);
                    _saveSettings();
                  },
                ),
              ),
              ListTile(
                title: const Text('Notificações'),
                subtitle: const Text('Receber alertas sobre redes suspeitas'),
                trailing: Switch(
                  value: _notifications,
                  onChanged: (value) {
                    setState(() => _notifications = value);
                    _saveSettings();
                  },
                ),
              ),
              ListTile(
                title: const Text('Intervalo de Escaneamento'),
                subtitle: Text('${_scanInterval.toInt()} segundos'),
                trailing: SizedBox(
                  width: 100,
                  child: Slider(
                    value: _scanInterval,
                    min: 10,
                    max: 300,
                    divisions: 29,
                    onChanged: (value) {
                      setState(() => _scanInterval = value);
                      _saveSettings();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Sobre'),
                onTap: () => _showAboutDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Ajuda'),
                onTap: () => _showHelpDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: const Text('Política de Privacidade'),
                onTap: () => _showPrivacyDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Guarda-Costas WiFi',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.wifi_protected_setup, size: 48),
      children: const [
        Text('Aplicativo para monitoramento e análise de redes WiFi para operações de segurança costeira.'),
      ],
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajuda'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Como usar o Guarda-Costas WiFi:\n\n'
                '1. Scanner: Utilize a aba Scanner para encontrar redes WiFi próximas\n\n'
                '2. Monitor: Ative o monitoramento automático para detectar atividades suspeitas\n\n'
                '3. Configurações: Ajuste as preferências do aplicativo\n\n'
                '4. Localização: Mantenha o GPS ativado para melhor precisão',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidade'),
        content: const SingleChildScrollView(
          child: Text(
            'Este aplicativo coleta dados de localização e informações sobre redes WiFi apenas para fins de monitoramento de segurança. '
            'Nenhum dado pessoal é compartilhado com terceiros. '
            'As informações são armazenadas localmente no dispositivo.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }
}