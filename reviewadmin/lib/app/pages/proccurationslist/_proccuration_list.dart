// ignore_for_file: non_constant_identifier_names

part of 'proccuralionlist.dart';

class UserList extends StatelessWidget {
  final List<Procuration> filteredUsers;
  final TextEditingController searchController;
  final void Function(Procuration value) onUserTap;
  final TabController tabController;

  const UserList({
    super.key,
    required this.filteredUsers,
    required this.searchController,
    required this.onUserTap,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final isDark = _theme.colorScheme.brightness == Brightness.dark;
    final isMobileOrTablet = _isMobileOrTablet(context);
    final _borderType = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    );

    final _topConent = <Widget>[
      Text(
        "Liste des procurations",
        style: _theme.textTheme.headlineSmall
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
      tabbar(_theme, context),
      searchField(_borderType, context),
    ];

    return ShadowContainer(
      showHeader: false,
      contentPadding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...(isMobileOrTablet
                    ? _topConent
                    : List.from(_topConent.reversed.toList())
                  ..insert(
                    1,
                    const SizedBox(height: 16),
                  ))
              ],
            ),
          ),
          Expanded(
            child: Jks.proccurationState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredUsers.isEmpty
                    ? Center(
                        child: Text(
                          searchController.text.isNotEmpty
                              ? "Aucun résultat trouvé pour '${searchController.text}'"
                              : "Vous n'avez aucune procuration",
                          style: _theme.textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 16),
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) =>
                            _buildUserTile(context, index, isDark),
                      ),
          ),
        ],
      ),
    );
  }

  bool _isMobileOrTablet(BuildContext context) {
    return rf.ResponsiveValue<bool>(
      context,
      conditionalValues: const [
        rf.Condition.between(start: 0, end: 1023, value: true)
      ],
      defaultValue: false,
    ).value;
  }

  TextField searchField(OutlineInputBorder _borderType, BuildContext context) {
    final lang = l.S.of(context);
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        suffixIcon: _buildSearchIcon(),
        hintText: '${lang.search}...',
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        border: _borderType,
        enabledBorder: _borderType,
        focusedBorder: _borderType,
        errorBorder: _borderType,
        focusedErrorBorder: _borderType,
      ),
    );
  }

  TabBar tabbar(ThemeData _theme, BuildContext context) {
    return TabBar(
      padding: EdgeInsets.zero,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
          color: AcnooAppColors.kPrimary600,
          width: 2,
        ),
      ),
      controller: tabController,
      dividerColor: _theme.colorScheme.outline,
      tabs: [
        // Tab(text: 'Private'),
        Tab(text: "Créées"),
        // Tab(text: 'Group'),
        Tab(text: "Reçues"),
        //Tab(text: 'All'),
        Tab(text: "Toutes procurations"),
      ],
    );
  }

  Widget _buildSearchIcon() {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: AcnooAppColors.kPrimary700,
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: const Icon(
        Icons.search,
        color: AcnooAppColors.kWhiteColor,
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, int index, bool isDark) {
    final proc = filteredUsers[index];
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
        ),
        child: ListTile(
          titleAlignment: ListTileTitleAlignment.center,
          contentPadding: proc.isTheAutor()
              ? EdgeInsets.only(left: 16, bottom: 15)
              : EdgeInsets.all(8),
          onTap: () {
            onUserTap(proc);

            if (proc.isTheAutor()) {
              seeProcuration(proccuration: proc, context: context);
            } else {
              seeProcuration(proccuration: proc, context: context);
            }
          },
          leading: Container(
            constraints: BoxConstraints.tight(Size.square(40)),
            padding: const EdgeInsets.all(10),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: (proc.status == 'signing'
                        ? AcnooAppColors.kPrimary600
                        : proc.status == 'completed'
                            ? AcnooAppColors.kWhiteColor
                            : AcnooAppColors.kNeutral400)
                    .withAlpha(50)),
            child: getImageType(
                proc.status == 'signing'
                    ? "assets/images/widget_images/documentsign.svg"
                    : proc.status == 'completed'
                        ? "assets/images/widget_images/documentcheck.svg"
                        : "assets/images/widget_images/pending_orders.svg",
                fit: BoxFit.cover,
                height: double.maxFinite,
                width: double.maxFinite,
                colorFilter: ColorFilter.mode(
                  proc.status == 'signing'
                      ? AcnooAppColors.kPrimary600
                      : proc.status == 'completed'
                          ? AcnooAppColors.kPrimary900
                          : isDark
                              ? Colors.grey.shade400
                              : AcnooAppColors.kNeutral900,
                  BlendMode.srcIn,
                )),
          ),
          minVerticalPadding: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                flex: 3,
                child: Text(
                  "${proc.propertyDetails?.address}",
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              const SizedBox(width: 4.0),
              if (proc.isTheAutor())
                Flexible(
                    child: IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(0),
                        ),
                      ),
                      builder: (context) => Wrap(
                        children: [
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            title: Text(proc.propertyDetails?.address ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      fontSize: 18,
                                    )),
                            subtitle: Text(
                              'Que souhaitez-vous faire ?',
                              style: Theme.of(context).textTheme.bodySmall,
                            ).paddingTop(12),
                          ).paddingTop(16),
                          if (proc.meta?["signaturesMeta"] != null &&
                              proc.meta?["signaturesMeta"]?["allSigned"] ==
                                  true)
                            ListTile(
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              leading: const Icon(Icons.edit),
                              title: Text('Voir et télécharger la procuration',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                      )),
                              subtitle: Text(
                                'Télécharger la proccuration signée. Vous pouvez la prévisualiser avant de la télécharger.',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              onTap: () {
                                seeProcuration(
                                    proccuration: proc, context: context);
                              },
                            ),
                          proccuration_action_sheet(
                              title:
                                  '${(proc.isTheAutor()) ? "Modifier" : "Voir et/ou signer "}  ',
                              subtitle:
                                  'Modifier l\'état des lieux. Assurez-vous de sauvegarder vos modifications.'
                                      .tr,
                              context: context,
                              proccuration: proc,
                              onTap: () {
                                previewProcuration(proc,
                                    review: proc, context: context);

                                // if (review.meta?["signaturesMeta"] != null &&
                                //     review.meta?["signaturesMeta"]["allSigned"] ==
                                //         true) {
                                //   show_common_toast(
                                //     "Vous ne pouvez pas modifier un état des lieux déjà signé"
                                //         .tr,
                                //     context,
                                //   );
                                //   return;
                                // }
                                // final wizardState =
                                //     context.read<AppThemeProvider>();
                                // wizardState.prefillReview(
                                //   review,
                                // );
                                // Navigator.pop(context);

                                // context.push(
                                //   '/review/${review.id}',
                                //   extra: review,
                                // );
                              }),
                        ],
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                  padding: EdgeInsets.zero,
                )),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        getImageType(
                            "assets/images/widget_images/entrantenant.svg",
                            fit: BoxFit.cover,
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                              isDark
                                  ? Colors.grey.shade400
                                  : AcnooAppColors.kNeutral900,
                              BlendMode.srcIn,
                            )),
                        5.width,
                        Text(
                          "${authorname(proc.entrantenants![0])}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ).paddingOnly(right: 10, top: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        getImageType(
                            "assets/images/widget_images/exitenant.svg",
                            fit: BoxFit.cover,
                            height: 20,
                            width: 20,
                            colorFilter: ColorFilter.mode(
                              isDark
                                  ? Colors.grey.shade400
                                  : AcnooAppColors.kNeutral900,
                              BlendMode.srcIn,
                            )),
                        5.width,
                        Text(
                          "${authorname(proc.exitenants![0])}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade800,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AcnooAppColors.kPrimary900,
                          ),
                          child: Icon(
                            Icons.fingerprint,
                            size: 16,
                            color: AcnooAppColors.kWhiteColor,
                          ),
                        ),
                      ],
                    ).paddingOnly(top: 4, right: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void previewProcuration(Procuration proc,
    {required Procuration review, required BuildContext context}) {
  final wizardState = context.read<AppThemeProvider>();

  wizardState.prefillProccuration(
    review,
  );

  Jks.proccurationState.previewTheProcuration(review);

  context.push(
    '/preview/review/${review.id}',
    extra: review,
  );
}

proccuration_action_sheet({
  required BuildContext context,
  required Procuration proccuration,
  required String title,
  String subtitle = "",
  required void Function() onTap,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    leading: const Icon(Icons.edit),
    title: Text(title,
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.w600, fontSize: 16)),
    subtitle: Text(
      subtitle,
      style: Theme.of(context).textTheme.bodySmall,
    ),
    onTap: onTap,
  );
}

void seeProcuration(
    {required Procuration proccuration,
    required BuildContext context,
    bool isfromNewProc = false}) {
  final wizardState = context.read<AppThemeProvider>();

  wizardState.prefillProccuration(
    proccuration,
  );
  Jks.proccurationState
      .seteditingProcuration(proccuration, source: "seeProcuration");

  context.push(
    '/proccuration/${proccuration.id}',
    extra: proccuration,
  );
}
