part of 'app_theme_bloc.dart';

abstract class AppThemeEvent extends Equatable {
  const AppThemeEvent();

  @override
  List<Object> get props => [];
}

class AppThemeChanged extends AppThemeEvent {
  const AppThemeChanged({required this.theme});

  final ThemeMode theme;

  @override
  List<Object> get props => [theme];
}
