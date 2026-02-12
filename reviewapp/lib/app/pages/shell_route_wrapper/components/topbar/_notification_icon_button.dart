part of '_topbar.dart';

class NotificationIconButton extends StatefulWidget {
  const NotificationIconButton({
    super.key,
    this.notificationCount = 0,
  });

  final int notificationCount;

  @override
  State<NotificationIconButton> createState() => _NotificationIconButtonState();
}

class _NotificationIconButtonState extends State<NotificationIconButton> {
  List<NotificationModel> notifications = [];
  int page = 1;
  final int limit = 20;
  bool isLastPage = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  void fetchNotifications() async {
    await getmynotifications(page: page.toString()).then((res) async {
      if (res.status == true) {
        var notifs = <NotificationModel>[];
        try {
          notifs = (res.data as List).map((e) {
            return NotificationModel.fromJson(e as Map<String, dynamic>);
          }).toList();
        } catch (e) {
          my_inspect(e);
          notifs = [];
        }
        if (notifs.length < limit) {
          isLastPage = true;
        }
        setState(() {
          notifications.addAll(notifs);
          page += 1;
        });
        if (kIsWeb ||
            defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.linux ||
            defaultTargetPlatform == TargetPlatform.macOS) {
          if (kReleaseMode) {
            Timer.periodic(const Duration(seconds: 45), (_) {
              if (!mounted) return;
              fetchNewtifications();
            });
          }
        } else {
          if (kReleaseMode) {
            Timer.periodic(const Duration(seconds: 45), (_) {
              if (!mounted) return;
              fetchNewtifications();
            });
          }
        }
      }
    }).catchError((e) {
      my_inspect(e);
      // toast(e.toString());
    });
  }

