import 'package:authentication_repository/authentication_repository.dart';
import 'package:files_repository/files_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/modules/files_module/bloc/files_module_bloc.dart';
import 'package:studipadawan/home/modules/files_module/bloc/files_module_state.dart';
import 'package:studipadawan/home/modules/module_card.dart';

class FilesModule extends StatelessWidget {
  const FilesModule({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MoudleCard(
      headline: 'Dateien',
      module: BlocProvider(
        create: (context) => FilesModuleBloc(
          filesRepository: context.read<FilesRepository>(),
          authenticationRepository: context.read<AuthenticationRepository>(),
        ),
        child: BlocBuilder<FilesModuleBloc, FilesModuleState>(
          builder: (context, state) {
            return const Text('Moin');
          },
        ),
      ),
    );
  }
}
