// https://github.com/felangel/bloc/blob/17b922b9bda38a06550ff648a1a4bed51ba7b982/examples/flutter_weather/test/helpers/hydrated_bloc.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockStorage extends Mock implements Storage {
  @override
  Future<void> write(String key, dynamic value) async {}
}

final hydratedStorage = MockStorage();

void initHydratedBloc() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = hydratedStorage;
}
