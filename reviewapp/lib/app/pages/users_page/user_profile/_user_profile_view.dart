// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/providers/_theme_provider.dart';
import 'package:nb_utils/nb_utils.dart';

// 📦 Package imports:
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import 'package:jatai_etatsdeslieux/app/pages/users_page/user_profile/user_profile_details_widget.dart';
import 'package:jatai_etatsdeslieux/app/pages/users_page/user_profile/user_profile_update_widget.dart';
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/fuctions/_get_image.dart';
import '../../../widgets/shadow_container/_shadow_container.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Jks.context = context;
    final theme = Theme.of(context);
    final lang = l.S.of(context);
    final textTheme = theme.textTheme;
    final _padding = responsiveValue<double>(
      context,
      xs: 16 / 2,
      sm: 16 / 2,
      md: 16 / 2,
      lg: 24 / 2,
    );

    AppThemeProvider appstate = context.watch<AppThemeProvider>();
    return Scaffold(
      backgroundColor:
          context.theme.brightness == Brightness.dark ? blackColor : whiteColor,
      body: SingleChildScrollView(
        child: ResponsiveGridRow(
          children: [
            ///-----------------------------user_profile_details
            ResponsiveGridCol(
              lg: 6,
              child: Padding(
                padding: EdgeInsets.all(_padding),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ShadowContainer(
                      contentPadding: EdgeInsets.zero,
                      showHeader: false,
                      child: UserProfileDetailsWidget(
                          padding: _padding,
                          theme: theme,
                          textTheme: textTheme),
                    ),

                    /// -------------image
                    // Positioned(
                    //   top: 123,
                    //   child: Container(
                    //     height: 110,
                    //     width: 110,
                    //     decoration: const BoxDecoration(
                    //       shape: BoxShape.circle,
                    //     ),
                    //     clipBehavior: Clip.antiAlias,
                    //     child: Stack(children: [
                    //       Positioned.fill(
                    //         child: getImageType(
                    //           appstate.currentUser.imageUrl != null
                    //               ? uploadUrl(appstate.currentUser.imageUrl)
                    //               : _userProfile.$1,
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //       Positioned(
                    //         right: 10,
                    //         bottom: 10,
                    //         child: InkWell(
                    //           onTap: () {
                    //             sourceSelect(
                    //                 context: context,
                    //                 callback: (croppedFile) async {
                    //                   await uploadFile(croppedFile,
                    //                       isprofile: true,
                    //                       cb: (photolist) async {
                    //                     appstate.currentUser.imageUrl =
                    //                         photolist;
                    //                     appstate.setloading(true);
                    //                     await Future.delayed(
                    //                         const Duration(seconds: 2));
                    //                     appstate.setloading(false);
                    //                   });
                    //                 });
                    //           },
                    //           child: Container(
                    //             padding: const EdgeInsets.all(4),
                    //             decoration: BoxDecoration(
                    //               color: theme.primaryColor,
                    //               shape: BoxShape.circle,
                    //             ),
                    //             child: Icon(
                    //               Icons.edit,
                    //               size: 20,
                    //               color: whiteColor,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ]),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),

            ///-----------------------------user_profile_update
            ResponsiveGridCol(
              lg: 6,
              child: Padding(
                padding: EdgeInsets.all(_padding),
                child: ShadowContainer(
                  contentPadding: EdgeInsets.all(_padding),
                  // headerText: 'User Profile',
                  headerText: lang.userProfile,
                  child: UserProfileUpdateWidget(textTheme: textTheme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const (String,) _userProfile =
    ('assets/images/static_images/avatars/person_images/person_image_01.jpeg',);
