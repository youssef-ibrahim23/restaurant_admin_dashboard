import 'package:get_it/get_it.dart';
import 'package:restaurant_admin_dashboard/core/network/supabase_client.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/service/menu_service.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/repositories/menu_repository.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/add_menu_item_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/delete_menu_item_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/edit_menu_item_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/get_menu_items_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/toggle_menu_item_availability_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_bloc.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/repositories/sections_repository_impl.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/service/sections_service.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/repositories/sections_repository.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/usecases/delete_section_usecase.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/usecases/edit_section_usecase.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/usecases/get_sections_usecase.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/usecases/insert_section_usecase.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_bloc.dart';
import 'package:restaurant_admin_dashboard/features/sidebar/presentation/BLoC/sidebar_bloc.dart';

import '../../features/customers/data/repositories/customers_repository_impl.dart';
import '../../features/customers/data/service/customers_service.dart';
import '../../features/customers/domain/repositories/customers_repository.dart';
import '../../features/customers/domain/usecases/get_customers_usecase.dart';
import '../../features/customers/presentation/BLoC/customers_bloc.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/data/service/dashboard_service.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/dashboard/domain/usecases/dashboard_usecase.dart';
import '../../features/dashboard/presentation/BLoC/dashboard_bloc.dart';
import '../../features/drivers/data/repositories/drivers_repository_impl.dart';
import '../../features/drivers/data/service/driver_service.dart';
import '../../features/drivers/domain/repositories/drivers_repository.dart';
import '../../features/drivers/domain/usecases/get_drivers_usecase.dart';
import '../../features/drivers/presentation/BLoC/drivers_bloc.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/data/service/orders_service.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/get_orders_usecase.dart';
import '../../features/orders/domain/usecases/update_status_usecase.dart';
import '../../features/orders/presentation/BLoC/orders_bloc.dart';
import '../../features/promos/data/repositories/promo_repository_Impl.dart';
import '../../features/promos/data/service/promo_service.dart';
import '../../features/promos/domain/repositories/promos_repository.dart';
import '../../features/promos/domain/usecases/add_promo_usecase.dart';
import '../../features/promos/domain/usecases/delete_promo_usecase.dart';
import '../../features/promos/domain/usecases/edit_promo_usecase.dart';
import '../../features/promos/domain/usecases/get_promos_usecase.dart';
import '../../features/promos/presentation/BLoC/promos_bloc.dart';
import '../../features/settings/data/repositories/settings_repository_impl.dart';
import '../../features/settings/data/service/settings_service.dart';
import '../../features/settings/domain/repositories/settings_repository.dart';
import '../../features/settings/domain/usecases/change_password_usecase.dart';
import '../../features/settings/domain/usecases/get_settings_usecase.dart';
import '../../features/settings/domain/usecases/logout_usecase.dart';
import '../../features/settings/domain/usecases/update_settings_usecase.dart';
import '../../features/settings/presentation/BLoC/settings_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // network
  sl.registerLazySingleton<SupabaseClientService>(
    () => SupabaseClientService(),
  );

  // sidebar bloc
  sl.registerFactory(() => SidebarBloc());

  // sections feature
  sl.registerLazySingleton<SectionsService>(
    () => SectionsService(supabaseClientService: sl<SupabaseClientService>()),
  );
  sl.registerLazySingleton<SectionsRepository>(
    () => SectionsRepositoryImpl(sectionsService: sl<SectionsService>()),
  );
  sl.registerLazySingleton(
    () => GetSectionsUseCase(repository: sl<SectionsRepository>()),
  );
  sl.registerLazySingleton(
    () => InsertSectionUseCase(repository: sl<SectionsRepository>()),
  );
  sl.registerLazySingleton(
    () => EditSectionUseCase(repository: sl<SectionsRepository>()),
  );
  sl.registerLazySingleton(
    () => DeleteSectionUseCase(repository: sl<SectionsRepository>()),
  );
  sl.registerFactory(
    () => SectionsBloc(
      getSectionsUseCase: sl<GetSectionsUseCase>(),
      insertSectionUseCase: sl<InsertSectionUseCase>(),
      editSectionUseCase: sl<EditSectionUseCase>(),
      deleteSectionUseCase: sl<DeleteSectionUseCase>(),
    ),
  );

  // menu feature
  sl.registerLazySingleton<MenuService>(
    () => MenuService(supabaseClientService: sl<SupabaseClientService>()),
  );
  sl.registerLazySingleton<MenuRepository>(
    () => MenuRepositoryImpl(menuService: sl<MenuService>()),
  );
  sl.registerLazySingleton(
    () => GetMenuItemsUseCase(repository: sl<MenuRepository>()),
  );
  sl.registerLazySingleton(
    () => AddMenuItemUseCase(repository: sl<MenuRepository>()),
  );
  sl.registerLazySingleton(
    () => EditMenuItemUseCase(repository: sl<MenuRepository>()),
  );
  sl.registerLazySingleton(
    () => ToggleMenuItemAvailabilityUseCase(repository: sl<MenuRepository>()),
  );
  sl.registerLazySingleton(
    () => DeleteMenuItemUseCase(repository: sl<MenuRepository>()),
  );
  sl.registerFactory(
    () => MenuBloc(
      getMenuItemsUseCase: sl<GetMenuItemsUseCase>(),
      addMenuItemUseCase: sl<AddMenuItemUseCase>(),
      editMenuItemUseCase: sl<EditMenuItemUseCase>(),
      toggleMenuItemAvailabilityUseCase:
          sl<ToggleMenuItemAvailabilityUseCase>(),
      deleteMenuItemUseCase: sl<DeleteMenuItemUseCase>(),
    ),
  );

  // customers feature
  sl.registerLazySingleton<CustomersService>(
    () => CustomersService(supabaseClientService: sl<SupabaseClientService>()),
  );
  sl.registerLazySingleton<CustomersRepository>(
    () => CustomersRepositoryImpl(customersService: sl<CustomersService>()),
  );
  sl.registerLazySingleton(
    () => GetCustomersUseCase(customersRepository: sl<CustomersRepository>()),
  );
  sl.registerFactory(
    () => CustomersBloc(
      getCustomersUseCase: sl<GetCustomersUseCase>(),
    ),
  );

  // dashboard feature
  sl.registerLazySingleton<DashboardService>(
    () => DashboardService(supabaseClientService: sl<SupabaseClientService>()),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(dashboardService: sl<DashboardService>()),
  );
  sl.registerLazySingleton(
    () => DashboardUseCase(dashboardRepository: sl<DashboardRepository>()),
  );
  sl.registerFactory(
    () => DashboardBloc(dashboardUseCase: sl<DashboardUseCase>()),
  );

  // orders feature
  sl.registerLazySingleton<OrdersService>(
    () => OrdersService(supabaseClientService: sl<SupabaseClientService>()),
  );
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(ordersService: sl<OrdersService>()),
  );
  sl.registerLazySingleton(
    () => GetOrdersUseCase(ordersRepository: sl<OrdersRepository>()),
  );
  sl.registerLazySingleton(
    () => UpdateStatusUseCase(ordersRepository: sl<OrdersRepository>()),
  );
  sl.registerFactory(
    () => OrdersBloc(
      getOrdersUseCase: sl<GetOrdersUseCase>(),
      updateStatusUseCase: sl<UpdateStatusUseCase>(),
    ),
  );

  // promos feature
  sl.registerLazySingleton<PromoService>(
    () => PromoService(supabaseClientService: sl<SupabaseClientService>()),
  );
  sl.registerLazySingleton<PromosRepository>(
    () => PromoRepositoryImpl(promoService: sl<PromoService>()),
  );
  sl.registerLazySingleton(
    () => GetPromosUseCase(promosRepository: sl<PromosRepository>()),
  );
  sl.registerLazySingleton(
    () => AddPromoUseCase(promosRepository: sl<PromosRepository>()),
  );
  sl.registerLazySingleton(
    () => EditPromoUseCase(promosRepository: sl<PromosRepository>()),
  );
  sl.registerLazySingleton(
    () => DeletePromoUseCase(promosRepository: sl<PromosRepository>()),
  );
  sl.registerFactory(
    () => PromosBloc(
      getPromosUseCase: sl<GetPromosUseCase>(),
      addPromoUseCase: sl<AddPromoUseCase>(),
      editPromoUseCase: sl<EditPromoUseCase>(),
      deletePromoUseCase: sl<DeletePromoUseCase>(),
    ),
  );

  // settings feature
  sl.registerLazySingleton<SettingsService>(
    () => SettingsService(supabaseClientService: sl<SupabaseClientService>()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(settingsService: sl<SettingsService>()),
  );
  sl.registerLazySingleton(
    () => GetSettingsUseCase(repository: sl<SettingsRepository>()),
  );
  sl.registerLazySingleton(
    () => UpdateSettingsUseCase(repository: sl<SettingsRepository>()),
  );
  sl.registerLazySingleton(
    () => ChangePasswordUseCase(repository: sl<SettingsRepository>()),
  );
  sl.registerLazySingleton(
    () => LogoutUseCase(repository: sl<SettingsRepository>()),
  );
  sl.registerFactory(
    () => SettingsBloc(
      getSettingsUseCase: sl<GetSettingsUseCase>(),
      updateSettingsUseCase: sl<UpdateSettingsUseCase>(),
      changePasswordUseCase: sl<ChangePasswordUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    ),
  );

  // drivers feature
  sl.registerLazySingleton<DriversService>(
    () => DriversService(supabaseClientService: sl<SupabaseClientService>()),
  );

  sl.registerLazySingleton<DriversRepository>(
    () => DriversRepositoryImpl(driversService: sl<DriversService>()),
  );
  sl.registerLazySingleton(
    () => GetDriversUseCase(driversRepository: sl<DriversRepository>()),
  );

  sl.registerFactory(
    () => DriversBloc(
      getDriversUseCase: sl<GetDriversUseCase>(),
    ),
  );

}
