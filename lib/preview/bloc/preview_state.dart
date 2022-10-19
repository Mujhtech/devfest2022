part of 'preview_bloc.dart';

class PreviewState extends Equatable {
  const PreviewState({
    this.isDrawerActive = false,
    this.shouldDisplayPropsReminder = true,
  });

  final bool isDrawerActive;
  final bool shouldDisplayPropsReminder;

  @override
  List<Object> get props => [
        isDrawerActive,
        shouldDisplayPropsReminder,
      ];

  PreviewState copyWith({
    bool? isDrawerActive,
    bool? shouldDisplayPropsReminder,
  }) {
    return PreviewState(
      isDrawerActive: isDrawerActive ?? this.isDrawerActive,
      shouldDisplayPropsReminder:
          shouldDisplayPropsReminder ?? this.shouldDisplayPropsReminder,
    );
  }
}
