import 'package:get_it/get_it.dart';
import 'package:proyecto/features/recording/data/datasources/recording_datasource.dart';
import 'package:proyecto/features/recording/data/repositories/recording_repository_impl.dart';
import 'package:proyecto/features/recording/domain/repositories/recording_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:proyecto/features/auth/data/datasources/auth_datasource.dart';
import 'package:proyecto/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:proyecto/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:proyecto/features/auth/domain/repositories/auth_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Cliente de Supabase — singleton
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  // DataSource
  getIt.registerLazySingleton<AuthDataSource>(
    () => SupabaseAuthDataSource(getIt<SupabaseClient>()),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthDataSource>()),
  );

  // Recording injection
  getIt.registerLazySingleton<RecordingDatasource>(() => RecordingDatasource());

  getIt.registerLazySingleton<RecordingRepository>(
    () => RecordingRepositoryImpl(getIt<RecordingDatasource>()),
  );
}
