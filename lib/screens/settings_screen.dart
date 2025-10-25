import 'package:flutter/material.dart';
import 'package:gym_fitness_app/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_fitness_app/screens/login_screen.dart'; // Assuming this exists

// Placeholder screens for navigation
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(child: Text('Edit Profile Page')),
    );
  }
}

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Settings')),
      body: const Center(child: Text('Privacy Settings Page')),
    );
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: const Center(child: Text('Help & Support Page')),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _autoPlayVideos = true;
  bool _progressUpdates = true;
  bool _backupData = true;
  bool _downloadOffline = false;
  String _selectedLanguage = 'English'; // New field
  double _fontSizeScale = 1.0; // Retained for consistency, but not used in UI

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notifications = prefs.getBool('notifications') ?? true;
      _darkMode = prefs.getBool('darkMode') ?? false;
      _autoPlayVideos = prefs.getBool('autoPlayVideos') ?? true;
      _progressUpdates = prefs.getBool('progressUpdates') ?? true;
      _backupData = prefs.getBool('backupData') ?? true;
      _downloadOffline = prefs.getBool('downloadOffline') ?? false;
      _selectedLanguage =
          prefs.getString('selectedLanguage') ?? 'English'; // Load language
      _fontSizeScale =
          prefs.getDouble('fontSizeScale') ?? 1.0; // Load font scale
      _fontSizeScale = _fontSizeScale.clamp(0.8, 1.5); // Clamp font scale
    });
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  void _toggleDarkMode(bool value) {
    setState(() {
      _darkMode = value;
    });
    _savePreference('darkMode', value);
    // In a real app, this would trigger a theme change via Provider or similar
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _darkMode ? ThemeData.dark() : ThemeData.light();
    final textTheme = theme.textTheme.apply(
      bodyColor: _darkMode ? Colors.white70 : Colors.black87,
      displayColor: _darkMode ? Colors.white : Colors.black,
    ); // Removed fontSizeFactor

    return Theme(
      data: theme.copyWith(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: _darkMode ? Brightness.dark : Brightness.light,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: _darkMode ? Colors.grey[800] : Colors.white,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.all(Colors.white),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.blue[300];
            }
            return Colors.grey;
          }),
        ),
        textTheme: textTheme,
        iconTheme: IconThemeData(color: Colors.blue[300]),
      ),
      child: Scaffold(
        backgroundColor: _darkMode ? Colors.grey[900] : Colors.white,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4CAF50), // Green
                  Color(0xFF2196F3), // Blue
                ],
              ),
            ),
          ),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: _darkMode ? Colors.white70 : Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Settings',
            style: TextStyle(
              color: _darkMode ? Colors.white : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Section
              _buildSectionTile(
                title: 'Account',
                children: [
                  _buildNavTile('Edit Profile', Icons.person, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  }),
                  _buildNavTile('Privacy Settings', Icons.security, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacySettingsScreen()),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),
              // Notifications Section
              _buildSectionTile(
                title: 'Notifications',
                children: [
                  _buildSwitchTile(
                    'Workout Reminders',
                    Icons.notifications,
                    _notifications,
                    (val) {
                      setState(() => _notifications = val);
                      _savePreference('notifications', val);
                    },
                  ),
                  _buildSwitchTile(
                    'Progress Updates',
                    Icons.trending_up,
                    _progressUpdates,
                    (val) {
                      setState(() => _progressUpdates = val);
                      _savePreference('progressUpdates', val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Appearance Section
              _buildSectionTile(
                title: 'Appearance',
                children: [
                  _buildSwitchTile(
                    'Dark Mode',
                    Icons.dark_mode,
                    _darkMode,
                    _toggleDarkMode,
                  ),
                  _buildSwitchTile(
                    'Auto-Play Videos',
                    Icons.play_circle,
                    _autoPlayVideos,
                    (val) {
                      setState(() => _autoPlayVideos = val);
                      _savePreference('autoPlayVideos', val);
                    },
                  ),
                  _buildDropdownTile(
                    'Language',
                    Icons.language,
                    _selectedLanguage,
                    const ['English', 'Spanish', 'French', 'German'],
                    (val) {
                      if (val != null) {
                        setState(() => _selectedLanguage = val);
                        _savePreference('selectedLanguage', val);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Data & Storage Section
              _buildSectionTile(
                title: 'Data & Storage',
                children: [
                  _buildSwitchTile(
                    'Backup Data',
                    Icons.cloud,
                    _backupData,
                    (val) {
                      setState(() => _backupData = val);
                      _savePreference('backupData', val);
                    },
                  ),
                  _buildSwitchTile(
                    'Download Offline Workouts',
                    Icons.download,
                    _downloadOffline,
                    (val) {
                      setState(() => _downloadOffline = val);
                      _savePreference('downloadOffline', val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // About Section
              _buildSectionTile(
                title: 'About',
                children: [
                  _buildListTile(
                    title: 'App Version',
                    subtitle: '1.2.3',
                    icon: Icons.info,
                  ),
                  _buildNavTile(
                    'Help & Support',
                    Icons.help,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HelpSupportScreen()),
                      );
                    },
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Logout Button
              Center(
                child: ElevatedButton(
                  onPressed: _showLogoutConfirmation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTile({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: children,
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      secondary: Icon(icon),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue[300],
    );
  }

  Widget _buildDropdownTile(
    String title,
    IconData icon,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      leading: Icon(icon),
      trailing: DropdownButton<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
      ),
    );
  }

  /*Widget _buildSliderTile(
    String title,
    IconData icon,
    double value,
    Function(double) onChanged,
  ) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      leading: Icon(icon),
      subtitle: Slider(
        value: value,
        min: 0.8,
        max: 1.5,
        divisions: 7,
        label: value.toStringAsFixed(1),
        onChanged: (newValue) {
          onChanged(newValue);
        },
      ),
    );
  }*/

  Widget _buildListTile({
    required String title,
    String? subtitle,
    required IconData icon,
    Widget? trailing,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(color: Colors.grey),
            )
          : null,
      leading: Icon(icon),
      trailing: trailing,
    );
  }

  Widget _buildNavTile(
    String title,
    IconData icon,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 16),
      ),
      leading: Icon(icon),
      trailing: trailing ?? const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
