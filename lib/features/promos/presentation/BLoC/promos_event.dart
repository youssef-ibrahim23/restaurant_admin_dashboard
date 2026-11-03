import 'package:equatable/equatable.dart';
import '../../data/model/promos_model.dart';

sealed class PromosEvent extends Equatable {}

final class LoadPromos extends PromosEvent {
  @override
  List<Object?> get props => [];
}

final class AddPromo extends PromosEvent {
  final PromoModel promoModel;

  AddPromo({required this.promoModel});

  @override
  List<Object?> get props => [promoModel];
}

final class EditPromo extends PromosEvent {
  final PromoModel promoModel;

  EditPromo({required this.promoModel});

  @override
  List<Object?> get props => [promoModel];
}

final class DeletePromo extends PromosEvent {
  final String id;

  DeletePromo({required this.id});

  @override
  List<Object?> get props => [id];
}

final class TogglePromoStatus extends PromosEvent {
  final PromoModel promoModel;

  TogglePromoStatus({required this.promoModel});

  @override
  List<Object?> get props => [promoModel];
}
