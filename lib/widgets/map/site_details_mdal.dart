import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../utils/responsive_utils.dart';

class SiteDetailsModal extends StatelessWidget {
  final Map<String, dynamic> site;
  final VoidCallback onVisit;

  const SiteDetailsModal({
    super.key,
    required this.site,
    required this.onVisit,
  });

  // Obtiene el icono según la categoría
  IconData _getCategoryIcon() {
    final category = site['category'] as String?;
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

  // Obtiene el color según la categoría
  Color _getCategoryColor() {
    final category = site['category'] as String?;
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
    final provider = Provider.of<AppProvider>(context, listen: false);
    final isVisited = provider.visitedPlaces.contains(site['id']);
    final deviceType = ResponsiveUtils.fromContext(context);
    final spacing = ResponsiveUtils.getSpacing(deviceType);
    final cardPadding = ResponsiveUtils.getCardPadding(deviceType);
    final borderRadius = ResponsiveUtils.getBorderRadius(deviceType);
    final categoryColor = _getCategoryColor();

    return Container(
      padding: EdgeInsets.fromLTRB(
        cardPadding * 1.5,
        cardPadding,
        cardPadding * 1.5,
        MediaQuery.of(context).viewInsets.bottom + cardPadding * 1.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius * 1.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Indicador de arrastre
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: spacing.subsection),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Icono y categoría
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(spacing.card),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(borderRadius * 0.6),
                  border: Border.all(
                    color: categoryColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getCategoryIcon(),
                  color: categoryColor.shade700,
                  size: ResponsiveUtils.getIconSize(
                    deviceType,
                    IconSizeType.large,
                  ),
                ),
              ),
              SizedBox(width: spacing.subsection),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.card,
                        vertical: spacing.card * 0.5,
                      ),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: categoryColor.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        site['category'],
                        style: TextStyle(
                          fontSize: ResponsiveUtils.getFontSize(
                            deviceType,
                            FontSize.caption,
                          ),
                          fontWeight: FontWeight.bold,
                          color: categoryColor.shade700,
                        ),
                      ),
                    ),
                    SizedBox(height: spacing.card * 0.5),
                    Row(
                      children: [
                        Icon(
                          Icons.stars,
                          size: ResponsiveUtils.getIconSize(
                            deviceType,
                            IconSizeType.small,
                          ),
                          color: Colors.amber.shade700,
                        ),
                        SizedBox(width: spacing.card * 0.3),
                        Text(
                          '+${site['reward']} puntos',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getFontSize(
                              deviceType,
                              FontSize.caption,
                            ),
                            color: Colors.amber.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.section),

          // Nombre del lugar
          Text(
            site['name'],
            style: TextStyle(
              fontSize: ResponsiveUtils.getFontSize(
                deviceType,
                FontSize.heading,
              ),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF5D4037),
            ),
          ),

          SizedBox(height: spacing.subsection),

          // Descripción
          Container(
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(borderRadius * 0.6),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
            ),
            child: Text(
              site['description'],
              style: TextStyle(
                fontSize: ResponsiveUtils.getFontSize(
                  deviceType,
                  FontSize.body,
                ),
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: spacing.section),

          // Botón o mensaje de estado
          if (!isVisited)
            ElevatedButton.icon(
              icon: Icon(
                Icons.check_circle_outline,
                size: ResponsiveUtils.getIconSize(
                  deviceType,
                  IconSizeType.medium,
                ),
              ),
              label: Text(
                'Marcar como Visitado (+${site['reward']} Puntos)',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getFontSize(
                    deviceType,
                    FontSize.body,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: cardPadding * 1.2,
                ),
                backgroundColor: categoryColor.shade600,
                foregroundColor: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius * 0.6),
                ),
              ),
              onPressed: () {
                provider.addPoints(site['reward']);
                provider.visitPlace(site['id']);
                Navigator.pop(context);
                onVisit();
              },
            )
          else
            Container(
              padding: EdgeInsets.all(cardPadding),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade50,
                    Colors.green.shade100,
                  ],
                ),
                borderRadius: BorderRadius.circular(borderRadius * 0.6),
                border: Border.all(
                  color: Colors.green.shade300,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green.shade700,
                    size: ResponsiveUtils.getIconSize(
                      deviceType,
                      IconSizeType.medium,
                    ),
                  ),
                  SizedBox(width: spacing.card),
                  Text(
                    '¡Ya has visitado este lugar!',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.getFontSize(
                        deviceType,
                        FontSize.body,
                      ),
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

extension on Color {
  Color get shade600 => this.withOpacity(0.6);

  Color get shade700 => this.withOpacity(0.7);
}
