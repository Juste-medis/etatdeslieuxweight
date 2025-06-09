import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/network/network_utils.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/models/base_response_model.dart';
import 'package:jatai_etatsdeslieux/app/models/login_model.dart';
import 'package:jatai_etatsdeslieux/app/models/models.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/pages/pages.dart' as jp;
import 'package:jatai_etatsdeslieux/main.dart';
import 'package:nb_utils/nb_utils.dart' hide isNetworkAvailable;
import 'package:go_router/go_router.dart';

isNetworkAvailable() async {
  return await Jks().netChecker();
}

//region Auth Api
Future<LoginResponse> createUser(Map request) async {
  return LoginResponse.fromJson(await (handleResponse(await buildHttpResponse(
      'signup',
      request: request,
      method: HttpMethod.POST))));
}

Future<User> getUser({String? userId = "0"}) async {
  return User.fromJson((await handleResponse(await buildHttpResponse(
      'getuser?id=$userId',
      request: {"id": userId},
      method: HttpMethod.POST)))['data']);
}

Future<LoginResponse> loginUser(Map request,
    {bool isSocialLogin = false}) async {
  LoginResponse res = LoginResponse.fromJson(await handleResponse(
      await buildHttpResponse(isSocialLogin ? 'social-login' : 'signin',
          request: request, method: HttpMethod.POST)));
  if (!isSocialLogin) await appStore.setLoginType(LOGIN_TYPE_USER);

  return res;
}

Future<BaseResponseModel> createprocuration(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('/owner/procurarion',
          request: request, method: HttpMethod.POST)));

  return res;
}

Future<BaseResponseModel> createreview(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('/createreview',
          request: request, method: HttpMethod.POST)));

  return res;
}

Future<BaseResponseModel> updatereview(id, Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('/updatereview/$id',
          request: request, method: HttpMethod.POST)));

  return res;
}

Future<BaseResponseModel> deleteReview(id) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('/deleteReview/$id',
          request: {}, method: HttpMethod.POST)));

  return res;
}

Future<BaseResponseModel> previwage(id, Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('/preview-review/$id',
          request: request, method: HttpMethod.POST)));

  return res;
}

Future<BaseResponseModel> griffeprocuration(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('/owner/griffeprocurarion',
          request: request, method: HttpMethod.POST)));

  return res;
}

Future<BaseResponseModel> grifferefiew(Map request) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('/griffereview',
          request: request, method: HttpMethod.POST)));

  return res;
}

Future<BaseResponseModel> verifyCredential(
  Map request,
) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('auth/code',
          request: request, method: HttpMethod.POST)));
  return res;
}

Future<BaseResponseModel> verifyCode(
  Map request,
) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('verifyotp',
          request: request, method: HttpMethod.POST)));
  return res;
}

Future<BaseResponseModel> resendOtpCode(
  Map request,
) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('resendOtpCode',
          request: request, method: HttpMethod.POST)));
  return res;
}

Future<BaseResponseModel> ratethepost(
  Map request,
) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('/post/rate',
          request: request, method: HttpMethod.POST)));
  return res;
}

Future<BaseResponseModel> likeunlike(
  Map request,
) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('post/likeunlike',
          request: request, method: HttpMethod.POST)));
  return res;
}

Future<BaseResponseModel> havepurchased(
  Map request,
) async {
  BaseResponseModel res = BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('payements/havepurchased',
          request: request, method: HttpMethod.POST)));
  return res;
}

Future<BaseResponseModel> changeUserPassword(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('auth/change',
          request: request, method: HttpMethod.POST)));
}

//region Review Api
Future<LoginResponse> edituser(Map request) async {
  return LoginResponse.fromJson(await handleResponse(await buildHttpResponse(
      'user/edit',
      request: request,
      method: HttpMethod.POST)));
}

Future<LoginResponse> editsettings(Map request) async {
  return LoginResponse.fromJson(await handleResponse(await buildHttpResponse(
      '/user/setting',
      request: request,
      method: HttpMethod.POST)));
}

Future<BaseResponseModel> getplaces(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('map/search?city=${request["city"]}',
          request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> reverseplace(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse(
          'map/reverse?lat=${request["lat"]}&lon=${request["lon"]}',
          request: request,
          method: HttpMethod.GET)));
}

