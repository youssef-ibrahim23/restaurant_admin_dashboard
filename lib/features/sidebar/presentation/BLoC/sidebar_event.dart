import 'package:equatable/equatable.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/model/section_model.dart';

sealed class SidebarEvent extends Equatable {
  const SidebarEvent();

  @override
  List<Object?> get props => [];
}

final class SidebarItemSelected extends SidebarEvent {
  final int index;

  const SidebarItemSelected(this.index);

  @override
  List<Object?> get props => [index];
}

final class SectionMenuSelected extends SidebarEvent {
  final SectionModel section;

  const SectionMenuSelected(this.section);

  @override
  List<Object?> get props => [section];
}

final class SectionMenuBack extends SidebarEvent {
  const SectionMenuBack();
}