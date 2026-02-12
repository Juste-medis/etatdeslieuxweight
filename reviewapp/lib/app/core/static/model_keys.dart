// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mon_etatsdeslieux/app/core/services/offlineStorage.dart';
import 'package:mon_etatsdeslieux/app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:nb_utils/nb_utils.dart';

StreamSubscription? subscription;

void startInternetListening({bool forceRestart = false}) {
  if (kIsWeb) {
    Jks.isNetworkAvailable = true;
  }
  if (subscription != null) {
    if (!forceRestart) return;
    subscription!.cancel();
    subscription = null;
  }

  subscription = Connectivity().onConnectivityChanged.listen(
    (List<ConnectivityResult> result) {
      if (result.isNotEmpty && result.first != ConnectivityResult.none) {
        if (!Jks.isNetworkAvailable) {
          // if (Jks.isNetworkAvailable) return;
          Jks.isNetworkAvailable = true;
          OfflineStorageService.syncOfflineDatas();
        }
      } else {
        Jks.isNetworkAvailable = false;
      }
    },
    onError: (_) {
      Jks.isNetworkAvailable = false;
    },
    cancelOnError: false,
  );
}

void stopListening() {
  subscription?.cancel();
}

class CommonKeys {
  static String id = 'id';
  static String address = 'address';
  static String serviceId = 'service_id';
  static String jobId = 'offer_id';
  static String customerId = 'customer_id';
  static String handymanId = 'handyman_id';
  static String providerId = 'provider_id';
  static String bookingId = 'booking_id';
  static String date = 'date';
  static String status = 'status';
  static String dateTime = 'datetime';
}

class Jks {
  static dynamic Function() createAnswer = () async {};
  static dynamic Function() closeCall = () async {};
  static Future<void> Function() savereviewStep = () async {};
  static List<VoidCallback> overlayentriesClosers = [];
  static Map ldImages = {};

  static dynamic callApiForYou;
  static bool checkingAuth = false;
  static dynamic dowloadreviewName;
  static dynamic uploadFile;
  static dynamic onclickAddMedia;
  static dynamic reglerpayment;
  static dynamic wizardNextStep = () {};
  static dynamic items;
  static dynamic proc;

  static int idnotifications = 1;
  static bool? quietsavereview;
  static bool isNetworkAvailable = false;
  static bool isSyncingOfflineDatas = false;
  static String canEditReview = "canEditReview";
  static String canEditProccuration = "canEditProccuration";
  static Timer? typingTimer;
  static User? currentUser;
  static String thingsAfterDate = "";
  static bool updatafterClose = false;

  // static ProductDetails? product;

  static BuildContext? context;
  static Map? appSettings;
  static dynamic reviewState;
  static dynamic wizardState;
  static dynamic proccurationState;
  static dynamic paymentState;
  static AppLanguageProvider languageState = AppLanguageProvider();

  static List? imageUrl;
  static User currencUser = User();
  static Map? imagesIndexes = {};
  static Map remoteIds = {};
  static User? payingUser;
  static Map? griffes = {};
  static Map<String, GlobalKey<FormState>> tenantApprovals = {};
  static Map? pSp = {"content": null, "thingtype": null, "extension": null};
  static var temptoken = "";

  static void initPsp() {
    pSp = {"content": null, "thingtype": null, "extension": null};
  }

  static void initGriffes() {
    griffes = {};
  }
}

class UserKeys {
  static String firstName = 'firstName';
  static String lastName = 'lastName';
  static String userName = 'username';
  static String email = 'email';
  static String dob = 'user_DOB';
  static String about = 'about';
  static String interests = 'interests';
  static String gender = 'userGender';
  static String password = 'password';
  static String userType = 'type';
  static String contactNumber = 'phone';
  static String countryId = 'country_id';
  static String indicatif = 'indicatif';
  static String stateId = 'state_id';
  static String cityId = 'city_id';
  static String oldPassword = 'old_password';
  static String newPassword = 'new_password';
  static String profileImage = 'profile_image';
  static String playerId = 'player_id';
  static String uid = 'uid';
  static String id = 'id';
  static String loginType = 'login_type';
  static String accessToken = 'accessToken';
  static String country = 'country';
}
