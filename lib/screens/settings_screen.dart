// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../utils/responsive_utils.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.fromContext(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: Colors.purple.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.shade600,
              const Color(0xFFFFF8E1),
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final profile = userProvider.userProfile;

              return SingleChildScrollView(
                padding: ResponsiveUtils.getScreenPadding(deviceType),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sección de Perfil
                    _buildSectionTitle(
                        'Perfil de Usuario', Icons.person, deviceType),
                    const SizedBox(height: 12),
                    _buildProfileSection(
                        context, userProvider, profile, deviceType),

                    const SizedBox(height: 24),

                    // Sección de Audio
                    _buildSectionTitle('Audio', Icons.volume_up, deviceType),
                    const SizedBox(height: 12),
                    _buildAudioSection(
                        context, userProvider, profile, deviceType),

                    const SizedBox(height: 24),

                    // Sección de Notificaciones
                    _buildSectionTitle(
                        'Notificaciones', Icons.notifications, deviceType),
                    const SizedBox(height: 12),
                    _buildNotificationsSection(
                        context, userProvider, profile, deviceType),

                    const SizedBox(height: 24),

                    // Sección de Realidad Aumentada
                    _buildSectionTitle(
                        'Realidad Aumentada', Icons.camera_alt, deviceType),
                    const SizedBox(height: 12),
                    _buildARSection(context, userProvider, profile, deviceType),

                    const SizedBox(height: 24),

                    // Sección de Datos
                    _buildSectionTitle('Datos', Icons.storage, deviceType),
                    const SizedBox(height: 12),
                    _buildDataSection(context, deviceType),

                    const SizedBox(height: 24),

                    // Sección Acerca de
                    _buildSectionTitle('Acerca de', Icons.info, deviceType),
                    const SizedBox(height: 12),
                    _buildAboutSection(context, deviceType),

                    const SizedBox(height: 80),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
      String title, IconData icon, DeviceType deviceType) {
    final fontSize = ResponsiveUtils.getFontSize(deviceType, FontSize.heading);

    return Row(
      children: [
        Icon(icon, color: Colors.purple.shade700, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF5D4037),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(
    BuildContext context,
    UserProvider userProvider,
    dynamic profile,
    DeviceType deviceType,
  ) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.edit,
            title: 'Nombre de Usuario',
            subtitle: profile?.name ?? 'Explorador',
            onTap: () => _showEditNameDialog(context, userProvider),
            deviceType: deviceType,
          ),
          const Divider(height: 1),
          _buildSettingTile(
            icon: Icons.emoji_emotions,
            title: 'Avatar',
            subtitle: 'Personalizar avatar',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Próximamente! 🎨'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            deviceType: deviceType,
            showArrow: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSection(
    BuildContext context,
    UserProvider userProvider,
    dynamic profile,
    DeviceType deviceType,
  ) {
    final prefs = profile?.preferences;

    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.music_note,
            title: 'Música',
            subtitle: 'Música de fondo',
            value: prefs?.musicEnabled ?? true,
            onChanged: (value) {
              if (profile != null) {
                final newPrefs =
                    profile.preferences.copyWith(musicEnabled: value);
                final newProfile = profile.copyWith(preferences: newPrefs);
                userProvider.updateProfilePreferences(newProfile);
              }
            },
            deviceType: deviceType,
          ),
          const Divider(height: 1),
          _buildSwitchTile(
            icon: Icons.volume_up,
            title: 'Efectos de Sonido',
            subtitle: 'Sonidos de interacción',
            value: prefs?.soundEnabled ?? true,
            onChanged: (value) {
              if (profile != null) {
                final newPrefs =
                    profile.preferences.copyWith(soundEnabled: value);
                final newProfile = profile.copyWith(preferences: newPrefs);
                userProvider.updateProfilePreferences(newProfile);
              }
            },
            deviceType: deviceType,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(
    BuildContext context,
    UserProvider userProvider,
    dynamic profile,
    DeviceType deviceType,
  ) {
    final prefs = profile?.preferences;

    return Container(
      decoration: _cardDecoration(),
      child: _buildSwitchTile(
        icon: Icons.notifications_active,
        title: 'Notificaciones',
        subtitle: 'Recordatorios y actualizaciones',
        value: prefs?.notificationsEnabled ?? true,
        onChanged: (value) {
          if (profile != null) {
            final newPrefs =
                profile.preferences.copyWith(notificationsEnabled: value);
            final newProfile = profile.copyWith(preferences: newPrefs);
            userProvider.updateProfilePreferences(newProfile);
          }
        },
        deviceType: deviceType,
      ),
    );
  }

  Widget _buildARSection(
    BuildContext context,
    UserProvider userProvider,
    dynamic profile,
    DeviceType deviceType,
  ) {
    final prefs = profile?.preferences;

    return Container(
      decoration: _cardDecoration(),
      child: _buildSwitchTile(
        icon: Icons.camera_enhance,
        title: 'Modo AR',
        subtitle: 'Activar cámara para AR',
        value: prefs?.arEnabled ?? true,
        onChanged: (value) {
          if (profile != null) {
            final newPrefs = profile.preferences.copyWith(arEnabled: value);
            final newProfile = profile.copyWith(preferences: newPrefs);
            userProvider.updateProfilePreferences(newProfile);
          }
        },
        deviceType: deviceType,
      ),
    );
  }

  Widget _buildDataSection(BuildContext context, DeviceType deviceType) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.cloud_upload,
            title: 'Exportar Datos',
            subtitle: 'Guardar tu progreso',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exportando datos... 📦'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            deviceType: deviceType,
            showArrow: true,
          ),
          const Divider(height: 1),
          _buildSettingTile(
            icon: Icons.refresh,
            title: 'Restablecer Progreso',
            subtitle: 'Comenzar de nuevo',
            onTap: () => _showResetDialog(context),
            deviceType: deviceType,
            showArrow: true,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, DeviceType deviceType) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _buildSettingTile(
            icon: Icons.info_outline,
            title: 'Versión',
            subtitle: '1.0.0',
            onTap: () {},
            deviceType: deviceType,
          ),
          const Divider(height: 1),
          _buildSettingTile(
            icon: Icons.description,
            title: 'Términos y Condiciones',
            subtitle: 'Políticas de uso',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Abriendo términos... 📄'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            deviceType: deviceType,
            showArrow: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required DeviceType deviceType,
    bool showArrow = false,
    bool isDestructive = false,
  }) {
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withOpacity(0.1)
              : Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : Colors.purple.shade600,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: bodySize,
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : const Color(0xFF5D4037),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: captionSize,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: showArrow
          ? Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            )
          : null,
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required DeviceType deviceType,
  }) {
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final captionSize =
        ResponsiveUtils.getFontSize(deviceType, FontSize.caption);

    return SwitchListTile(
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.purple.shade600,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: bodySize,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF5D4037),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: captionSize,
          color: Colors.grey.shade600,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.purple.shade600,
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }

  void _showEditNameDialog(BuildContext context, UserProvider userProvider) {
    final controller =
        TextEditingController(text: userProvider.userProfile?.name ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.edit, color: Colors.purple.shade600),
            const SizedBox(width: 8),
            const Text('Editar Nombre'),
          ],
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Ingresa tu nombre',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.purple.shade600, width: 2),
            ),
            prefixIcon: const Icon(Icons.person),
          ),
          maxLength: 20,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                userProvider.updateProfileName(newName);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('¡Nombre actualizado a "$newName"! ✨'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red.shade600),
            const SizedBox(width: 8),
            const Text('¿Restablecer Progreso?'),
          ],
        ),
        content: const Text(
          'Esto eliminará todo tu progreso, puntos, estadísticas y mascotas. Esta acción no se puede deshacer.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              // TODO: Implementar reset completo llamando a todos los providers
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Función próximamente disponible 🚧'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Restablecer'),
          ),
        ],
      ),
    );
  }
}
