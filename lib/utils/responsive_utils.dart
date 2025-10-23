// lib/utils/responsive_utils.dart
import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  tablet,
  desktop,
}

class ResponsiveSpacing {
  final double section;
  final double subsection;
  final double card;

  const ResponsiveSpacing({
    required this.section,
    required this.subsection,
    required this.card,
  });
}

class ResponsiveUtils {
  static DeviceType getDeviceType(double width) {
    if (width < 600) {
      return DeviceType.mobile;
    } else if (width < 900) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  static double getMaxContentWidth(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return double.infinity;
      case DeviceType.tablet:
        return 800.0;
      case DeviceType.desktop:
        return 1200.0;
    }
  }

  static EdgeInsets getScreenPadding(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.all(20.0);
      case DeviceType.tablet:
        return const EdgeInsets.symmetric(horizontal: 32.0, vertical: 28.0);
      case DeviceType.desktop:
        return const EdgeInsets.symmetric(horizontal: 40.0, vertical: 32.0);
    }
  }

  static ResponsiveSpacing getSpacing(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return const ResponsiveSpacing(
          section: 25.0,
          subsection: 15.0,
          card: 12.0,
        );
      case DeviceType.tablet:
        return const ResponsiveSpacing(
          section: 35.0,
          subsection: 20.0,
          card: 16.0,
        );
      case DeviceType.desktop:
        return const ResponsiveSpacing(
          section: 40.0,
          subsection: 25.0,
          card: 20.0,
        );
    }
  }

  static double getFontSize(DeviceType deviceType, FontSize size) {
    switch (size) {
      case FontSize.title:
        return deviceType == DeviceType.desktop
            ? 32.0
            : (deviceType == DeviceType.tablet ? 28.0 : 26.0);
      case FontSize.subtitle:
        return deviceType == DeviceType.desktop
            ? 17.0
            : (deviceType == DeviceType.tablet ? 16.0 : 15.0);
      case FontSize.heading:
        return deviceType == DeviceType.desktop
            ? 24.0
            : (deviceType == DeviceType.tablet ? 22.0 : 20.0);
      case FontSize.body:
        return deviceType == DeviceType.desktop
            ? 16.0
            : (deviceType == DeviceType.tablet ? 15.0 : 14.0);
      case FontSize.caption:
        return deviceType == DeviceType.desktop
            ? 13.0
            : (deviceType == DeviceType.tablet ? 12.0 : 11.0);
    }
  }

  static double getIconSize(DeviceType deviceType, IconSizeType type) {
    switch (type) {
      case IconSizeType.small:
        return deviceType == DeviceType.desktop
            ? 20.0
            : (deviceType == DeviceType.tablet ? 18.0 : 16.0);
      case IconSizeType.medium:
        return deviceType == DeviceType.desktop
            ? 24.0
            : (deviceType == DeviceType.tablet ? 22.0 : 20.0);
      case IconSizeType.large:
        return deviceType == DeviceType.desktop
            ? 42.0
            : (deviceType == DeviceType.tablet ? 38.0 : 35.0);
    }
  }

  static double getCardPadding(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 16.0;
      case DeviceType.tablet:
        return 20.0;
      case DeviceType.desktop:
        return 22.0;
    }
  }

  static int getGridColumns(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 2;
      case DeviceType.tablet:
        return 3;
      case DeviceType.desktop:
        return 4;
    }
  }

  static double getBorderRadius(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 16.0;
      case DeviceType.tablet:
        return 20.0;
      case DeviceType.desktop:
        return 24.0;
    }
  }

  static DeviceType fromContext(BuildContext context) {
    return getDeviceType(MediaQuery.of(context).size.width);
  }
}

enum FontSize {
  title,
  subtitle,
  heading,
  body,
  caption,
}

enum IconSizeType {
  small,
  medium,
  large,
}
