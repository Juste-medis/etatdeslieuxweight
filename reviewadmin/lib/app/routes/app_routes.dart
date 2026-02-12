// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/models/base_response_model.dart';
import 'package:jatai_etadmin/app/models/review.dart';
import 'package:jatai_etadmin/app/pages/authentication/otp_verification_view.dart';
import 'package:jatai_etadmin/app/pages/authentication/resset_pass.dart';
import 'package:jatai_etadmin/app/pages/coupons/coupon_view.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/author_inventory.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/counter_inventory.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/inventory_page_wrapper.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/key_inventory.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/piece_inventory.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/thing_inventory.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/magic/_magic_wizard.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/date_of_review.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/welcome_procuration.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/_starter_wizard.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/procuration_wizard.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/complementary.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/inventory_of_counter.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/inventory_of_keys.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/inventory_of_piece.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/inventory_report.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/locataires_infos.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/sortan_locataire_address.dart';
import 'package:jatai_etadmin/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/the_good.dart';
import 'package:jatai_etadmin/app/pages/proccuration/pdf_proccuration.dart';
import 'package:jatai_etadmin/app/pages/proccuration/proccuration_detail.dart';
import 'package:jatai_etadmin/app/pages/proccurationslist/procuration_list_view.dart';
import 'package:jatai_etadmin/app/pages/purchase_list/pos_purchase_list_view.dart';
import 'package:jatai_etadmin/app/pages/review/pdf_review.dart';
import 'package:jatai_etadmin/app/pages/review/review_detail.dart';
import 'package:jatai_etadmin/app/pages/reviewlist/review_list_view.dart';
import 'package:jatai_etadmin/app/pages/splash/_splash_screen.dart';
import 'package:jatai_etadmin/app/pages/statistics_dashboard/main_dashboard.dart';
import 'package:jatai_etadmin/app/widgets/widgets.dart';

// 🌎 Project imports:
import '../pages/pages.dart';
import "route_guard.dart";

abstract class AcnooAppRoutes {
  //--------------Navigator Keys--------------//
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _emailShellNavigatorKey = GlobalKey<NavigatorState>();
  //--------------Navigator Keys--------------//

