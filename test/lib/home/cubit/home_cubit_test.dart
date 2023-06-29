import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:studipadawan/home/cubit/home_cubit.dart';
import 'package:studipadawan/home/modules/bloc/module_bloc.dart';
import 'package:studipadawan/home/modules/message_module/bloc/message_module_bloc.dart';

import '../../../helpers/hydrated_stoarge.dart';

class MockMessageModuleBloc extends MockBloc<ModuleEvent, ModuleState>
    implements MessageModuleBloc {}

class MockFileModuleBloc extends MockBloc<ModuleEvent, ModuleState>
    implements MessageModuleBloc {}

class MockNewsModuleBloc extends MockBloc<ModuleEvent, ModuleState>
    implements MessageModuleBloc {}

class MockCalendarModuleBloc extends MockBloc<ModuleEvent, ModuleState>
    implements MessageModuleBloc {}

void main() {
  late MockMessageModuleBloc mockMessageModuleBloc;
  late MockFileModuleBloc mockFileModuleBloc;
  late MockNewsModuleBloc mockNewsModuleBloc;
  late MockCalendarModuleBloc mockCalendarModuleBloc;

  late HomeCubit sut;

  setUp(() {
    initHydratedStorage();
    mockMessageModuleBloc = MockMessageModuleBloc();
    mockFileModuleBloc = MockFileModuleBloc();
    mockNewsModuleBloc = MockNewsModuleBloc();
    mockCalendarModuleBloc = MockCalendarModuleBloc();

    sut = HomeCubit(
      moduleBlocs: {
        ModuleType.calendar: mockCalendarModuleBloc,
        ModuleType.files: mockFileModuleBloc,
        ModuleType.messages: mockMessageModuleBloc,
        ModuleType.news: mockNewsModuleBloc,
      },
    );
  });

  group('persist selected modules', () {
    test('toJson (storing)', () {
      final Map<String, dynamic>? storedJson =
          sut.toJson(const HomeState(selectedModules: ModuleType.values));

      expect(storedJson, {
        'selectedModules': ['messages', 'calendar', 'news', 'files']
      });
    });

    test('fromJson (retrieving)', () {
      final HomeState? stateFromJson = sut.fromJson({
        'selectedModules': ['messages', 'calendar', 'news', 'files']
      });

      expect(stateFromJson?.selectedModules, ModuleType.values);
    });
  });

  group('update selected modules', () {
    blocTest<HomeCubit, HomeState>(
      'move module from first to last position',
      build: () => sut,
      seed: () => const HomeState(
        selectedModules: [
          ModuleType.messages,
          ModuleType.calendar,
          ModuleType.news,
          ModuleType.files,
        ],
      ),
      act: (cubit) => cubit.moveModule(0, 4),
      expect: () => [
        const HomeState(
          selectedModules: [
            ModuleType.calendar,
            ModuleType.news,
            ModuleType.files,
            ModuleType.messages,
          ],
        )
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'move module from last to first position',
      build: () => sut,
      seed: () => const HomeState(
        selectedModules: [
          ModuleType.calendar,
          ModuleType.news,
          ModuleType.files,
          ModuleType.messages,
        ],
      ),
      act: (cubit) => cubit.moveModule(3, 0),
      expect: () => [
        const HomeState(
          selectedModules: [
            ModuleType.messages,
            ModuleType.calendar,
            ModuleType.news,
            ModuleType.files,
          ],
        )
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'override selected modules',
      setUp: () => registerFallbackValue(ModuleType.calendar),
      build: () => sut,
      seed: () => const HomeState(
        selectedModules: [
          ModuleType.calendar,
          ModuleType.news,
        ],
      ),
      act: (cubit) => cubit.overrideSelectedModules(
        modules: [ModuleType.files, ModuleType.messages],
      ),
      expect: () => [
        const HomeState(
          selectedModules: [
            ModuleType.files,
            ModuleType.messages,
          ],
        )
      ],
    );
  });
}