Future<BaseResponseModel> updateImages(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('/user/updateImages',
          request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> updateThingImages(
    String path, Map request, id) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('/updateImages/$path/$id',
          request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> postCall(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('meeting/call',
          request: request, method: HttpMethod.POST)));
}

Future<BaseResponseModel> readMessage(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse(
          request: request, 'room/read', method: HttpMethod.POST)));
}

Future<BaseResponseModel> markNotifAsRead(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse(
          request: request, 'notification/read', method: HttpMethod.POST)));
}

Future<BaseResponseModel> istyping(Map request) async {
  try {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(
            request: request, 'typing', method: HttpMethod.POST)));
  } catch (e) {
    return BaseResponseModel.fromJson({});
  }
}

Future<BaseResponseModel> postofferCandidates(Map request) async {
  try {
    return BaseResponseModel.fromJson(await handleResponse(
        await buildHttpResponse(
            request: request, 'offerCandidates', method: HttpMethod.POST)));
  } catch (e) {
    inspect(e);
    return BaseResponseModel.fromJson({});
  }
}

Future<SendMessageResponse> sendmessage(Map request) async {
  return SendMessageResponse.fromJson(await handleResponse(
      await buildHttpResponse(
          request: request, 'message', method: HttpMethod.POST)));
}

Future<BaseResponseModel> fetchRanking() async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('leadboard', method: HttpMethod.GET)));
}

Future<BaseResponseModel> fetchSecring() async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('orders', method: HttpMethod.GET)));
}

Future<BaseResponseModel> getusers({int? userId = 0}) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('fake/$userId/CheckedUser',
          method: HttpMethod.GET)));
}

Future<BaseResponseModel> getmynotifications({
  int? userId = 0,
  String? first = "",
}) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('fake/$userId/notifications?cursor=$first',
          method: HttpMethod.GET)));
}

Future<BaseResponseModel> getusersmy(
    {int? userId = 0, String? start, String? limit}) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse(
          'fake/$userId/getusersmy?start=$start&limit=$limit',
          method: HttpMethod.GET)));
}

Future<PaginateBaseResponseModel<Review>> getreviews(
    {int? page, String? limit, Map? filter}) async {
  return PaginateBaseResponseModel<Review>.fromJson(
      await handleResponse(await buildHttpResponse(
          'getreviews?page=$page&limit=$limit${filter != null ? '&filter=$filter' : ''}',
          method: HttpMethod.GET)),
      Review.fromJson);
}

Future<BaseResponseModel> mygetMoreMessages(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse(
          request: request, 'rooms/getmessages', method: HttpMethod.POST)));
}

Future<BaseResponseModel> getReviewByCode(String code) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse('getReviewBycode/$code',
          method: HttpMethod.GET)));
}

Future<BaseResponseModel> closeCall(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse(
          request: request, 'meeting/close', method: HttpMethod.POST)));
}

Future<BaseResponseModel> postAnswer(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(
      await buildHttpResponse(
          request: request, 'meeting/answer', method: HttpMethod.POST)));
}

Future<BaseResponseModel> getItemsAccess() async {
  return BaseResponseModel.fromJson(await (handleResponse(
      await buildHttpResponse('item/access', method: HttpMethod.GET))));
}

// Future<List<BookingStatusResponse>> bookingStatus() async {
//   Iterable res = await (handleResponse(
//       await buildHttpResponse('booking-status', method: HttpMethod.GET)));
//   return res.map((e) => BookingStatusResponse.fromJson(e)).toList();
// }
// //endregion
Future<void> saveUserData(User data, {String? token}) async {
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

  await appStore.setFirstName('');
  await appStore.setLastName('');
  await appStore.setUserId(0);
  await appStore.setUserName('');
  await appStore.setUId('');
  await appStore.setCurrentAddress('');

  await appStore.setToken('');

  await appStore.setLoggedIn(false);
  await removeKey(LOGIN_TYPE);
}

Future<void> logout(BuildContext context) async {
  appStore.setLoading(true);
  await clearPreferences();
  appStore.setLoading(false);
  context.pushReplacement("/authentication/signin");
}

Future<void> logoutApi() async {
  return await handleResponse(
      await buildHttpResponse('logout', method: HttpMethod.GET));
}
