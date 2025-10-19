import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class MapStatsOverlay extends StatelessWidget {
  final int totalSites;
  final int visitedSites;
  final int filteredSites;
  final bool showFiltered;

  const MapStatsOverlay({
    super.key,
    required this.totalSites,
    required this.visitedSites,
    required this.filteredSites,
    required this.showFiltered,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.fromContext(context);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);
    final percentage = totalSites > 0
        ? ((visitedSites / totalSites) * 100).toStringAsFixed(0)
        : '0';

    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      padding: EdgeInsets.all(spacing.card * 1.2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Colors.grey.shade50,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing.card * 0.6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.place,
                  color: Colors.orange.shade700,
                  size: ResponsiveUtils.getIconSize(
                    deviceType,
                    IconSizeType.small,
                  ),
                ),
              ),
              SizedBox(width: spacing.card),
              Expanded(
                child: Text(
                  'Progreso',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getFontSize(
                      deviceType,
                      FontSize.body,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.subsection),

          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: visitedSites / totalSites,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.green.shade600,
              ),
              minHeight: 8,
            ),
          ),

          SizedBox(height: spacing.card),

          // Estadísticas
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat(
                'Visitados',
                '$visitedSites/$totalSites',
                Colors.green.shade700,
                deviceType,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.card,
                  vertical: spacing.card * 0.5,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getFontSize(
                      deviceType,
                      FontSize.body,
                    ),
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),

          if (showFiltered) ...[
            SizedBox(height: spacing.card),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.card,
                vertical: spacing.card * 0.6,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.blue.shade200,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_list,
                    size: ResponsiveUtils.getIconSize(
                      deviceType,
                      IconSizeType.small,
                    ),
                    color: Colors.blue.shade700,
                  ),
                  SizedBox(width: spacing.card * 0.5),
                  Text(
                    '$filteredSites lugares',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getFontSize(
                        deviceType,
                        FontSize.caption,
                      ),
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStat(
    String label,
    String value,
    Color color,
    DeviceType deviceType,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: ResponsiveUtils.getFontSize(
              deviceType,
              FontSize.caption,
            ),
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: ResponsiveUtils.getFontSize(
              deviceType,
              FontSize.body,
            ),
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
