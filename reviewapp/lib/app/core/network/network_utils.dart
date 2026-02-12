import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:mon_etatsdeslieux/app/core/app_config/app_config.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:mon_etatsdeslieux/app/providers/_review_provider.dart';
import 'package:mon_etatsdeslieux/app/widgets/toasts/mytoast.dart';
import 'package:mon_etatsdeslieux/main.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

Map<String, String> buildHeaderTokens({
  bool isStripePayment = false,
  Map? request,
}) {
  String deviceType = "";
  try {
    deviceType = getActualDeviceType();
  } catch (e) {
    deviceType = "unknown";
  }

  Map<String, String> header = {
    HttpHeaders.cacheControlHeader: 'no-cache',
    'Access-Control-Allow-Headers': '*',
    'Access-Control-Allow-Origin': '*',
    "X-Access-Device": deviceType,
  };

  if (appStore.isLoggedIn && isStripePayment) {
    //String formBody = Uri.encodeQueryComponent(jsonEncode(request));
    //List<int> bodyBytes = utf8.encode(formBody);

    header.putIfAbsent(
      HttpHeaders.contentTypeHeader,
      () => 'application/x-www-form-urlencoded',
    );
    header.putIfAbsent(
      HttpHeaders.authorizationHeader,
      () => 'Bearer $getStringAsync("StripeKeyPayment")',
    );
  } else {
    header.putIfAbsent(
      HttpHeaders.contentTypeHeader,
      () => 'application/json; charset=utf-8',
    );

    header.putIfAbsent(
      HttpHeaders.authorizationHeader,
      () => 'Bearer ${appStore.token}',
    );
    header.putIfAbsent(
      HttpHeaders.acceptHeader,
      () => 'application/json; charset=utf-8',
    );

    try {
      ReviewProvider reviewstate = Jks.context!.read<ReviewProvider>();
      if (reviewstate.accessCode.isNotEmpty) {
        header.putIfAbsent('X-Access-Code', () => reviewstate.accessCode);
      }
    } catch (e) {
      // my_inspect(e);
      // my_print_err(e);
    }
  }

  //log(jsonEncode(header));
  return header;
}

Uri buildBaseUrl(String endPoint) {
  Uri url = Uri.parse(endPoint);
  if (!endPoint.startsWith('http')) {
    url = Uri.parse('${AppConfig.baseUrl}$endPoint');
  }
  return url;
}

Future<Response> buildHttpResponse(
  String endPoint, {
  HttpMethod method = HttpMethod.GET,
  Map? request,
  bool isStripePayment = false,
}) async {
  if (Jks.isNetworkAvailable) {
    var headers = buildHeaderTokens(
      isStripePayment: isStripePayment,
      request: request,
    );
    Uri url = buildBaseUrl(endPoint);
    Response response;

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
    myprintnet('Request: $url');
    return response;
  } else {
    // toast("Vérifiez votre connexion Internet et réessayez");

    throw "no_internet";
  }
}

Future handleResponse(Response response, [bool? avoidTokenError]) async {
  if (!Jks.isNetworkAvailable) {
    throw "Vérifiez votre connexion Internet et réessayez";
  }
  if (response.statusCode == 401) {
    if (!avoidTokenError.validate()) LiveStream().emit(LIVESTREAM_TOKEN, true);
    throw 'Token Expired';
  }
  String? uriPath = response.request?.url.path;

  final Map<String, dynamic> decoded = jsonDecode(response.body);
  // myprint('Response [$uri_path]: ${response.body}');
  if (response.statusCode == 400 || response.statusCode == 404) {
    const formErrors = ["/api/signup", "/api/signin"];

    if (formErrors.contains(uriPath)) {
      final Map<String, dynamic> errors = decoded;
      errors.forEach((key, value) {
        AwfulToast.show(
          context: Jks.context!,
          message: value,
          blinking: true,
          toastType: ToastType.error,
        );
      });
    }
  }
  // my_inspect(decoded);

  if ((decoded.containsKey('message') &&
          !(["/api/message", "map/search"].contains(uriPath))) &&
      (!decoded.containsKey('status') ||
          (decoded.containsKey('status') && decoded['status'] == false))) {
    AwfulToast.show(
      context: Jks.context!,
      message: decoded['message'],
      blinking: true,
      toastType: ToastType.error,
    );
  }
  if (response.statusCode.isSuccessful()) {
    return decoded;
  } else {
    try {
      my_inspect(response);
      var body = jsonDecode(response.body);
      throw (body['message']);
    } on Exception catch (e, stack) {
      log(e);
      log(stack);
      myprint("Error parsing response body: ${response.body}");
      throw errorSomethingWentWrong;
    }
  }
}

Future<MultipartRequest> getMultiPartRequest(
  String endPoint, {
  String? baseUrl,
}) async {
  String url = baseUrl ?? buildBaseUrl(endPoint).toString();
  myprintnet(url);
  return MultipartRequest('POST', Uri.parse(url));
}

Future<void> sendMultiPartRequest(
  MultipartRequest multiPartRequest, {
  Function(dynamic)? onSuccess,
  Function(dynamic)? onError,
}) async {
  if (!Jks.isNetworkAvailable) {
    throw "no_internet";
  }
  http.Response response = await http.Response.fromStream(
    await multiPartRequest.send(),
  );

  if (response.statusCode.isSuccessful()) {
    onSuccess?.call(response.body);
  } else {
    onError?.call(
      "Une erreur s'est produite. Veuillez réessayer. ${response.body}",
    );
  }
}

//region Common
enum HttpMethod { GET, POST, DELETE, PUT }

//endregion
