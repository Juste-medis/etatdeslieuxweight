import 'dart:convert';
import 'dart:io';

import 'package:jatai_etatsdeslieux/app/core/app_config/app_config.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:jatai_etatsdeslieux/app/providers/_review_provider.dart';
import 'package:jatai_etatsdeslieux/app/widgets/toasts/mytoast.dart';
import 'package:jatai_etatsdeslieux/main.dart';
import 'package:nb_utils/nb_utils.dart' hide isNetworkAvailable;
import 'package:provider/provider.dart';

isNetworkAvailable() async {
  return await Jks().netChecker();
}

Map<String, String> buildHeaderTokens(
    {bool isStripePayment = false, Map? request}) {
  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
  };

  if (appStore.isLoggedIn && isStripePayment) {
    //String formBody = Uri.encodeQueryComponent(jsonEncode(request));
    //List<int> bodyBytes = utf8.encode(formBody);

    header.putIfAbsent(HttpHeaders.contentTypeHeader,
        () => 'application/x-www-form-urlencoded');
    header.putIfAbsent(HttpHeaders.authorizationHeader,
        () => 'Bearer $getStringAsync("StripeKeyPayment")');
  } else {
    header.putIfAbsent(
        HttpHeaders.contentTypeHeader, () => 'application/json; charset=utf-8');

    header.putIfAbsent(
        HttpHeaders.authorizationHeader, () => 'Bearer ${appStore.token}');
    header.putIfAbsent(
        HttpHeaders.acceptHeader, () => 'application/json; charset=utf-8');

    try {
      ReviewProvider reviewstate = Jks.context!.read<ReviewProvider>();
      if (reviewstate.accessCode.isNotEmpty) {
        header.putIfAbsent('X-Access-Code', () => reviewstate.accessCode);
      }
    } catch (e) {
      my_print_err(e);
    }
  }

  //log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) {
    url = Uri.parse('${AppConfig.BASE_URL}$endPoint');
  }
  return url;
}

Future<Response> buildHttpResponse(String endPoint,
    {HttpMethod method = HttpMethod.GET,
    Map? request,
    bool isStripePayment = false}) async {
  if (await isNetworkAvailable()) {
    var headers =
        buildHeaderTokens(isStripePayment: isStripePayment, request: request);
    Uri url = buildBaseUrl(endPoint);
    Response response;
    myprintnet('Request: $url');

    if (method == HttpMethod.POST) {
      response = await http.post(
        url,
        body: jsonEncode(request),
        headers: headers,
        encoding: isStripePayment ? Encoding.getByName("utf-8") : null,
      );
    } else if (method == HttpMethod.DELETE) {
      response = await delete(url, headers: headers);
    } else if (method == HttpMethod.PUT) {
      response = await put(url, body: jsonEncode(request), headers: headers);
    } else {
      response = await get(url, headers: headers);
    }

    return response;
  } else {
    toast(errorInternetNotAvailable);

    throw errorInternetNotAvailable;
  }
}

Future handleResponse(Response response, [bool? avoidTokenError]) async {
  if (!await isNetworkAvailable()) {
    throw errorInternetNotAvailable;
  }
  if (response.statusCode == 401) {
    if (!avoidTokenError.validate()) LiveStream().emit(LIVESTREAM_TOKEN, true);
    throw 'Token Expired';
  }
  String? uri_path = response.request?.url.path;

  final Map<String, dynamic> decoded = jsonDecode(response.body);
  if (response.statusCode == 400 || response.statusCode == 404) {
    const formErrors = [
      "/api/signup",
      "/api/signin",
    ];

    if (formErrors.contains(uri_path)) {
      final Map<String, dynamic> errors = decoded;
      errors.forEach((key, value) {
        myprintnet(value);

        AwfulToast.show(
            context: Jks.context!,
            message: value,
            blinking: true,
            toastType: ToastType.error);
      });
    }
  }

  if ((decoded.containsKey('message') &&
          !([
            "/api/message",
            "map/search",
          ].contains(uri_path))) &&
      (!decoded.containsKey('status') ||
          (decoded.containsKey('status') && decoded['status'] == false))) {
    AwfulToast.show(
        context: Jks.context!,
        message: decoded['message'],
        blinking: true,
        toastType: ToastType.error);
  }
  if (response.statusCode.isSuccessful()) {
    return decoded;
  } else {
    try {
      var body = jsonDecode(response.body);
      throw parseHtmlString(body['message']);
    } on Exception catch (e, stack) {
      log(e);
      log(stack);

      throw errorSomethingWentWrong;
    }
  }
}

Future<MultipartRequest> getMultiPartRequest(String endPoint,
    {String? baseUrl}) async {
  String url = baseUrl ?? buildBaseUrl(endPoint).toString();
  log(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(MultipartRequest multiPartRequest,
    {Function(dynamic)? onSuccess, Function(dynamic)? onError}) async {
  http.Response response =
      await http.Response.fromStream(await multiPartRequest.send());
  print("Result: ${response.statusCode}");

  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body);
  } else {
    my_inspect(response);

    onError?.call(errorSomethingWentWrong);
  }
}

//region Common
enum HttpMethod { GET, POST, DELETE, PUT }
//endregion
