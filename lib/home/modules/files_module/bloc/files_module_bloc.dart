import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:files_repository/files_repository.dart';
import 'package:studipadawan/home/modules/files_module/bloc/files_module_event.dart';
import 'package:studipadawan/home/modules/files_module/bloc/files_module_state.dart';

class FilesModuleBloc extends Bloc<FilesModuleEvent, FilesModuleState> {
  FilesModuleBloc({
    required FilesRepository filesRepository,
    required AuthenticationRepository authenticationRepository,
  })  : _filesRepository = filesRepository,
        _authenticationRepository = authenticationRepository,
        super(const FilesModuleStateInitial());
  final FilesRepository _filesRepository;
  final AuthenticationRepository _authenticationRepository;
}