  static const _initialPath = '/';
  static final routerConfig = GoRouter(
    navigatorKey: GlobalKey<NavigatorState>(),
    initialLocation: _initialPath,
    redirect: RouteGuard.redirect, // Add the guard
    routes: [
      // Landing Route Handler
      GoRoute(
        path: _initialPath,
        pageBuilder: (context, state) {
          Jks.context = context;
          return const NoTransitionPage(child: SplashView());
        },
      ),
      GoRoute(
        path: '/resetpassword',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final queryParams = state.uri.queryParameters;

          String? extractedEmail;
          String? extractedOtp;

          if (state.uri.queryParameters.containsKey('email')) {
            final datas = "${queryParams['email']}".split("_102030_82");
            extractedEmail = datas.isNotEmpty ? datas[0] : extra?['email'];
            extractedOtp = datas.length > 1 ? datas[1] : null;
          } else {
            extractedEmail = extra?['email'];
            extractedOtp = extra?['otp'];
          }
          return NoTransitionPage(
              child: RessetPassView(
            otp: extractedOtp,
            email: extractedEmail,
          ));
        },
      ),
      GoRoute(
        path: '/authentication/signup',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SignupView(),
        ),
      ),
      GoRoute(
        path: '/authentication/signin',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SigninView(),
        ),
      ),
      GoRoute(
        path: '/otp',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;

          Jks.context = context;
          return NoTransitionPage(
            child: OtpVerificationView(
              email: extra?['email'] as String?,
              userId: extra?['userId'] as String?,
              password: extra?['password'] as String?,
            ),
          );
        },
      ),
      GoRoute(
        path: '/loading',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return LoadingScreen(
            message: extra?['message'] as String?,
          );
        },
      ),
      // Global Shell Route
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(
            child: ShellRouteWrapper(child: child),
          );
        },
        routes: [
          GoRoute(
            path: '/startreview',
            builder: (context, state) {
              final extra = state.extra as dynamic;
              return WizardForm(
                type: extra,
              );
            },
          ),
          GoRoute(
            path: '/startprocuration',
            builder: (context, state) {
              return const ProcurationWelcome();
            },
          ),
          GoRoute(
            path: '/createprocuration',
            builder: (context, state) {
              return const ProcurationFormWizard();
            },
          ),
          GoRoute(
            path: '/piece-inventory',
            builder: (context, state) {
              final extra = state.extra as int?;
              return InventoryPageWraper(
                child: PieceInventory(
                  piece: extra,
                ),
              );
            },
          ),
          GoRoute(
            path: '/review/:id',
            builder: (context, state) {
              final extra = state.extra as Review;
              return ReviewDashboard(
                review: extra,
              );
            },
          ),
          GoRoute(
            path: '/proccuration/:id',
            builder: (context, state) {
              final extra = state.extra as Procuration;
              return ProccurationDashboard(
                proccuration: extra,
              );
            },
          ),
          GoRoute(
            path: '/thegood/:id',
            builder: (context, state) {
              final extra = state.extra as Review?;
              return TheGood(
                thereview: extra,
              );
            },
          ),
          GoRoute(
            path: '/srtoantlocataireaddress/:id',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return LocataireSortantAddress(
                review: extra!["review"],
                proccuration: extra["procuration"],
              );
            },
          ),
          GoRoute(
            path: '/entrydateacces/:id',
            builder: (context, state) {
              return DateOfEtatDesLieux();
            },
          ),
          GoRoute(
            path: '/complementary/:id',
            builder: (context, state) {
              final extra = state.extra as Review?;
              return Complementary(
                thereview: extra,
              );
            },
          ),
          GoRoute(
            path: '/reviewpieces/:id',
            builder: (context, state) {
              final extra = state.extra as Review?;
              return InventoryOfRooms(
                review: extra,
              );
            },
          ),
          GoRoute(
            path: '/comptors/:id',
            builder: (context, state) {
              final extra = state.extra as Review?;
              return InventoryOfCounter(
                review: extra,
              );
            },
          ),
          GoRoute(
            path: '/keysreview/:id',
            builder: (context, state) {
              final extra = state.extra as Review?;
              return InventoryOfKeys(
                review: extra,
              );
            },
          ),

          GoRoute(
            path: '/thing-inventory',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;

              return InventoryPageWraper(
                child: ThingInventory(
                  thing: extra,
                ),
              );
            },
          ),
          GoRoute(
            path: '/magic-wizard',
            builder: (context, state) {
              final piece = state.extra as int?;
              return InventoryPageWraper(
                child: MagicWizard(
                  piece: piece,
                ),
              );
            },
          ),
          GoRoute(
            path: '/counter-inventory',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;

              return InventoryPageWraper(
                  child: CounterInventory(
                thing: extra,
              ));
            },
          ),

          GoRoute(
            path: '/signataire-inventory/:id',
            builder: (context, state) {
              final extra = state.extra as Review?;

              return InventoryReport(
                review: extra,
              );
            },
          ),

          GoRoute(
            path: '/signataire/locataire-inventory/:id',
            builder: (context, state) {
              final extra = state.extra as Review?;

              return LocatairesInfos(
                review: extra,
              );
            },
          ),
          GoRoute(
            path: '/key-inventory',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;

              return InventoryPageWraper(
                  child: ClesInventory(
                thing: extra,
              ));
            },
          ),
          GoRoute(
            path: '/inventoryauthor-inventory/:id',
            builder: (context, state) {
              final extra = state.extra as InventoryAuthorParam;

              return AuthorInventory(
                piece: extra,
              );
            },
          ),
          GoRoute(
            path: '/preview/proccuration/:id',
            builder: (context, state) {
              return ProccurationPreview();
            },
          ),
          GoRoute(
            path: '/preview/review/:id',
            builder: (context, state) {
              return ReviewPreview();
            },
          ),
          GoRoute(
            path: '/dashboard',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard') {
                return '/dashboard/home';
              }
              return "/dashboard/home";
            },
            routes: [
              GoRoute(
                path: 'home',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: MainDashboard()),
              ),
            ],
          ),
          GoRoute(
            path: '/proccurations',
            pageBuilder: (context, state) =>
                const NoTransitionPage<void>(child: ListProccuration()),
            routes: [
              GoRoute(
                path: "all",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ListProccuration(
                    status: "all",
                  ),
                ),
              ),
              GoRoute(
                path: "mine",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ListProccuration(
                    status: "draft",
                  ),
                ),
              ),
              GoRoute(
                path: "gest",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ListProccuration(
                    status: "gest",
                  ),
                ),
              ),
            ],
          ),

          // Email Shell Routes

          GoRoute(
            path: '/buyCredits',
            redirect: (context, state) async {
              if (state.fullPath == '/buyCredits') {
                return '/buyCredits/home';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'home',
                pageBuilder: (context, state) {
                  return NoTransitionPage<void>(
                    child: PricingView(),
                  );
                },
              ),
            ],
          ),

          // E-Commerce Routes
          GoRoute(
            path: '/reviews',
            redirect: (context, state) async {
              if (state.fullPath == '/reviews') {
                return '/ecommerce/product-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: "all",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashBoardReviewList(
                    status: "all",
                  ),
                ),
              ),
              GoRoute(
                path: "inProgress",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashBoardReviewList(
                    status: "draft",
                  ),
                ),
              ),
              GoRoute(
                path: "finished",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: DashBoardReviewList(
                    status: "completed",
                  ),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/transactions',
            redirect: (context, state) async {
              if (state.fullPath == '/transactions') {
                return '/transactions/home';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'home',
                pageBuilder: (context, state) {
                  return const NoTransitionPage<void>(
                      child: POSPurchaseListView());
                },
              ),
              GoRoute(
                path: 'coupons',
                pageBuilder: (context, state) {
                  return const NoTransitionPage<void>(child: POSCouponView());
                },
              ),
              GoRoute(
                path: 'coupons/codeusage',
                pageBuilder: (context, state) {
                  final code = state.extra as String?;
                  return NoTransitionPage<void>(
                      child: POSPurchaseListView(
                    couponCode: code,
                  ));
                },
              ),
            ],
          ),

          // Users Route
          GoRoute(
            path: '/users',
            redirect: (context, state) async {
              if (state.fullPath == '/users') {
                return '/users/user-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'user-list',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: UsersListView(),
                ),
              ),
              GoRoute(
                path: 'user-grid',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: UsersGridView(),
                ),
              ),
              GoRoute(
                path: 'user-profile',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: UserProfileView(),
                ),
              ),
            ],
          ),

          //--------------Pages--------------//
          GoRoute(
            path: '/pages',
            redirect: (context, state) async {
              if (state.fullPath == '/pages') {
                return '/pages/gallery';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'pricing',
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  child: PricingView(),
                ),
              ),
              GoRoute(
                path: 'settings',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: SettingsView(),
                ),
              ),
              GoRoute(
                path: '404',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: NotFoundView(),
                ),
              ),
              GoRoute(
                path: 'faqs',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: FaqView(),
                ),
              ),
              GoRoute(
                path: 'privacy-policy',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: PrivacyPolicyView(),
                ),
              ),
            ],
          ),
          //--------------Pages--------------//
        ],
      ),
    ],
    errorPageBuilder: (context, state) => const NoTransitionPage(
      child: NotFoundView(),
    ),
  );
}
