part of 'app_theme_bloc.dart';

abstract class AppThemeEvent extends Equatable {
  const AppThemeEvent();

  @override
  List<Object> get props => [];
}

class AppDataCreated extends AppThemeEvent {
  const AppDataCreated();
}

class AppThemeChanged extends AppThemeEvent {
  const AppThemeChanged({required this.theme});

  final ThemeMode theme;

  @override
  List<Object> get props => [theme];
}

class NoteLayoutChanged extends AppThemeEvent {
  const NoteLayoutChanged({required this.layout});

  final NoteDispayLayout layout;

  @override
  List<Object> get props => [layout];
}
