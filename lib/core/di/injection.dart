import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:proyecto/features/recording/data/datasources/recording_datasource.dart';
import 'package:proyecto/features/recording/data/repositories/recording_repository_impl.dart';
import 'package:proyecto/features/recording/domain/repositories/recording_repository.dart';
import 'package:proyecto/features/transcriptions/data/datasources/groq_datasource.dart';
import 'package:proyecto/features/transcriptions/data/datasources/storage_datasource.dart';
import 'package:proyecto/features/transcriptions/data/datasources/transcription_datasource.dart';
import 'package:proyecto/features/transcriptions/data/repositories/processing_repository_impl.dart';
import 'package:proyecto/features/transcriptions/domain/repositories/processing_repository.dart';
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

  getIt.registerLazySingleton<GroqDatasource>(
    () => GroqDatasourceImpl(apiKey: dotenv.env['GROQ_API_KEY']!),
  );

  // Processing — Storage
  getIt.registerLazySingleton<StorageDatasource>(
    () => SupabaseStorageDatasource(getIt<SupabaseClient>()),
  );

  // Processing — DB
  getIt.registerLazySingleton<TranscriptionDatasource>(
    () => SupabaseTranscriptionDatasource(getIt<SupabaseClient>()),
  );

  // Processing — Repository
  getIt.registerLazySingleton<ProcessingRepository>(
    () => ProcessingRepositoryImpl(
      groq: getIt<GroqDatasource>(),
      storage: getIt<StorageDatasource>(),
      transcription: getIt<TranscriptionDatasource>(),
    ),
  );
}
