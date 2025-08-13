# Guarda-Costas WiFi

Um aplicativo Flutter para monitoramento e análise de redes WiFi destinado a operações de segurança costeira.

## Características

- **Scanner de WiFi**: Detecta e analisa redes WiFi próximas
- **Monitoramento Automático**: Sistema de monitoramento contínuo para detectar atividades suspeitas
- **Geolocalização**: Integração com GPS para localização precisa
- **Notificações**: Alertas automáticos sobre atividades suspeitas
- **Interface Intuitiva**: Design moderno e fácil de usar

## Funcionalidades

### 🔍 Scanner de Redes
- Detecção automática de redes WiFi
- Análise de intensidade de sinal
- Informações detalhadas sobre cada rede
- Capacidade de conexão a redes

### 📊 Monitoramento
- Monitoramento contínuo em segundo plano
- Detecção de redes suspeitas
- Histórico de atividades
- Relatórios de segurança

### 📍 Localização
- Integração com GPS
- Mapeamento de redes por localização
- Histórico de localizações

### ⚙️ Configurações
- Personalização do intervalo de escaneamento
- Controle de notificações
- Configurações de privacidade

## Instalação

### Pré-requisitos
- Flutter SDK (>=3.10.0)
- Dart SDK (>=3.0.0)
- Android Studio ou Xcode
- Dispositivo Android 6.0+ ou iOS 12.0+

### Passos de Instalação

1. Clone o repositório:
```bash
git clone https://github.com/thyrrel/guarda-costas-wifi.git
cd guarda-costas-wifi
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute os geradores de código:
```bash
dart run build_runner build
```

4. Execute o aplicativo:
```bash
flutter run
```

## Permissões

O aplicativo requer as seguintes permissões:

### Android
- `ACCESS_WIFI_STATE` - Para acessar informações sobre WiFi
- `CHANGE_WIFI_STATE` - Para conectar/desconectar redes
- `ACCESS_FINE_LOCATION` - Para localização precisa
- `ACCESS_COARSE_LOCATION` - Para localização aproximada
- `NEARBY_WIFI_DEVICES` - Para detectar dispositivos WiFi próximos

### iOS
- Localização quando em uso
- Acesso a WiFi

## Arquitetura

O projeto segue uma arquitetura em camadas:

```
lib/
├── core/                 # Funcionalidades centrais
│   ├── models/          # Modelos de dados
│   ├── providers/       # Gerenciamento de estado
│   ├── services/        # Serviços da aplicação
│   └── utils/           # Utilitários
├── features/            # Módulos de funcionalidades
│   ├── home/           # Tela inicial
│   ├── wifi_scanner/   # Scanner de WiFi
│   ├── monitoring/     # Sistema de monitoramento
│   └── settings/       # Configurações
```

## Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento
- **Provider**: Gerenciamento de estado
- **WiFi IoT**: Acesso a funcionalidades WiFi
- **Geolocator**: Serviços de localização
- **SQFlite**: Banco de dados local
- **Workmanager**: Tarefas em segundo plano

## Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## Contato

Projeto criado para fins de segurança costeira.

## Avisos Legais

Este aplicativo é destinado exclusivamente para uso em operações de segurança autorizadas. O uso indevido para interceptação não autorizada de comunicações pode violar leis locais e federais.