import 'package:apptransaccional/core/network/http_client.dart';
import 'package:apptransaccional/features/hilos/data/datasources/hilos_remote_data_source.dart';
import 'package:apptransaccional/features/hilos/data/repositories/hilos_repository_impl.dart';
import 'package:apptransaccional/features/hilos/domain/repos/hilos_repository.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/create_hilo.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/delete_hilo.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/get_hilos.dart';
import 'package:apptransaccional/features/hilos/domain/usecases/update_hilo.dart';
import 'package:apptransaccional/features/hilos/presentation/provider/hilos_provider.dart';

HilosRemoteDataSource provideHilosRemoteDataSource({
  required HttpClient httpClient,
  String hilosPath = '/api/hilos',
}) {
  return HilosRemoteDataSourceImpl(
    httpClient,
    hilosPath: hilosPath,
  );
}

HilosRepository provideHilosRepository({
  required HilosRemoteDataSource remoteDataSource,
}) {
  return HilosRepositoryImpl(remoteDataSource: remoteDataSource);
}

GetHilos provideGetHilos({required HilosRepository repository}) {
  return GetHilos(repository);
}

CreateHilo provideCreateHilo({required HilosRepository repository}) {
  return CreateHilo(repository);
}

UpdateHilo provideUpdateHilo({required HilosRepository repository}) {
  return UpdateHilo(repository);
}

DeleteHilo provideDeleteHilo({required HilosRepository repository}) {
  return DeleteHilo(repository);
}

HilosProvider provideHilosProvider({
  required HilosRemoteDataSource remoteDataSource,
  required String? Function() currentUserIdResolver,
}) {
  final repository = provideHilosRepository(remoteDataSource: remoteDataSource);

  return HilosProvider(
    getHilos: provideGetHilos(repository: repository),
    createHilo: provideCreateHilo(repository: repository),
    updateHilo: provideUpdateHilo(repository: repository),
    deleteHilo: provideDeleteHilo(repository: repository),
    currentUserIdResolver: currentUserIdResolver,
  );
}
