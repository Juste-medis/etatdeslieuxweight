import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/helpers.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/review.dart';
import 'package:mon_etatsdeslieux/app/pages/pages.dart';
import 'package:mon_etatsdeslieux/app/providers/_theme_provider.dart';
import 'package:mon_etatsdeslieux/app/widgets/dialogs/confirm_dialog.dart';
import 'package:mon_etatsdeslieux/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FirebaseService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static String? _fcmToken;
  static Function(Map<String, dynamic>)? onNotificationClicked;

  // Getter pour le token
  static String? get fcmToken => _fcmToken;

  // curl -X POST https://etatdeslieux.adidomedis.cloud/api/notification/send-notification \
  //   -H "Content-Type: application/json" \
  //   -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2ODIxNDU3OTQ1MjQ1ZDgyMWY1YWMxNGQiLCJlbWFpbCI6Im1lZGlzYWRpZG9AZ21haWwuY29tIiwibGV2ZWwiOiJzdGFuZGFyZCIsImZpcnN0TmFtZSI6IkhhcnRqaWlqIiwibGFzdE5hbWUiOiJHQVVUSElFUiIsImZ1bGxOYW1lIjoiSGFydGppaWogR0FVVEhJRVIiLCJwaG9uZSI6Ijg4ODg4ODg4ODgiLCJjb3VudHJ5X2NvZGUiOiIrMzMiLCJpc0Jsb2NrZWQiOnRydWUsImxhc3RPbmxpbmUiOm51bGwsInVzZXJfRE9CIjpudWxsLCJmYXZvcml0ZXMiOltdLCJpbWFnZVVybCI6IjE3NDkwMzkzMTc1NjUteWRjbTE4MGVsel8xNzI5MDYwODgzOTYyXzE3MjU2ODg2MjMxMDMuSlBFRyIsInBsYWNlT2ZCaXJ0aCI6IkFCT01FWSIsImFkZHJlc3MiOiJMeW9uLCBMeW9uLCBBdXZlcmduZS1SaMO0bmUtQWxwZXMsIEZyYW5jZSIsImdlbmRlciI6IkZlbWFsZSIsIm1ldGEiOnt9LCJhYm91dCI6bnVsbCwidHlwZSI6Im93bmVyIiwiaXRlbWFjY2VzcyI6bnVsbCwidmVyaWZpZWRBdCI6IjIwMjUtMDUtMTJUMDA6NTc6NTQuNTQ1WiIsImNyZWF0ZWRBdCI6IjIwMjUtMDUtMTJUMDA6NDg6NTcuMzM2WiIsImJhbGFuY2VzIjp7InByb2N1cmVtZW50IjoxNSwic2ltcGxlIjoyMywib3RoZXIiOnt9fSwiaWF0IjoxNzU5NzA5MDI4LCJleHAiOjE3NjQ4OTMwMjh9.xPu_yh2SGErSOLFvxtLws9pI1XCvGih0k-PKrgz_t6M" \
  //   -d '{
  //     "userId": "6821457945245d821f5ac14d",
  //     "title": "Test Notification",
  //     "body": "Ceci est un test!",
  //     "data": {"screen": "home"}
  //   }'

  // Initialiser Firebase et FCM
  static Future<void> initialize() async {
    print('🟡 Initialisation de Firebase...');
    if (_fcmToken != null) {
      return;
    }
    try {
      // Initialiser Firebase
      await Firebase.initializeApp();
      print('🟢 Firebase initialisé avec succès');

      // Configuration des notifications locales
      await _setupLocalNotifications();

      // Demander les permissions
      await _requestPermissions();

      // Récupérer le token FCM
      await _getFCMToken();

      // Configurer les écouteurs de messages
      _setupMessageListeners();

      print('🟢 Service FCM initialisé avec succès');

      onNotificationClicked = (Map<String, dynamic> data) async {
        print('📲 Notification cliquée avec data: $data');

        if (data["isRead"] == false) {
          await markNotifAsRead({
            "timestamp": data["timestamp"],
            "isRead": true,
          }).then((value) {}).catchError((e) {
            my_inspect(e);
          });
        }
        if (data['link'] != null) {
          commonLaunchUrl(
            data['link'],
            launchMode: LaunchMode.inAppBrowserView,
          );
        } else {
          switch (data['type']) {
            case 'procuration_signed':
            case 'procuration_created':
              if (data['procurationId'] != null) {
                await FullScreenLoadingDialog(
                  onInit: () async {
                    await getUnityPrrocuration(data['procurationId'].toString())
                        .then((res) async {
                          if (res.status == true) {
                            var proccuration = Procuration.fromJson(
                              res.data as Map<String, dynamic>,
                            );
                            proccuration.source = "notification";
                            seeProcuration(
                              proccuration: proccuration,
                              context: Jks.context!,
                            );
                          }
                        })
                        .catchError((e) {
                          my_inspect(e);
                          toast(e.toString());
                        });
                    return true;
                  },
                ).show(
                  Jks.context!,
                  onOk: () {
                    Jks.context!.popRoute();
                  },
                );
              }
              break;
            case 'review_ready':
              if (data['reviewId'] != null) {
                await FullScreenLoadingDialog(
                  onInit: () async {
                    await getUnityReview(data['reviewId'].toString())
                        .then((res) async {
                          if (res.status == true) {
                            if (res.data['copyOptions'] != null &&
                                res.data['copyOptions'] != false) {
                              res.data['copyOptions'] = false;
                            }
                            var review = Review.fromJson(
                              res.data as Map<String, dynamic>,
                            );
                            review.source = "notification";
                            final wizardState = Jks.context!
                                .read<AppThemeProvider>();
                            wizardState.prefillReview(review);
                            Jks.context!.push(
                              '/review/${review.id}',
                              extra: review,
                            );
                          }
                        })
                        .catchError((e) {
                          my_inspect(e);
                          toast(e.toString());
                        });
                    return true;
                  },
                ).show(
                  Jks.context!,
                  onOk: () {
                    Jks.context!.popRoute();
                  },
                );
              }
              break;
            case 'message':
            case 'inventory':
              // if (data.data?['inventoryId'] != null) {
              //   context.pushRoute(InventoryDetailsRoute(
              //       inventoryId: data
              //           .data!['inventoryId']
              //           .toString()));
              // }
              break;
            default:
              break;
          }
        }
      };
    } catch (e) {
      print('🔴 Erreur initialisation Firebase: $e');
    }
  }

  // Configuration des notifications locales
  static Future<void> _setupLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings);

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Gérer le clic sur la notification
        if (response.payload != null) {
          final payload = _parsePayload(response.payload!);
          onNotificationClicked?.call(payload);
        }
      },
    );

    // Créer un canal de notification
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Notifications Importantes',
      description: 'Ce canal est utilisé pour les notifications importantes',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // Demander les permissions
  static Future<void> _requestPermissions() async {
    try {
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('🔔 Permissions de notification:');
      print(
        '   - Alert: ${settings.authorizationStatus == AuthorizationStatus.authorized}',
      );
      print('   - Badge: ${settings.badge}');
      print('   - Sound: ${settings.sound}');
    } catch (e) {
      print('🔴 Erreur permissions: $e');
    }
  }

  // Récupérer le token FCM
  static Future<void> _getFCMToken() async {
    // Ensure a fresh token for the new session
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (_) {}

    try {
      _fcmToken = await _messaging.getToken();

      if (_fcmToken != null) {
        print('🟢 Token FCM récupéré: $_fcmToken');

        await _recreateNotificationChannel(userId: appStore.iid);
        // Envoyer le token au serveur
        await registerFCMToken(_fcmToken!);

        // Écouter les changements de token
        _messaging.onTokenRefresh.listen((newToken) {
          print('🔄 Token FCM actualisé: $newToken');
          _fcmToken = newToken;
          registerFCMToken(newToken);
        });
      } else {
        print('🔴 Aucun token FCM récupéré');
      }
    } catch (e) {
      print('🔴 Erreur récupération token FCM: $e');
    }
  }

  // Configurer les écouteurs de messages
  static void _setupMessageListeners() {
    // Message reçu en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📱 Message reçu en foreground:');
      print('   - Titre: ${message.notification?.title}');
      print('   - Corps: ${message.notification?.body}');
      print('   - Data: ${message.data}');
      my_inspect(message);

      _showLocalNotification(message);
      Jks.languageState.showAppNotification(
        message: message.notification?.body ?? '',
        title: message.notification?.title ?? '',
        onTap: () {
          onNotificationClicked?.call(message.data);
        },
      );
    });

    // Message ouvert depuis le background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 Notification cliquée: ${message.data}');
      onNotificationClicked?.call(message.data);
    });

    // Gérer les messages lorsque l'app est terminée
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        print('📲 Message initial: ${message.data}');
        onNotificationClicked?.call(message.data);
      }
    });
  }

  // Formater le payload pour la notification
  static String _formatPayload(Map<String, dynamic> data) {
    return data.entries.map((e) => '${e.key}=${e.value}').join('&');
  }

  // Parser le payload de la notification
  static Map<String, dynamic> _parsePayload(String payload) {
    final Map<String, dynamic> result = {};
    final pairs = payload.split('&');

    for (final pair in pairs) {
      final keyValue = pair.split('=');
      if (keyValue.length == 2) {
        result[keyValue[0]] = keyValue[1];
      }
    }

    return result;
  }

  // Souscrire à un topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('🟢 Souscrit au topic: $topic');
    } catch (e) {
      print('🔴 Erreur subscription topic: $e');
    }
  }

  // Se désabonner d'un topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('🟢 Désabonné du topic: $topic');
    } catch (e) {
      print('🔴 Erreur désabonnement topic: $e');
    }
  }

  static Future<void> onUserLogout() async {
    try {
      if (_fcmToken != null) {
        try {
          await unregisterFCMToken(
            _fcmToken!,
          ); // Implement this on your backend
        } catch (e) {
          print('⚠️ Erreur unregisterFCMToken: $e');
        }
      }
      try {
        await FirebaseMessaging.instance.deleteToken();
        print('🗑️ Token FCM supprimé');
      } catch (e) {
        print('⚠️ Erreur suppression token: $e');
      }

      await FirebaseMessaging.instance.setAutoInitEnabled(false);

      await _notifications.cancelAll();
      await _recreateNotificationChannel(userId: appStore.iid);

      _fcmToken = null;
      onNotificationClicked = null;
      print('✅ FCM nettoyé pour la déconnexion');
    } catch (e) {
      print('❌ Erreur nettoyage FCM: $e');
    }
  }

  static Future<void> _recreateNotificationChannel({String? userId}) async {
    try {
      final channelId = userId != null
          ? 'channel_${userId}_${DateTime.now().millisecondsSinceEpoch}'
          : 'high_importance_channel';

      AndroidNotificationChannel channel = AndroidNotificationChannel(
        channelId,
        'Notifications Importantes',
        description: 'Ce canal est utilisé pour les notifications importantes',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.deleteNotificationChannel(channel.id);

      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(channel);

      print('🔄 Canal de notification recréé: $channelId');
    } catch (e) {
      print('⚠️ Erreur recréation canal: $e');
    }
  }

  static Future<String?> _getCurrentUserId() async {
    return appStore.iid;
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      // Vérifier si la notification est pour l'utilisateur actuel
      final currentUserId = await _getCurrentUserId();
      final messageUserId = message.data['toUser'];

      // FIX: compare with currentUserId (not email)
      if (currentUserId != null &&
          messageUserId != null &&
          messageUserId != currentUserId) {
        print('🚫 Notification ignorée - destinée à un autre utilisateur');
        return;
      }

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'high_importance_channel',
            'Notifications Importantes',
            channelDescription: 'Canal pour les notifications importantes',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            sound: RawResourceAndroidNotificationSound('notification'),
            colorized: true,
          );

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        message.notification?.title ?? 'Nouvelle notification',
        message.notification?.body ?? '',
        const NotificationDetails(android: androidDetails),
        payload: _formatPayload(message.data),
      );

      print('🔔 Notification locale affichée');
    } catch (e) {
      print('🔴 Erreur affichage notification: $e');
    }
  }
}
