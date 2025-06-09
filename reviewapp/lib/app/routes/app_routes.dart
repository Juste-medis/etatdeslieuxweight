// 📦 Package imports:
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/models/base_response_model.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/pages/authentication/otp_verification_view.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/author_inventory.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/counter_inventory.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/inventory_page_wrapper.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/key_inventory.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/piece_inventory.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/thing_inventory.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/welcome_procuration.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/_starter_wizard.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/procurations/procuration_wizard.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/complementary.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/inventory_of_counter.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/inventory_of_keys.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/inventory_of_piece.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/inventory_report.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/locataires_infos.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/sortan_locataire_address.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/wizards/starter/the_good.dart';
import 'package:jatai_etatsdeslieux/app/pages/review/pdf_review.dart';
import 'package:jatai_etatsdeslieux/app/pages/review/review_detail.dart';
import 'package:jatai_etatsdeslieux/app/pages/splash/dashboard_view.dart';
import 'package:jatai_etatsdeslieux/app/widgets/widgets.dart';

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
          return const NoTransitionPage(
            child: SplashView(),
          );
        },
      ),
      // Full Screen Pages
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
              final extra = state.extra as String?;
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
            path: '/thegood/:id',
            builder: (context, state) {
              final extra = state.extra as Review?;
              return TheGood(
                review: extra,
              );
            },
          ),
          GoRoute(
            path: '/srtoantlocataireaddress/:id',
            builder: (context, state) {
              final extra = state.extra as Review?;
              return LocataireSortantAddress(
                review: extra,
              );
            },
          ),
          GoRoute(
            path: '/complementary/:id',
            builder: (context, state) {
              final extra = state.extra as Review?;
              return Complementary(
                review: extra,
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

              return LesLocataires(
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
            path: '/preview/review/:id',
            builder: (context, state) {
              return ReviewPreview();
            },
          ),
          GoRoute(
            path: '/dashboard',
            redirect: (context, state) async {
              if (state.fullPath == '/dashboard') {
                return '/dashboard/ecommerce-admin';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'ecommerce-admin',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ECommerceAdminDashboardView(),
                ),
              ),
            ],
          ),

          // Widgets Routes
          GoRoute(
            path: '/widgets',
            redirect: (context, state) async {
              if (state.fullPath == '/widgets') {
                return '/widgets/general-widgets';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'general-widgets',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: GeneralWidgetsView(),
                ),
              ),
              GoRoute(
                path: 'chart-widgets',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: ChartWidgetsView(),
                ),
              ),
            ],
          ),

          //--------------Application Section--------------//
          GoRoute(
            path: '/calendar',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: CalendarView(),
            ),
          ),
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ChatView(),
            ),
          ),

          // Email Shell Routes
          GoRoute(
            path: '/email',
            redirect: (context, state) async {
              if (state.fullPath == '/email') {
                return '/email/inbox';
              }
              return null;
            },
            routes: [
              ShellRoute(
                navigatorKey: _emailShellNavigatorKey,
                pageBuilder: (context, state, child) {
                  return NoTransitionPage(
                    child: EmailView(child: child),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'inbox',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailInboxView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'starred',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailStarredView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'sent',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailSentView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'drafts',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailDraftsView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'spam',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailSpamView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'trash',
                    parentNavigatorKey: _emailShellNavigatorKey,
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailTrashView(),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':folder/details',
                    pageBuilder: (context, state) {
                      return const NoTransitionPage<void>(
                        child: EmailDetailsView(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          GoRoute(
            path: '/projects',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: ProjectsView(),
            ),
          ),
          GoRoute(
            path: '/kanban',
            pageBuilder: (context, state) => const NoTransitionPage<void>(
              child: KanbanView(),
            ),
          ),

          // E-Commerce Routes
          GoRoute(
            path: '/ecommerce',
            redirect: (context, state) async {
              if (state.fullPath == '/ecommerce') {
                return '/ecommerce/product-list';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: "product-list",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProductListView(),
                ),
              ),
              GoRoute(
                path: "product-details",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: ProductDetailsView(),
                ),
              ),
              GoRoute(
                path: "cart",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CartView(),
                ),
              ),
              GoRoute(
                path: "checkout",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: CheckoutView(),
                ),
              ),
            ],
          ),

          // POS Inventory Routes
          GoRoute(
            path: '/pos-inventory',
            redirect: (context, state) async {
              if (state.fullPath == '/pos-inventory') {
                return '/pos-inventory/sale';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: "sale",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSSaleView(),
                ),
              ),
              GoRoute(
                path: "sale-list",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSSaleListView(),
                ),
              ),
              GoRoute(
                path: "purchase",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSPurchaseView(),
                ),
              ),
              GoRoute(
                path: "purchase-list",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSPurchaseListView(),
                ),
              ),
              GoRoute(
                path: "product",
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: POSProductView(),
                ),
              ),
            ],
          ),

          // Open AI Routes
          GoRoute(
            path: '/open-ai',
            redirect: (context, state) async {
              if (state.fullPath == '/open-ai') {
                return '/open-ai/ai-writter';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'ai-writter',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiWriterView(),
                ),
              ),
              GoRoute(
                path: 'ai-image',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiImageView(),
                ),
              ),
              StatefulShellRoute.indexedStack(
                pageBuilder: (context, state, page) {
                  AIChatPageListener.initialize(page);
                  return NoTransitionPage(
                    child: AiChatView(page: page),
                  );
                },
                branches: [
                  StatefulShellBranch(
                    routes: [
                      GoRoute(
                        path: 'ai-chat',
                        pageBuilder: (context, state) => const NoTransitionPage(
                          child: AIChatDetailsView(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              GoRoute(
                path: 'ai-code',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiCodeView(),
                ),
              ),
              GoRoute(
                path: 'ai-voiceover',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: AiVoiceoverView(),
                ),
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
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: UserProfileView(),
                ),
              ),
            ],
          ),

          //--------------Application Section--------------//

          //--------------Tables & Forms--------------//
          GoRoute(
            path: '/tables',
            redirect: (context, state) async {
              if (state.fullPath == '/tables') {
                return '/tables/basic-table';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: 'basic-table',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: BasicTableView(),
                ),
              ),
              GoRoute(
                path: 'data-table',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: DataTableView(),
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
                path: 'gallery',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: GalleryView(),
                ),
              ),
              GoRoute(
                path: 'maps',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: MapsView(),
                ),
              ),
              GoRoute(
                path: 'pricing',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: PricingView(),
                ),
              ),
              GoRoute(
                path: 'tabs-and-pills',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: TabsNPillsView(),
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
              GoRoute(
                path: 'terms-conditions',
                pageBuilder: (context, state) => const NoTransitionPage<void>(
                  child: TermsConditionView(),
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
