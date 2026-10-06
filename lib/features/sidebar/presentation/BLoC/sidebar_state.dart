import 'package:equatable/equatable.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

class SidebarState extends Equatable {
  final int selectedIndex;
  final SectionModel? selectedSection;

  const SidebarState({
    this.selectedIndex = 0,
    this.selectedSection,
  });

  SidebarState copyWith({
    int? selectedIndex,
    SectionModel? selectedSection,
    bool clearSelectedSection = false,
  }) {
    return SidebarState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      selectedSection: clearSelectedSection
          ? null
          : selectedSection ?? this.selectedSection,
    );
  }

  @override
  List<Object?> get props => [
    selectedIndex,
    selectedSection,
  ];
}