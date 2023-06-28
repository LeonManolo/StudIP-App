import 'package:app_ui/app_ui.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studipadawan/app/bloc/app_bloc.dart';
import 'package:studipadawan/home/profile/widgets/optional_profile_attribute.dart';
import 'package:studipadawan/home/profile/widgets/profile_log_out_button.dart';
import 'package:studipadawan/utils/widgets/profile_image_avatar.dart';

class ProfilePageBody extends StatelessWidget {
  const ProfilePageBody({
    super.key,
    required this.lastName,
    required this.formattedName,
    required this.email,
    required this.username,
    this.phone,
    this.website,
    this.address,
  });

  final String lastName;
  final String formattedName;
  final String email;
  final String username;
  final String? phone;
  final String? website;
  final String? address;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.15;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.xxlg,
            bottom: AppSpacing.lg,
          ),
          child: ProfileImageAvatar(
            replacementLetter: lastName,
            fontSize: size / 2,
            radius: size,
          ),
        ),
        Text(
          formattedName,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.xs,
          ),
          child: Text(
            username,
            style: TextStyle(
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
        const Spacer(),
        OptionalProfileAttribute(
          title: phone,
          iconData: EvaIcons.phoneOutline,
        ),
        OptionalProfileAttribute(
          title: email,
          iconData: EvaIcons.emailOutline,
        ),
        OptionalProfileAttribute(
          title: website,
          iconData: EvaIcons.globe,
        ),
        OptionalProfileAttribute(
          title: address,
          iconData: EvaIcons.pinOutline,
          displayDivider: false,
        ),
        const Spacer(),
        ProfileLogOutButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<AppBloc>().add(const AppLogoutRequested());
          },
        ),
      ],
    );
  }
}
