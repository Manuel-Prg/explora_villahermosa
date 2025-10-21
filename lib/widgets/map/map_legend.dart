import 'package:explora_villahermosa/data/tourist_sites_data.dart';
import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

class MapLegend extends StatelessWidget {
  final String? selectedCategory;
  final Function(String?) onCategorySelected;
  final VoidCallback onClose;

  const MapLegend({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onClose,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Museo':
        return Icons.museum;
      case 'Parque':
        return Icons.park;
      case 'Religioso':
        return Icons.church;
      case 'Gobierno':
        return Icons.account_balance;
      case 'Cultura':
        return Icons.library_books;
      case 'Plaza':
        return Icons.location_city;
      case 'Educación':
        return Icons.school;
      case 'Histórico':
        return Icons.history_edu;
      case 'Entretenimiento':
        return Icons.theaters;
      case 'Hospedaje':
        return Icons.hotel;
      case 'Financiero':
        return Icons.account_balance;
      default:
        return Icons.place;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Museo':
        return Colors.purple;
      case 'Parque':
        return Colors.lightGreen;
      case 'Religioso':
        return Colors.indigo;
      case 'Gobierno':
        return Colors.blue;
      case 'Cultura':
        return Colors.orange;
      case 'Plaza':
        return Colors.teal;
      case 'Educación':
        return Colors.amber;
      case 'Histórico':
        return Colors.brown;
      case 'Entretenimiento':
        return Colors.pink;
      case 'Hospedaje':
        return Colors.cyan;
      case 'Financiero':
        return Colors.blueGrey;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceType = ResponsiveUtils.fromContext(context);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);
    final categories = TouristSitesData.getCategories();

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(spacing.subsection),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade400,
                    Colors.orange.shade600,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: ResponsiveUtils.getIconSize(
                      deviceType,
                      IconSizeType.medium,
                    ),
                  ),
                  SizedBox(width: spacing.card),
                  Expanded(
                    child: Text(
                      'Filtrar por Categoría',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getFontSize(
                          deviceType,
                          FontSize.body,
                        ),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: onClose,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(spacing.subsection),
                children: [
                  _buildCategoryTile(
                    context: context,
                    category: null,
                    label: 'Todos los lugares',
                    icon: Icons.place,
                    color: Colors.grey.shade700,
                    count: TouristSitesData.sites.length,
                    isSelected: selectedCategory == null,
                    deviceType: deviceType,
                    spacing: spacing,
                    borderRadius: borderRadius,
                  ),
                  SizedBox(height: spacing.card),
                  ...categories.map((category) {
                    final sitesCount =
                        TouristSitesData.getSitesByCategory(category).length;
                    return Padding(
                      padding: EdgeInsets.only(bottom: spacing.card),
                      child: _buildCategoryTile(
                        context: context,
                        category: category,
                        label: category,
                        icon: _getCategoryIcon(category),
                        color: _getCategoryColor(category),
                        count: sitesCount,
                        isSelected: selectedCategory == category,
                        deviceType: deviceType,
                        spacing: spacing,
                        borderRadius: borderRadius,
                      ),
                    );
                  }),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(spacing.subsection),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Leyenda',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getFontSize(
                        deviceType,
                        FontSize.caption,
                      ),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: spacing.card),
                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: Colors.red.shade700,
                        size: ResponsiveUtils.getIconSize(
                          deviceType,
                          IconSizeType.small,
                        ),
                      ),
                      SizedBox(width: spacing.card * 0.5),
                      Text(
                        'No visitado',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getFontSize(
                            deviceType,
                            FontSize.caption,
                          ),
                        ),
                      ),
                      SizedBox(width: spacing.subsection),
                      Icon(
                        Icons.location_pin,
                        color: Colors.green.shade700,
                        size: ResponsiveUtils.getIconSize(
                          deviceType,
                          IconSizeType.small,
                        ),
                      ),
                      SizedBox(width: spacing.card * 0.5),
                      Text(
                        'Visitado',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getFontSize(
                            deviceType,
                            FontSize.caption,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile({
    required BuildContext context,
    required String? category,
    required String label,
    required IconData icon,
    required Color color,
    required int count,
    required bool isSelected,
    required DeviceType deviceType,
    required ResponsiveSpacing spacing,
    required double borderRadius,
  }) {
    return Material(
      color: isSelected ? color.withOpacity(0.1) : Colors.white,
      borderRadius: BorderRadius.circular(borderRadius * 0.6),
      child: InkWell(
        onTap: () => onCategorySelected(category),
        borderRadius: BorderRadius.circular(borderRadius * 0.6),
        child: Container(
          padding: EdgeInsets.all(spacing.card),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius * 0.6),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing.card * 0.7),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color.shade700,
                  size: ResponsiveUtils.getIconSize(
                    deviceType,
                    IconSizeType.small,
                  ),
                ),
              ),
              SizedBox(width: spacing.card),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getFontSize(
                      deviceType,
                      FontSize.body,
                    ),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? color.shade700 : Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.card,
                  vertical: spacing.card * 0.4,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getFontSize(
                      deviceType,
                      FontSize.caption,
                    ),
                    fontWeight: FontWeight.bold,
                    color: color.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on Color {
  get shade700 => null;
}
