import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/network/network_utils.dart';
import 'package:mon_etatsdeslieux/app/core/services/firebase_service.dart';
import 'package:mon_etatsdeslieux/app/core/services/offlineStorage.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/models/_plan.dart';
import 'package:mon_etatsdeslieux/app/models/_transaction.dart';
import 'package:mon_etatsdeslieux/app/models/base_response_model.dart';
import 'package:mon_etatsdeslieux/app/models/login_model.dart';
import 'package:mon_etatsdeslieux/app/models/models.dart';
import 'package:mon_etatsdeslieux/app/models/review.dart';
import 'package:mon_etatsdeslieux/main.dart';
import 'package:nb_utils/nb_utils.dart' hide isNetworkAvailable;
import 'package:go_router/go_router.dart';

//region Auth Api
Future<LoginResponse> createUser(Map request) async {
  return LoginResponse.fromJson(
    await (handleResponse(
      await buildHttpResponse(
        'signup',
        request: request,
        method: HttpMethod.POST,
      ),
    )),
  );
}

Future<User> getUser({String? userId = "0"}) async {
  return User.fromJson(
    (await handleResponse(
      await buildHttpResponse(
        'getuser?id=$userId',
        request: {"id": userId},
        method: HttpMethod.POST,
      ),
    ))['data'],
  );
}

Future<BaseResponseModel> getappsettings() async {
  return BaseResponseModel.fromJson(
    (await handleResponse(
      await buildHttpResponse('getappsettings', method: HttpMethod.GET),
    ))['data'],
  );
}

