part of 'app_theme_bloc.dart';

enum NoteDispayLayout { grid, column }

class AppDataTheme extends Equatable {
  const AppDataTheme(
      {this.theme = ThemeMode.system, this.layout = NoteDispayLayout.grid});

  final ThemeMode theme;
  final NoteDispayLayout layout;

  @override
  List<Object?> get props => [theme, layout];

  AppDataTheme copyWith({ThemeMode? theme, NoteDispayLayout? layout}) {
    return AppDataTheme(
        theme: theme ?? this.theme, layout: layout ?? this.layout);
  }
}
