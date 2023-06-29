import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/home/profile/bloc/profile_bloc.dart';
import 'package:studipadawan/home/profile/widgets/profile_page_body.dart';
import 'package:studipadawan/utils/loading_indicator.dart';
import 'package:studipadawan/utils/widgets/error_view/error_view.dart';
import 'package:user_repository/user_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(
        userRepository: context.read<UserRepository>(),
      )..add(ProfileRequested()),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
      ),
      body: Center(
        child: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              switch (state) {
                case ProfileLoading() || ProfileInitial():
                  return const LoadingIndicator();
                case ProfilePopulated(user: final user):
                  return ProfilePageBody(
                    lastName: user.attributes.familyName,
                    formattedName: user.attributes.formattedName,
                    email: user.attributes.email,
                    phone: user.attributes.phone,
                    website: user.attributes.homepage,
                    address: user.attributes.address,
                    username: user.attributes.username,
                  );
                case ProfileFailure():
                  return ErrorView(
                    message: 'Fehler beim Laden des Profils',
                    onRetryPressed: () {
                      context.read<ProfileBloc>().add(ProfileRequested());
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
