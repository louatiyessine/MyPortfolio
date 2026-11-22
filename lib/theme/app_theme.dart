import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Construit le thème Material 3 de l'application à partir d'une couleur
/// d'accent.
///
/// Le même code sert pour l'accueil (accent Safran) et pour chaque
/// portfolio (accent de l'étudiant) : boutons, onglets, champs et
/// indicateurs de chargement changent de couleur automatiquement.
class AppTheme {
  AppTheme._();

  static const String displayFont = 'Fraunces';
  static const String bodyFont = 'Manrope';
  static const String monoFont = 'JetBrainsMono';

  static const double radius = 20;

  static ThemeData build(Color accent) {
    final scheme = ColorScheme.dark(
      primary: accent,
      onPrimary: AppColors.ink,
      secondary: accent,
      onSecondary: AppColors.ink,
      surface: AppColors.ink,
      onSurface: AppColors.parchment,
      surfaceContainerHighest: AppColors.dusk,
      onSurfaceVariant: AppColors.sand,
      outline: AppColors.line,
      error: AppColors.danger,
      onError: AppColors.ink,
    );

    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.ink,
      fontFamily: bodyFont,
      textTheme: _textTheme,
      appBarTheme: const AppBarThemeData(
        backgroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.parchment,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: displayFont,
          fontWeight: FontWeight.w600,
          fontSize: 22,
          color: AppColors.parchment,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.dusk,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius + 4),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: AppColors.night,
        labelStyle: const TextStyle(color: AppColors.sand),
        floatingLabelStyle: TextStyle(color: accent),
        hintStyle: const TextStyle(color: AppColors.mist),
        prefixIconColor: AppColors.mist,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: _inputBorder(AppColors.line),
        enabledBorder: _inputBorder(AppColors.line),
        focusedBorder: _inputBorder(accent, width: 1.6),
        errorBorder: _inputBorder(AppColors.danger),
        focusedErrorBorder: _inputBorder(AppColors.danger, width: 1.6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: AppColors.ink,
          minimumSize: const Size.fromHeight(54),
          shape: shape,
          textStyle: const TextStyle(
            fontFamily: bodyFont,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          textStyle: const TextStyle(
            fontFamily: bodyFont,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: AppColors.ink,
        elevation: 2,
        shape: shape,
        extendedTextStyle: const TextStyle(
          fontFamily: bodyFont,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        indicator: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(999),
        ),
        labelColor: AppColors.ink,
        unselectedLabelColor: AppColors.sand,
        labelStyle: const TextStyle(
          fontFamily: bodyFont,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
        splashFactory: NoSplash.splashFactory,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.parchment,
        contentTextStyle: const TextStyle(
          fontFamily: bodyFont,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
        actionTextColor: AppColors.ink,
        shape: shape,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.night,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        titleTextStyle: _textTheme.titleLarge,
        contentTextStyle: _textTheme.bodyMedium,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.night,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: AppColors.line,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: accent),
      dividerTheme: const DividerThemeData(color: AppColors.line, space: 1),
      listTileTheme: const ListTileThemeData(iconColor: AppColors.sand),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.ink
              : AppColors.sand,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? accent
              : AppColors.night,
        ),
      ),
    );
  }

  /// Bordure arrondie des champs de formulaire (une seule définition).
  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color, width: width),
      );

  /// Hiérarchie typographique : Fraunces pour les titres, Manrope pour le
  /// texte, JetBrains Mono pour les petites étiquettes techniques.
  static const TextTheme _textTheme = TextTheme(
    displaySmall: TextStyle(
      fontFamily: displayFont,
      fontWeight: FontWeight.w700,
      fontSize: 48,
      height: 1.0,
      letterSpacing: -1.2,
      color: AppColors.parchment,
    ),
    headlineSmall: TextStyle(
      fontFamily: displayFont,
      fontWeight: FontWeight.w600,
      fontSize: 26,
      height: 1.15,
      letterSpacing: -0.4,
      color: AppColors.parchment,
    ),
    titleLarge: TextStyle(
      fontFamily: displayFont,
      fontWeight: FontWeight.w600,
      fontSize: 21,
      height: 1.2,
      color: AppColors.parchment,
    ),
    titleMedium: TextStyle(
      fontFamily: bodyFont,
      fontWeight: FontWeight.w700,
      fontSize: 16,
      color: AppColors.parchment,
    ),
    titleSmall: TextStyle(
      fontFamily: bodyFont,
      fontWeight: FontWeight.w700,
      fontSize: 14,
      color: AppColors.parchment,
    ),
    bodyLarge: TextStyle(
      fontFamily: bodyFont,
      fontSize: 16,
      height: 1.55,
      color: AppColors.parchment,
    ),
    bodyMedium: TextStyle(
      fontFamily: bodyFont,
      fontSize: 14,
      height: 1.55,
      color: AppColors.sand,
    ),
    bodySmall: TextStyle(
      fontFamily: bodyFont,
      fontSize: 12.5,
      height: 1.45,
      color: AppColors.mist,
    ),
    labelLarge: TextStyle(
      fontFamily: bodyFont,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    ),
    labelMedium: TextStyle(
      fontFamily: monoFont,
      fontWeight: FontWeight.w500,
      fontSize: 12,
      letterSpacing: 0.4,
      color: AppColors.sand,
    ),
    labelSmall: TextStyle(
      fontFamily: monoFont,
      fontWeight: FontWeight.w500,
      fontSize: 11,
      letterSpacing: 1.2,
      color: AppColors.mist,
    ),
  );
}
