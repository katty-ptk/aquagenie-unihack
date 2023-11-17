import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'get_it.util.config.dart';

final getIt = GetIt.instance;
bool getItIsConfigured = false;

@InjectableInit()
void setupGetIt() {
  getIt.init();
  getItIsConfigured = true;
}