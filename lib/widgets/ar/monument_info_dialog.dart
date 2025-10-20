import 'package:flutter/material.dart';
import '../../models/monument_model.dart';
import '../../utils/responsive_utils.dart';

void showMonumentInfoDialog({
  required BuildContext context,
  required MonumentModel monument,
  required VoidCallback onClaim,
}) {
  final screenWidth = MediaQuery.of(context).size.width;
  final deviceType = ResponsiveUtils.getDeviceType(screenWidth);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _MonumentInfoDialog(
      monument: monument,
      deviceType: deviceType,
      onClaim: onClaim,
    ),
  );
}

class _MonumentInfoDialog extends StatelessWidget {
  final MonumentModel monument;
  final DeviceType deviceType;
  final VoidCallback onClaim;

  const _MonumentInfoDialog({
    required this.monument,
    required this.deviceType,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final titleSize = ResponsiveUtils.getFontSize(deviceType, FontSize.heading);
    final bodySize = ResponsiveUtils.getFontSize(deviceType, FontSize.body);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final maxWidth = ResponsiveUtils.getMaxContentWidth(deviceType);

    return Container(
      padding: EdgeInsets.all(cardPadding),
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: deviceType == DeviceType.desktop
          ? const EdgeInsets.symmetric(horizontal: 40)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            SizedBox(height: spacing.subsection),

            // Icon
            Container(
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    monument.color.withOpacity(0.2),
                    monument.color.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: monument.color.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                monument.icon,
                size: deviceType == DeviceType.mobile ? 50 : 60,
                color: monument.color,
              ),
            ),
            SizedBox(height: spacing.subsection),

            // Title
            Text(
              monument.name,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF5D4037),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.card),

            // Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: cardPadding),
              child: Text(
                monument.description,
                style: TextStyle(
                  fontSize: bodySize,
                  color: const Color(0xFF8D6E63),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: spacing.subsection),

            // Points badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: cardPadding,
                vertical: spacing.card,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD54F), Color(0xFFFFB74D)],
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '+${monument.points} puntos',
                    style: TextStyle(
                      fontSize: bodySize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.subsection),

            // Action buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: cardPadding),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: deviceType == DeviceType.mobile ? 14 : 16,
                        ),
                        side: BorderSide(color: monument.color, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cerrar',
                        style: TextStyle(
                          color: monument.color,
                          fontWeight: FontWeight.bold,
                          fontSize: bodySize,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        onClaim();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '¡Has ganado ${monument.points} puntos!',
                              style: TextStyle(fontSize: bodySize),
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: monument.color,
                        padding: EdgeInsets.symmetric(
                          vertical: deviceType == DeviceType.mobile ? 14 : 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        'Reclamar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: bodySize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 10),
          ],
        ),
      ),
    );
  }
}
