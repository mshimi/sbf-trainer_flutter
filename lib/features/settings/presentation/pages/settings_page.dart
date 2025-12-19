import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.white,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    if (state.status == SettingsStatus.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMasterySection(context, state),
                          const SizedBox(height: 24),
                          _buildDangerZone(context, state),
                          const SizedBox(height: 24),
                          _buildAboutSection(context),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade900,
            Colors.blue.shade700,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.settings_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Einstellungen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'App-Einstellungen anpassen',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterySection(BuildContext context, SettingsState state) {
    return _SettingsCard(
      title: 'Lernfortschritt',
      icon: Icons.school_rounded,
      iconColor: Colors.green,
      children: [
        const Text(
          'Meisterschaftsschwelle',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Anzahl der korrekten Antworten, um eine Frage als gemeistert zu markieren.',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Colors.green.shade400,
                  inactiveTrackColor: Colors.grey.shade200,
                  thumbColor: Colors.green.shade600,
                  overlayColor: Colors.green.shade100.withValues(alpha: 0.3),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: state.masteryThreshold.toDouble(),
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: state.status == SettingsStatus.saving
                      ? null
                      : (value) {
                          context
                              .read<SettingsCubit>()
                              .setMasteryThreshold(value.round());
                        },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${state.masteryThreshold}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 (Leicht)',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
            Text(
              '10 (Schwer)',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDangerZone(BuildContext context, SettingsState state) {
    return _SettingsCard(
      title: 'Gefahrenzone',
      icon: Icons.warning_rounded,
      iconColor: Colors.red,
      children: [
        _DangerButton(
          icon: Icons.refresh_rounded,
          title: 'Fortschritt zurücksetzen',
          description: 'Setzt alle Quiz-Ergebnisse und Fragen-Rankings zurück.',
          buttonText: 'Fortschritt löschen',
          buttonColor: Colors.orange,
          isLoading: state.status == SettingsStatus.saving,
          onPressed: () => _showResetProgressDialog(context),
        ),
        const SizedBox(height: 16),
        const Divider(),
        const SizedBox(height: 16),
        _DangerButton(
          icon: Icons.delete_forever_rounded,
          title: 'App vollständig zurücksetzen',
          description:
              'Löscht alle Daten und initialisiert die App neu. Diese Aktion kann nicht rückgängig gemacht werden!',
          buttonText: 'App zurücksetzen',
          buttonColor: Colors.red,
          isLoading: state.status == SettingsStatus.saving,
          onPressed: () => _showResetAppDialog(context),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return _SettingsCard(
      title: 'Über die App',
      icon: Icons.info_outline_rounded,
      iconColor: Colors.blue,
      children: [
        _AboutItem(
          icon: Icons.sailing_rounded,
          title: 'SBF Trainer',
          subtitle: 'Sportbootführerschein Binnen',
        ),
        const SizedBox(height: 12),
        _AboutItem(
          icon: Icons.code_rounded,
          title: 'Version',
          subtitle: '1.0.0',
        ),
        const SizedBox(height: 12),
        _AboutItem(
          icon: Icons.quiz_rounded,
          title: 'Fragenkatalog',
          subtitle: '300 offizielle Prüfungsfragen',
        ),
      ],
    );
  }

  Future<void> _showResetProgressDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.orange.shade600),
            const SizedBox(width: 12),
            const Text('Fortschritt zurücksetzen?'),
          ],
        ),
        content: const Text(
          'Alle Quiz-Ergebnisse und Fragen-Rankings werden gelöscht. '
          'Die Fragen bleiben erhalten.\n\n'
          'Diese Aktion kann nicht rückgängig gemacht werden!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Zurücksetzen'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<SettingsCubit>().resetProgress();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Fortschritt wurde zurückgesetzt'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  Future<void> _showResetAppDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.delete_forever_rounded, color: Colors.red.shade600),
            const SizedBox(width: 12),
            const Text('App zurücksetzen?'),
          ],
        ),
        content: const Text(
          'ACHTUNG: Alle Daten werden unwiderruflich gelöscht!\n\n'
          '• Alle Quiz-Ergebnisse\n'
          '• Alle Fragen-Rankings\n'
          '• Alle Einstellungen\n\n'
          'Die App wird anschließend neu initialisiert.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Alles löschen'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<SettingsCubit>().resetApp();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('App wurde zurückgesetzt'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
        // Navigate back to home
        context.go(Routes.home);
      }
    }
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const _SettingsCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final Color buttonColor;
  final bool isLoading;
  final VoidCallback onPressed;

  const _DangerButton({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.buttonColor,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: buttonColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    buttonText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }
}

class _AboutItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AboutItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade400, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