Future<LoginResponse> loginUser(
  Map request, {
  bool isSocialLogin = false,
}) async {
  LoginResponse res = LoginResponse.fromJson(
    await handleResponse(
      await buildHttpResponse(
        isSocialLogin ? 'social-login' : 'signin',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
  if (!isSocialLogin) await appStore.setLoginType(LOGIN_TYPE_USER);

  return res;
}

Future<BaseResponseModel> createprocuration(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/owner/procurarion',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> createreview(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/createreview',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> magicanalyse(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/magicanalyse',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> updatereview(id, Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/updatereview/$id',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> updateprocurarion(String id, Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/owner/updateprocurarion/$id',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> removeProcuration(String id, Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/owner/deleteprocurarion/$id',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> removeReview(String id, Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/owner/deletereview/$id',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> deleteReview(id) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/deleteReview/$id',
        request: {},
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> previwage(id, Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/preview-review/$id',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> proviwage(id, Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/preview-proccuration/$id',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> createTestPaymentSheet(Map request) async {
  var requestable = {"email": appStore.userEmail.validate(), ...request};

  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'stripe/payment-sheet',
        request: requestable,
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> createPaymentLink(Map request) async {
  var requestable = {"email": appStore.userEmail.validate(), ...request};

  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'stripe/create-payment-link',
        request: requestable,
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> applycouponcode(Map request) async {
  var requestable = {"email": appStore.userEmail.validate(), ...request};

  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'coupon/apply',
        request: requestable,
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> checkPaymentSheet(Map request) async {
  var requestable = {"email": appStore.userEmail.validate(), ...request};

  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'stripe/check-payment',
        request: requestable,
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<PaginateBaseResponseModel<Plan>> getplans({
  int? page,
  String? limit,
  Map? filter,
}) async {
  try {
    String filterQuery = filter != null
        ? '&filter=${Uri.encodeQueryComponent(jsonEncode(filter))}'
        : '';
    var response = await buildHttpResponse(
      'plans?page=$page&limit=$limit$filterQuery',
      method: HttpMethod.GET,
    );
    var handledResponse = await handleResponse(response);
    return PaginateBaseResponseModel<Plan>.fromJson(
      handledResponse,
      Plan.fromJson,
    );
  } catch (e) {
    rethrow; // Or return a default/fallback response
  }
}

Future<BaseResponseModel> griffeprocuration(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/owner/griffeprocurarion',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> useacredit(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'use/credit',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> grifferefiew(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/griffereview',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );

  return res;
}

Future<BaseResponseModel> verifyCredential(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'auth/code',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
  return res;
}

Future<BaseResponseModel> verifyCode(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'verifyotp',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
  return res;
}

Future<BaseResponseModel> resendOtpCode(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'resendOtpCode',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
  return res;
}

Future<BaseResponseModel> sendMessageToSupport(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'sendMessageToSupport',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
  return res;
}

Future<BaseResponseModel> forgotPassword(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'forgotPassword',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
  return res;
}

Future<BaseResponseModel> ratethepost(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/post/rate',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
  return res;
}

Future<BaseResponseModel> likeunlike(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'post/likeunlike',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
  return res;
}

Future<BaseResponseModel> havepurchased(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'payements/havepurchased',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
  return res;
}

Future<BaseResponseModel> changeUserPassword(Map request) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'auth/change',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
}

//region Review Api
Future<LoginResponse> edituser(Map request) async {
  return LoginResponse.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'user/edit',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<LoginResponse> editsettings(Map request) async {
  return LoginResponse.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/user/setting',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> getplaces(Map request) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'map/search?city=${request["city"]}',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> reverseplace(Map request) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'map/reverse?lat=${request["lat"]}&lon=${request["lon"]}',
        request: request,
        method: HttpMethod.GET,
      ),
    ),
  );
}

Future<BaseResponseModel> updateImages(Map request) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/user/updateImages',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> deleteImages(String path, Map request, id) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        '/updateImages/$path/$id',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> postCall(Map request) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'meeting/call',
        request: request,
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> readMessage(Map request) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        request: request,
        'room/read',
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> markNotifAsRead(Map request) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        request: request,
        'notification/update',
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> istyping(Map request) async {
  try {
    return BaseResponseModel.fromJson(
      await handleResponse(
        await buildHttpResponse(
          request: request,
          'typing',
          method: HttpMethod.POST,
        ),
      ),
    );
  } catch (e) {
    return BaseResponseModel.fromJson({});
  }
}

Future<BaseResponseModel> postofferCandidates(Map request) async {
  try {
    return BaseResponseModel.fromJson(
      await handleResponse(
        await buildHttpResponse(
          request: request,
          'offerCandidates',
          method: HttpMethod.POST,
        ),
      ),
    );
  } catch (e) {
    inspect(e);
    return BaseResponseModel.fromJson({});
  }
}

Future<BaseResponseModel> fetchRanking() async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse('leadboard', method: HttpMethod.GET),
    ),
  );
}

Future<BaseResponseModel> fetchSecring() async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse('orders', method: HttpMethod.GET),
    ),
  );
}

Future<BaseResponseModel> getmynotifications({
  int? userId = 0,
  String? page = "",
}) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'notifications?cursor=$page',
        method: HttpMethod.GET,
      ),
    ),
  );
}

Future<BaseResponseModel> getmyNewnotifications({
  int? userId = 0,
  String? lastDate = "",
}) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        'notifications/new?lastDate=$lastDate',
        method: HttpMethod.GET,
      ),
    ),
  );
}

Future<PaginateBaseResponseModel<Review>> getreviews({
  int? page,
  String? limit,
  Map? filter,
}) async {
  try {
    String filterQuery = filter != null
        ? '&filter=${Uri.encodeQueryComponent(jsonEncode(filter))}'
        : '';
    var response = await buildHttpResponse(
      'getreviews?page=$page&limit=$limit$filterQuery',
      method: HttpMethod.GET,
    );
    var handledResponse = await handleResponse(response);
    return PaginateBaseResponseModel<Review>.fromJson(
      handledResponse,
      Review.fromJson,
    );
  } catch (e) {
    rethrow; // Or return a default/fallback response
  }
}

