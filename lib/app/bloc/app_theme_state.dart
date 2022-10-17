part of 'app_theme_bloc.dart';

class AppThemeState extends Equatable {
  const AppThemeState({
    this.theme = ThemeMode.system,
  });

  final ThemeMode theme;

  @override
  List<Object?> get props => [
        theme,
      ];

  AppThemeState copyWith({
    ThemeMode? theme,
  }) {
    return AppThemeState(
      theme: theme ?? this.theme,
    );
  }
}
