import 'package:authentication_repository/authentication_repository.dart';
import 'package:files_repository/files_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/bloc/home_bloc.dart';
import 'package:studipadawan/home/modules/files_module/bloc/files_module_bloc.dart';
import 'package:studipadawan/home/modules/files_module/bloc/files_module_state.dart';
import 'package:studipadawan/home/modules/module.dart';
import 'package:studipadawan/home/modules/module_card.dart';

class FilesModule extends StatelessWidget implements Module {
  const FilesModule({
    super.key,
  });

  static const type = ModuleType.files;

  @override
  Widget build(BuildContext context) {
    return MoudleCard(
      type: type,
      child: BlocProvider(
        create: (context) => FilesModuleBloc(
          filesRepository: context.read<FilesRepository>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: BlocBuilder<FilesModuleBloc, FilesModuleState>(
          builder: (context, state) {
            return const Text('Content');
          },
        ),
      ),
    );
  }

  @override
  ModuleType getType() {
    return type;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
    };
  }
}
