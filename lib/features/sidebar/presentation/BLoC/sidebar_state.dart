import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

// TODO: Implement Equatable (or override == and hashCode) so Bloc can compare states and prevent unnecessary UI rebuilds.
class SidebarState {
  final int selectedIndex;
  final SectionModel? selectedSection;

  const SidebarState({this.selectedIndex = 0, this.selectedSection});

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
}
