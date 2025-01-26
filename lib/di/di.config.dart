// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:super_simple_accountant/data_sources/entry_local_data_source.dart'
    as _i555;
import 'package:super_simple_accountant/data_sources/entry_remote_data_source.dart'
    as _i164;
import 'package:super_simple_accountant/repositories/entry_repository.dart'
    as _i181;
import 'package:super_simple_accountant/services/connectivity_service.dart'
    as _i844;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i164.EntryRemoteDataSource>(
        () => _i164.EntryRemoteDataSource());
    gh.lazySingleton<_i555.EntryLocalDataSource>(
        () => _i555.EntryLocalDataSource());
    gh.lazySingleton<_i844.ConnectivityService>(
        () => _i844.ConnectivityService());
    gh.lazySingleton<_i181.EntryRepository>(() => _i181.EntryRepository(
          entryRemoteDataSource: gh<_i164.EntryRemoteDataSource>(),
          entryLocalDataSource: gh<_i555.EntryLocalDataSource>(),
          connectivityService: gh<_i844.ConnectivityService>(),
        ));
    return this;
  }
}
