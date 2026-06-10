import 'package:flutter/material.dart';

// IMPORT PROVIDERS
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/user_provider.dart';

// IMPORT SCREENS
import '../../screens/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _urlController = TextEditingController();
  late SettingsProvider settingsProvider;
  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    _urlController.text = settingsProvider.getServerUrl;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Impostazioni',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildThemeSection(),

            const SizedBox(height: 12),
            const Divider(),

            Expanded(child: _buildServerSection()),

            Expanded(flex: 0, child: _buildColorSection()),

            const Divider(),

            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection() {
    return Column(
      children: [
        const Text(
          'Colore Principale',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),

        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: appColors.length,
            itemBuilder: (context, index) {
              return _buildColorCircle(appColors[index], settingsProvider);
            },
          ),
        ),
      ],
    );
  }

  final List<Color> appColors = [
    Colors.indigo,
    Colors.blue,
    Colors.teal,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.pink,
    Colors.purple,
  ];

  Widget _buildColorCircle(Color color, SettingsProvider provider) {
    final isSelected = provider.getSeedColor == color;

    return GestureDetector(
      onTap: () => provider.setSeedColor(color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: color,
          radius: 18,
          child: isSelected
              ? const Icon(Icons.check, color: Colors.white, size: 20)
              : null,
        ),
      ),
    );
  }

  Widget _buildThemeSection() {
    return Column(
      children: [
        const Text(
          'Tema',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Center(
          child: SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                icon: Icon(Icons.brightness_auto),
                label: Text('Sistema'),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                icon: Icon(Icons.light_mode),
                label: Text('Chiaro'),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                icon: Icon(Icons.dark_mode),
                label: Text('Scuro'),
              ),
            ],
            selected: {settingsProvider.getThemeMode},
            onSelectionChanged: (newSelection) {
              settingsProvider.setThemeMode(newSelection.first);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServerSection() {
    return Column(
      children: [
        const Text(
          'Configurazione Server',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _urlController,
          decoration: InputDecoration(
            labelText: 'Indirizzo Server',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            suffixIcon: IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                settingsProvider.setServerUrl(_urlController.text);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        await userProvider.logout();

        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      },
      icon: const Icon(Icons.logout),
      label: const Text('Logout'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade100,
        foregroundColor: Colors.red.shade900,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
