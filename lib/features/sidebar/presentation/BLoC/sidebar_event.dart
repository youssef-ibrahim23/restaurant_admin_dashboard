import 'package:equatable/equatable.dart';

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