  void fetchNewtifications() async {
    await getmyNewnotifications(
            lastDate: notifications.isNotEmpty
                ? notifications.first.createdAt?.toIso8601String()
                : "")
        .then((res) async {
      if (res.status == true) {
        var notifs = <NotificationModel>[];
        try {
          notifs = (res.data as List).map((e) {
            return NotificationModel.fromJson(e as Map<String, dynamic>);
          }).toList();
        } catch (e) {
          my_inspect(e);
          notifs = [];
        }
        if (notifs.isNotEmpty) {
          setState(() {
            notifications.insertAll(0, notifs);
          });
        }
      }
    }).catchError((e) {
      my_inspect(e);
      // toast(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _dropdownStyle = AcnooDropdownStyle(context);

    return DropdownButton2(
      underline: const SizedBox.shrink(),
      customButton: _buildButton(context),
      dropdownStyleData: _dropdownStyle.dropdownStyle.copyWith(
        width: responsiveValue<double>(
          context,
          xs: 380,
          md: 425,
        ),
        maxHeight: 425,
        offset: const Offset(0, -24),
        scrollbarTheme: _theme.scrollbarTheme.copyWith(
          thumbVisibility: WidgetStateProperty.all<bool>(false),
          trackVisibility: WidgetStateProperty.all<bool>(false),
        ),
      ),
      menuItemStyleData: _dropdownStyle.menuItemStyle.copyWith(
          height: responsiveValue<double?>(
            context,
            xs: 62,
            md: 70,
            lg: 80,
          ),
          padding: EdgeInsets.zero),
      items: List.generate(
        notifications.length,
        (index) {
          return DropdownMenuItem(
            value: index,
            child: NotifiactionTile(
              notification: notifications[index],
              onTap: () async {
                if (notifications[index].isRead == false) {
                  await markNotifAsRead({
                    "id": notifications[index].id.validate(),
                    "isRead": true
                  }).then((value) {
                    if (value.status == true) {
                      setState(() {
                        notifications[index].isRead = true;
                      });
                    }
                  }).catchError((e) {
                    my_inspect(e);
                  });
                }
                if (notifications[index].data != null &&
                    notifications[index].data!['link'] != null) {
                  simulateScreenTap();
                  commonLaunchUrl(notifications[index].data!['link'],
                      launchMode: LaunchMode.inAppBrowserView);
                } else {
                  switch (notifications[index].data?['type']) {
                    case 'procuration_signed':
                    case 'procuration_created':
                      if (notifications[index].data?['procurationId'] != null) {
                        await FullScreenLoadingDialog(
                          onInit: () async {
                            await getUnityPrrocuration(notifications[index]
                                    .data!['procurationId']
                                    .toString())
                                .then((res) async {
                              if (res.status == true) {
                                var proccuration = Procuration.fromJson(
                                    res.data as Map<String, dynamic>);
                                proccuration.source = "notification";
                                seeProcuration(
                                    proccuration: proccuration,
                                    context: context);
                              }
                            }).catchError((e) {
                              my_inspect(e);
                              toast(e.toString());
                            });
                            return true;
                          },
                        ).show(
                          context,
                          onOk: () {
                            context.popRoute();
                          },
                        );
                      }
                      break;
                    case 'review_ready':
                      if (notifications[index].data?['reviewId'] != null) {
                        await FullScreenLoadingDialog(
                          onInit: () async {
                            await getUnityReview(notifications[index]
                                    .data!['reviewId']
                                    .toString())
                                .then((res) async {
                              if (res.status == true) {
                                var review = Review.fromJson(
                                    res.data as Map<String, dynamic>);
                                review.source = "notification";
                                final wizardState =
                                    context.read<AppThemeProvider>();
                                wizardState.prefillReview(
                                  review,
                                );
                                context.push(
                                  '/review/${review.id}',
                                  extra: review,
                                );
                              }
                            }).catchError((e) {
                              my_inspect(e);
                              toast(e.toString());
                            });
                            return true;
                          },
                        ).show(
                          context,
                          onOk: () {
                            context.popRoute();
                          },
                        );
                      }
                      break;
                    case 'inventory':
                      // if (notifications[index].data?['inventoryId'] != null) {
                      //   context.pushRoute(InventoryDetailsRoute(
                      //       inventoryId: notifications[index]
                      //           .data!['inventoryId']
                      //           .toString()));
                      // }
                      break;
                    default:
                      break;
                  }
                }
              },
            ),
          );
        },
      ),
      onChanged: (value) {},
    );
  }

  Widget _buildButton(BuildContext context) {
    final _theme = Theme.of(context);
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final _size = constraints.biggest;
        return SizedBox.square(
          dimension: _size.height / 2,
          child: Stack(
            children: [
              const Center(
                child: Icon(
                  Icons.notifications_none_sharp,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                height: _size.height / 3.74,
                width: _size.height / 3.74,
                child: Container(
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Text(
                    notifications
                        .where((e) => e.isRead == false)
                        .length
                        .toString(),
                    style: _theme.textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                      color: _theme.colorScheme.onError,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class NotifiactionTile extends StatelessWidget {
  const NotifiactionTile({super.key, required this.notification, this.onTap});
  final NotificationModel notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final isReadTextStyle = notification.isRead == true
        ? _theme.textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          )
        : _theme.textTheme.bodyMedium?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          );
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          child: SizedBox(
            height: 100,
            child: ListTile(
              onTap: () {
                if (onTap != null) {
                  onTap!();
                }
              },
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.notifications,
                color: _theme.colorScheme.primary,
              ),
              title: Text(
                notification.title.validate(),
                style: isReadTextStyle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                notification.message.validate(),
                style: _theme.textTheme.bodySmall!.copyWith(
                  fontSize: 13,
                  color: _theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                formatPassDate(notification.createdAt?.toString() ?? "",
                    format: "dd/MM/yyyy"),
                style: isReadTextStyle?.copyWith(fontSize: 10),
              ),
            ),
          ),
        ),
      ],
    ).paddingSymmetric(horizontal: 8);
  }
}
