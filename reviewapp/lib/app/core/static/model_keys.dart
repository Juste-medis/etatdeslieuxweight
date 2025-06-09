// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/network/rest_apis.dart';
import 'package:jatai_etatsdeslieux/app/models/_message_model.dart';
import 'package:jatai_etatsdeslieux/app/models/models.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart' as nb_utils;

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

class ServiceTypesKeys {
  static String reservation = 'reservation';
  static String payable = 'payable';
  static String contact = 'contact';
}

class Jks {
  Future<bool> netChecker() async {
    // return kReleaseMode ? await isNetworkAvailable() : true;
    return true;
  }

  static Future<User?> get_current_user() async {
    int? userId = nb_utils.getIntAsync(USER_ID, defaultValue: 0);
    if (userId != 0) {
      User res = await getUser(userId: '$userId');

      if (res.id != null) {
        return res;
      }
    }
    return null;
  }

  static dynamic Function() update_current_user = () async {
    int? userId = nb_utils.getIntAsync(USER_ID, defaultValue: 0);
    if (userId != 0) {
      User res = await getUser(userId: '$userId');

      if (res.id != null) {
        return res;
      }
    }
    return null;
  };

  static dynamic Function() createAnswer = () async {};
  static dynamic Function() closeCall = () async {};
  static Future<void> Function() savereviewStep = () async {};
  static List<VoidCallback> overlayentriesClosers = [];

  static dynamic callApiForYou;
  static dynamic source;
  static dynamic uploadFile;
  static dynamic onclickAddMedia;
  static dynamic items;
  static int idnotifications = 1;
  static bool? quietsavereview;
  static String canEditReview = "canEditReview";
  static Timer? typingTimer;
  static User? currentUser;
  static Room? callinlingRoom;
  // static ProductDetails? product;

  static BuildContext? context;
  static dynamic reviewState;
  static List? imageUrl;
  static User currencUser = User();
  static Map? imagesIndexes = {};
  static Map? toastcolor = {};
  static User? payingUser;
  static Map? pSp = {
    "procuationspk": false,
    "content": null,
    "thingtype": null,
  };
  static var temptoken = "";

  static var socket;
  static void initPsp() {
    pSp = {
      "procuationspk": false,
      "content": null,
      "thingtype": null,
    };
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

class BookingServiceKeys {
  static String description = 'description';
  static String couponId = 'coupon_id';
  static String date = 'date';
  static String totalAmount = 'total_amount';
}

class CouponKeys {
  static String code = 'code';
  static String discount = 'discount';
  static String discountType = 'discount_type';
  static String expireDate = 'expire_date';
}

class PubsTypeKeys {
  static const String joboffer = 'joboffer';
  static const String provider = 'provider';
  static const String service = 'service';
}

class BookService {
  static String amount = 'amount';
  static String totalAmount = 'total_amount';
  static String quantity = 'quantity';
  static String bookingAddressId = 'booking_address_id';
}

class BookingStatusKeys {
  static String pending = 'pending';
  static String accept = 'accept';
  static String onGoing = 'on_going';
  static String inProgress = 'in_progress';
  static String hold = 'hold';
  static String rejected = 'rejected';
  static String failed = 'failed';
  static String complete = 'completed';
  static String cancelled = 'cancelled';
}

class BookingUpdateKeys {
  static String reason = 'reason';
  static String startAt = 'start_at';
  static String endAt = 'end_at';
  static String date = 'date';

  static String durationDiff = 'duration_diff';
}

class NotificationKey {
  static String type = 'type';
  static String page = 'page';
}

class CurrentLocationKey {
  static String latitude = 'latitude';
  static String longitude = 'longitude';
}
