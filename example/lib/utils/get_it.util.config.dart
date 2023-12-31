// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:bluetooth_classic_example/providers/auth.provider.dart' as _i3;
import 'package:bluetooth_classic_example/providers/device.provider.dart'
    as _i4;
import 'package:bluetooth_classic_example/providers/user.provider.dart' as _i5;
import 'package:bluetooth_classic_example/repos/water_tracker.repo.dart' as _i6;
import 'package:bluetooth_classic_example/screens/profile_screen/profile_screen.provider.dart'
    as _i7;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i1.GetIt init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.singleton<_i3.AuthProvider>(_i3.AuthProvider());
    gh.singleton<_i4.DeviceProvider>(_i4.DeviceProvider());
    gh.singleton<_i5.UserProvider>(_i5.UserProvider(gh<_i3.AuthProvider>()));
    gh.singleton<_i6.WaterTracker>(_i6.WaterTracker());
    gh.singleton<_i7.ProfileScreenProvider>(
        _i7.ProfileScreenProvider(gh<_i5.UserProvider>()));
    return this;
  }
}
