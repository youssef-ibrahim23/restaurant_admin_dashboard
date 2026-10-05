import 'package:get_it/get_it.dart';
import 'package:restaurant_admin_dashboard/core/network/supabase_client.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/repositories/menu_repository_impl.dart';
import 'package:restaurant_admin_dashboard/features/menu/data/service/menu_service.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/repositories/menu_repository.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/add_menu_item_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/edit_menu_item_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/get_menu_items_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/domain/usecases/toggle_menu_item_availability_usecase.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_bloc.dart';
import 'package:restaurant_admin_dashboard/features/menu/presentation/BLoC/menu_editor_cubit.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/repositories/sections_repository_impl.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/data/service/sections_service.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/repositories/sections_repository.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/usecases/delete_section_usecase.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/usecases/edit_section_usecase.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/usecases/get_sections_usecase.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/domain/usecases/insert_section_usecase.dart';
import 'package:restaurant_admin_dashboard/features/restaurant_sections/presentation/BLoC/sections_bloc.dart';
import 'package:restaurant_admin_dashboard/features/sidebar/presentation/BLoC/sidebar_bloc.dart';

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
  sl.registerFactory(
    () => MenuBloc(
      getMenuItemsUseCase: sl<GetMenuItemsUseCase>(),
      addMenuItemUseCase: sl<AddMenuItemUseCase>(),
      editMenuItemUseCase: sl<EditMenuItemUseCase>(),
      toggleMenuItemAvailabilityUseCase:
          sl<ToggleMenuItemAvailabilityUseCase>(),
    ),
  );
  sl.registerFactory(() => MenuEditorCubit());
}