Future<PaginateBaseResponseModel<TransactionModel>> getransactions({
  int? page,
  String? limit,
  Map? filter,
}) async {
  try {
    String filterQuery = filter != null
        ? '&filter=${Uri.encodeQueryComponent(jsonEncode(filter))}'
        : '';
    var response = await buildHttpResponse(
      'getransactions?page=$page&limit=$limit$filterQuery',
      method: HttpMethod.GET,
    );
    var handledResponse = await handleResponse(response);
    return PaginateBaseResponseModel<TransactionModel>.fromJson(
      handledResponse,
      TransactionModel.fromJson,
    );
  } catch (e) {
    rethrow; // Or return a default/fallback response
  }
}

Future<PaginateBaseResponseModel<Procuration>> getproccurations({
  int? page,
  String? limit,
  Map? filter,
}) async {
  try {
    String filterQuery = filter != null
        ? '&filter=${Uri.encodeQueryComponent(jsonEncode(filter))}'
        : '';
    var response = await buildHttpResponse(
      'getproccurations?page=$page&limit=$limit$filterQuery',
      method: HttpMethod.GET,
    );
    var handledResponse = await handleResponse(response);
    return PaginateBaseResponseModel<Procuration>.fromJson(
      handledResponse,
      Procuration.fromJson,
    );
  } catch (e) {
    rethrow; // Or return a default/fallback response
  }
}

Future<BaseResponseModel> getUnityPrrocuration(String? id) async {
  try {
    var response = await buildHttpResponse(
      'getUnityProcuration/$id',
      method: HttpMethod.GET,
    );
    var handledResponse = await handleResponse(response);
    return BaseResponseModel.fromJson(handledResponse);
  } catch (e) {
    rethrow;
  }
}

Future<BaseResponseModel> getUnityReview(String? id, {procurationId}) async {
  try {
    var response = await buildHttpResponse(
      'getUnityReview/$id${procurationId != null ? '?procurationId=$procurationId' : ''}',
      method: HttpMethod.GET,
    );
    var handledResponse = await handleResponse(response);
    return BaseResponseModel.fromJson(handledResponse);
  } catch (e) {
    rethrow;
  }
}

Future<BaseResponseModel> getTransactionInvoice(String? id) async {
  try {
    var response = await buildHttpResponse(
      'stripe/transaction/invoice/$id',
      method: HttpMethod.GET,
    );
    var handledResponse = await handleResponse(response);
    return BaseResponseModel.fromJson(handledResponse);
  } catch (e) {
    rethrow;
  }
}

Future<BaseResponseModel> mygetMoreMessages(Map request) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        request: request,
        'rooms/getmessages',
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> getReviewByCode(String code) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse('getReviewBycode/$code', method: HttpMethod.GET),
    ),
  );
}

Future<BaseResponseModel> closeCall(Map request) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        request: request,
        'meeting/close',
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> postAnswer(Map request) async {
  return BaseResponseModel.fromJson(
    await handleResponse(
      await buildHttpResponse(
        request: request,
        'meeting/answer',
        method: HttpMethod.POST,
      ),
    ),
  );
}

Future<BaseResponseModel> getItemsAccess() async {
  return BaseResponseModel.fromJson(
    await (handleResponse(
      await buildHttpResponse('item/access', method: HttpMethod.GET),
    )),
  );
}

