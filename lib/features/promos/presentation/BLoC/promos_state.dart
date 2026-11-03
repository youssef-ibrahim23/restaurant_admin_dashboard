import 'package:equatable/equatable.dart';
import '../../data/model/promos_model.dart';

sealed class PromosState extends Equatable {
  final List<PromoModel> promos;
  final bool isLoading;

  const PromosState({
    this.promos = const [],
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [promos, isLoading];
}

final class PromosInitial extends PromosState {
  const PromosInitial();
}

final class PromosLoading extends PromosState {
  const PromosLoading({
    super.promos,
  }) : super(isLoading: true);
}

final class PromosLoaded extends PromosState {
  const PromosLoaded({
    required super.promos,
  });
}

final class PromosError extends PromosState {
  final String message;
  final bool isActionError;

  const PromosError({
    required this.message,
    super.promos,
    this.isActionError = false,
  });

  @override
  List<Object?> get props => [...super.props, message, isActionError];
}

final class PromoActionSuccess extends PromosState {
  final String message;

  const PromoActionSuccess({
    required this.message,
    required super.promos,
  });

  @override
  List<Object?> get props => [...super.props, message];
}
