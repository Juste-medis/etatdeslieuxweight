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
      name: "Transactions".tr,
      iconPath: 'assets/images/sidebar_icons/transaction.svg',
      navigationPath: '/transactions/home',
    ),
    SidebarItemModel(
      name: "Etats des lieux".tr,
      iconPath: 'assets/images/sidebar_icons/copy-check.svg',
      navigationPath: '/reviews/all',
    ),
    SidebarItemModel(
      name: "Procurations".tr,
      iconPath: 'assets/images/sidebar_icons/contact_mail.svg',
      navigationPath: '/proccurations',
    ),
    SidebarItemModel(
      name: "Coupons".tr,
      iconPath: 'assets/images/sidebar_icons/coupon-icon.svg',
      navigationPath: '/transactions/coupons',
    ),
    SidebarItemModel(
      name: "Utilisateurs".tr,
      iconPath: 'assets/images/sidebar_icons/users-group.svg',
      navigationPath: '/users/user-list',
    ),
    // SidebarItemModel(
    //   name: l.S.current.users,
    //   iconPath: 'assets/images/sidebar_icons/users-group.svg',
    //   sidebarItemType: SidebarItemType.submenu,
    //   navigationPath: '/users',
    //   submenus: [
    //     SidebarSubmenuModel(
    //       //name: "Users List",
    //       name: l.S.current.usersList,
    //       navigationPath: "user-list",
    //     ),
    //     SidebarSubmenuModel(
    //       name: "Bailleurs".tr,
    //       navigationPath: "author-list",
    //     ),
    //     SidebarSubmenuModel(
    //       name: "Locataires".tr,
    //       navigationPath: "author-list",
    //     ),
    //   ],
    // ),
    SidebarItemModel(
      name: "Paramètres".tr,
      iconPath: 'assets/images/sidebar_icons/setting-icon.svg',
      navigationPath: '/pages/settings',
    ),
    SidebarItemModel(
      name: l.S.current.howtoGuides,
      iconPath: 'assets/images/sidebar_icons/assistant.svg',
      navigationPath: '/pages/faqs',
    ),
  ];
}
