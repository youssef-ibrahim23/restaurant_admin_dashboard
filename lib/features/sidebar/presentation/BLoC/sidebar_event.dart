import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

// TODO: Change 'abstract class' to 'sealed class' to leverage Dart 3 exhaustive pattern matching and implement Equatable for events.
abstract class SidebarEvent {}

class SidebarItemSelected extends SidebarEvent {
  final int index;

  SidebarItemSelected(this.index);
}

class SectionMenuSelected extends SidebarEvent {
  final SectionModel section;

  SectionMenuSelected(this.section);
}

class SectionMenuBack extends SidebarEvent {}
