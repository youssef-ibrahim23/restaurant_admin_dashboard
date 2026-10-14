import 'package:equatable/equatable.dart';

class SidebarState extends Equatable {
  final int selectedIndex;

  const SidebarState({
    this.selectedIndex = 0,
  });

  SidebarState copyWith({
    int? selectedIndex,
  }) {
    return SidebarState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [
    selectedIndex,
  ];
}