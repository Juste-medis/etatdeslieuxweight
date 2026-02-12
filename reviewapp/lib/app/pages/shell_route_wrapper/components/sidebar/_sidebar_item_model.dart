part of '_sidebar.dart';

class SidebarItemModel {
  final String name;
  final String iconPath;
  final SidebarItemType sidebarItemType;
  final List<SidebarSubmenuModel>? submenus;
  final String? navigationPath;
  final bool isPage;

  SidebarItemModel({
    required this.name,
    required this.iconPath,
    this.sidebarItemType = SidebarItemType.tile,
    this.submenus,
    this.navigationPath,
    this.isPage = false,
  }) : assert(
          sidebarItemType != SidebarItemType.submenu ||
              (submenus != null && submenus.isNotEmpty),
          'Sub menus cannot be null or empty if the item type is submenu',
        );
}

class SidebarSubmenuModel {
  final String name;
  final String? navigationPath;
  final bool isPage;

  SidebarSubmenuModel({
    required this.name,
    this.navigationPath,
    this.isPage = false,
  });
}

class GroupedMenuModel {
  final String name;
  final List<SidebarItemModel> menus;

  GroupedMenuModel({
    required this.name,
    required this.menus,
  });
}

enum SidebarItemType { tile, submenu }

List<SidebarItemModel> get _topMenus {
  return <SidebarItemModel>[
    SidebarItemModel(
      name: l.S.current.home,
      iconPath: 'assets/images/sidebar_icons/home-dash-star.svg',
      navigationPath: '/dashboard/home',
    ),
    SidebarItemModel(
      //name: "eCommerce",
      name: l.S.current.myreviews,
      iconPath: 'assets/images/sidebar_icons/copy-check.svg',
      navigationPath: '/reviews',
      sidebarItemType: SidebarItemType.submenu,
      submenus: [
        SidebarSubmenuModel(
          name: l.S.current.all,
          navigationPath: "all",
        ),
        SidebarSubmenuModel(
          name: l.S.current.inProgress,
          navigationPath: "inProgress",
        ),
        SidebarSubmenuModel(
          name: l.S.current.finished,
          navigationPath: "finished",
        ),
      ],
    ),
    SidebarItemModel(
      name: l.S.current.myprocurations,
      iconPath: 'assets/images/sidebar_icons/contact_mail.svg',
      navigationPath: '/proccurations',
      submenus: [
        SidebarSubmenuModel(
          name: "Tous".tr,
          navigationPath: "all",
        ),
        SidebarSubmenuModel(
          name: "Bailleur".tr,
          navigationPath: "mine",
        ),
        SidebarSubmenuModel(
          name: "Invité".tr,
          navigationPath: "gest",
        ),
      ],
    ),
    SidebarItemModel(
      // name: 'Email',
      name: l.S.current.buyCredits,
      iconPath: 'assets/images/sidebar_icons/shopping_basket.svg',
      navigationPath: '/pages/pricing',
    ),
    SidebarItemModel(
      //name: 'Projects',
      name: l.S.current.howtoGuides,
      iconPath: 'assets/images/sidebar_icons/assistant.svg',
      navigationPath: '/pages/faqs',
    ),
    SidebarItemModel(
      //name: 'Kanban',
      name: l.S.current.contactUs,
      iconPath: 'assets/images/sidebar_icons/support.svg',
      navigationPath: '/kanban',
    ),
  ];
}