// Future<List<BookingStatusResponse>> bookingStatus() async {
//   Iterable res = await (handleResponse(
//       await buildHttpResponse('booking-status', method: HttpMethod.GET)));
//   return res.map((e) => BookingStatusResponse.fromJson(e)).toList();
// }
// //endregion
Future<void> saveUserData(User data, {String? token}) async {
  try {
    Jks.currentUser = data;
    Future.delayed(Duration(seconds: Jks.wizardState != null ? 0 : 2), () {
      Jks.wizardState?.setcurrentUser(data);
    });
  } catch (e) {
    myprint(e);

    e;
  }

  if (token.validate().isNotEmpty) {
    await appStore.setToken(token!);
  }

  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN), isInitializing: true);

  await appStore.setUserType(data.type.validate());
  await appStore.setUserId(data.id.validate());
  await appStore.set_id(data.iid.validate());

  await appStore.setFirstName(data.firstName.validate());
  await appStore.setLastName(data.lastName.validate());
  await appStore.setUserEmail(data.email.validate());
  await appStore.setUserName(data.name.validate());
  await appStore.setAddress(data.address.validate());
  await appStore.setplaceOfBirth(getStringAsync(data.placeOfBirth.validate()));

  await appStore.setImageUrl(data.imageUrl.validate());
  await appStore.setPhoneNumber(data.phoneNumber.validate());
  await appStore.setGender(data.gender.validate());

  if (data.meta != null) {
    final meta = data.meta as Map<dynamic, dynamic>;
    final formattedmeta = meta.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    await appStore.setMeta(formattedmeta);
  }
  if (data.balance != null) {
    final meta = data.balance?.toJson() as Map<dynamic, dynamic>;
    final formattedmeta = meta.map(
      (key, value) => MapEntry(key.toString(), value),
    );
    await appStore.setBalence(formattedmeta);
  }

  await appStore.setAbout(data.about.validate());

  // Last online
  if (data.lastOnline != null) {
    await appStore.setLastOnline(data.lastOnline?.millisecondsSinceEpoch);
  }

  // Lists
  await appStore.setFavorites(
    (data.favorites ?? []).map((e) => e.toString()).toList(),
  );
  await appStore.setImages(
    (data.images ?? []).map((e) => e.toString()).toList(),
  );

  await appStore.setLevel(data.level.validate());
  appStore.setLoggedIn(true);
}

Future<void> clearPreferences() async {
  if (!getBoolAsync(IS_REMEMBERED)) await appStore.setUserEmail('');
  final isdark = appStore.isDarkMode;

  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setUserId(0);
  await appStore.setUserName('');
  await appStore.setUId('');
  await appStore.setCurrentAddress('');

  await appStore.setToken('');

  await appStore.setLoggedIn(false);
  await removeKey(LOGIN_TYPE);
  await removeKey(OfflineStorageService.offlineReviewsKey);
  await removeKey(OfflineStorageService.offlineImagesKey);
  clearSharedPref();
  appStore.setDarkMode(isdark);

  Jks.currentUser = null;
}

Future<void> logout(BuildContext context) async {
  try {
    appStore.setLoading(true);
    await clearPreferences();
    if (isAndroid || isIOS) {
      await FirebaseService.onUserLogout();
    }
    appStore.setLoading(false);
    Jks.checkingAuth = false;
    context.pushReplacement("/");
  } catch (e) {
    myprint(e.toString());
    Jks.checkingAuth = false;
    context.pushReplacement("/");
  }
}

Future<void> registerFCMToken(String token) async {
  try {
    var requestable = {
      "platform": getPlatform(),
      'userId': appStore.iid.validate(),
      'fcmToken': token,
    };

    BaseResponseModel.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'notification/register-token',
          request: requestable,
          method: HttpMethod.POST,
        ),
      ),
    );
  } catch (e) {
    // my_inspect(e);

    print('🔴 Erreur API registerFCMToken: $e');
  }
}

Future<void> unregisterFCMToken(String token) async {
  try {
    var requestable = {
      "platform": getPlatform(),
      'userId': appStore.iid.validate(),
      'fcmToken': token,
    };

    BaseResponseModel.fromJson(
      await handleResponse(
        await buildHttpResponse(
          'notification/unregister-token',
          request: requestable,
          method: HttpMethod.POST,
        ),
      ),
    );
  } catch (e) {
    print('🔴 Erreur API unregisterFCMToken: $e');
  }
}

Future<void> logoutApi() async {
  return await handleResponse(
    await buildHttpResponse('logout', method: HttpMethod.GET),
  );
}
