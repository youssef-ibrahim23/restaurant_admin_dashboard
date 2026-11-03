import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_promo_usecase.dart';
import '../../domain/usecases/delete_promo_usecase.dart';
import '../../domain/usecases/edit_promo_usecase.dart';
import '../../domain/usecases/get_promos_usecase.dart';
import 'promos_event.dart';
import 'promos_state.dart';

class PromosBloc extends Bloc<PromosEvent, PromosState> {
  final GetPromosUseCase getPromosUseCase;
  final AddPromoUseCase addPromoUseCase;
  final EditPromoUseCase editPromoUseCase;
  final DeletePromoUseCase deletePromoUseCase;

  PromosBloc({
    required this.getPromosUseCase,
    required this.addPromoUseCase,
    required this.editPromoUseCase,
    required this.deletePromoUseCase,
  }) : super(const PromosInitial()) {
    on<LoadPromos>(_onLoadPromos);
    on<AddPromo>(_onAddPromo);
    on<EditPromo>(_onEditPromo);
    on<DeletePromo>(_onDeletePromo);
    on<TogglePromoStatus>(_onTogglePromoStatus);
  }

  Future<void> _onLoadPromos(
    LoadPromos event,
    Emitter<PromosState> emit,
  ) async {
    emit(const PromosLoading());
    try {
      final promos = await getPromosUseCase();
      emit(PromosLoaded(promos: promos));
    } catch (e) {
      emit(PromosError(message: e.toString(), promos: state.promos));
    }
  }

  Future<void> _onAddPromo(
    AddPromo event,
    Emitter<PromosState> emit,
  ) async {
    final currentPromos = state.promos;
    try {
      await addPromoUseCase(event.promoModel);
      final refreshed = await getPromosUseCase();
      emit(
        PromoActionSuccess(
          message: 'Promo added successfully',
          promos: refreshed,
        ),
      );
    } catch (e) {
      emit(PromosError(
        message: e.toString(),
        promos: currentPromos,
        isActionError: true,
      ));
    }
  }

  Future<void> _onEditPromo(
    EditPromo event,
    Emitter<PromosState> emit,
  ) async {
    final currentPromos = state.promos;
    try {
      await editPromoUseCase(event.promoModel);
      final promos = currentPromos.map((promo) {
        return promo.id == event.promoModel.id ? event.promoModel : promo;
      }).toList();
      emit(
        PromoActionSuccess(
          message: 'Promo updated successfully',
          promos: promos,
        ),
      );
    } catch (e) {
      emit(PromosError(
        message: e.toString(),
        promos: currentPromos,
        isActionError: true,
      ));
    }
  }

  Future<void> _onDeletePromo(
    DeletePromo event,
    Emitter<PromosState> emit,
  ) async {
    final currentPromos = state.promos;
    try {
      await deletePromoUseCase(event.id);
      final promos =
          currentPromos.where((promo) => promo.id != event.id).toList();
      emit(
        PromoActionSuccess(
          message: 'Promo deleted successfully',
          promos: promos,
        ),
      );
    } catch (e) {
      emit(PromosError(
        message: e.toString(),
        promos: currentPromos,
        isActionError: true,
      ));
    }
  }

  Future<void> _onTogglePromoStatus(
    TogglePromoStatus event,
    Emitter<PromosState> emit,
  ) async {
    final currentPromos = state.promos;
    try {
      await editPromoUseCase(event.promoModel);
      final updatedPromos = currentPromos.map((promo) {
        return promo.id == event.promoModel.id ? event.promoModel : promo;
      }).toList();
      emit(
        PromoActionSuccess(
          message: 'Promo status updated',
          promos: updatedPromos,
        ),
      );
    } catch (e) {
      emit(PromosError(
        message: e.toString(),
        promos: currentPromos,
        isActionError: true,
      ));
    }
  }
}
