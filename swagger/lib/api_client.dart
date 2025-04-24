// ignore_for_file: deprecated_member_use
// ignore_for_file: missing_return

part of swagger.api;

class QueryParam {
  QueryParam(this.name, this.value);

  String name;
  String value;
}

class ApiClient extends BaseApiClient {
  ApiClient() {
    setupBasePath();
    _authentications['OauthSecurity'] = OAuth();
    HttpOverrides.global = MyHttpOverrides();
  }

  Client client = InterceptedClient.build(
    interceptors: [
      LoggingInterceptor(),
    ],
    retryPolicy: ExpiredTokenRetryPolicy(),
  );

  Future<Response?> commonApiCall(
      String path,
      String method,
      List<QueryParam> queryParams,
      Object body,
      Map<String, String> headerParams,
      Map<String, String> formParams,
      String contentType,
      List<String> authNames,
      String basePath) async {
    _updateParamsForAuth(authNames, queryParams, headerParams);

    var ps = queryParams
        .where((p) => p.value != null)
        .map((p) => '${p.name}=${p.value}');
    String queryString = ps.isNotEmpty ? '?' + ps.join('&') : '';

    String url = basePath + path + queryString;
    headerParams.addAll(_defaultHeaderMap);
    headerParams['Content-Type'] = contentType;

    // // Firebase Performance trace the api call
    // String userID = await StorageHelper().getSecureData('USER_ID');
    //
    // final Trace httpTrace =
    //     FirebasePerformance.instance.newTrace('$userID-$path');
    // httpTrace.start();

    var response;
    // String connection = kIsWeb ? 'CONNECTION_SECURE' : await check_ssl(url);
    String connection = 'CONNECTION_SECURE';

    if (connection == "CONNECTION_NOT_SECURE") {
      return Response(
          '{"errorCode":"DEV_00_440","errorDesc":"","values":{"param1":"2"}}',
          401);
    } else {
      response = await _firebase_callAPI(
          body, method, url, headerParams, contentType, formParams);

      // httpTrace.setMetric('Response Code', response.statusCode);
      // httpTrace.stop();
      return response;
    }
  }

  _firebase_callAPI(
      Object body,
      String method,
      String url,
      Map<String, String> headerParams,
      String contentType,
      Map<String, String> formParams) async {
    if (body is MultipartRequest) {
      var request = new MultipartRequest(method, Uri.parse(url));
      request.fields.addAll(body.fields);
      request.files.addAll(body.files);
      request.headers.addAll(body.headers);
      request.headers.addAll(headerParams);
      var response = await client.send(request);
      return Response.fromStream(response);
    } else {
      var msgBody = contentType == "application/x-www-form-urlencoded"
          ? formParams
          : serialize(body);
      switch (method) {
        case "POST":
          return client.post(Uri.parse(url),
              headers: headerParams, body: msgBody);
        case "PUT":
          return client.put(Uri.parse(url),
              headers: headerParams, body: msgBody);
        case "DELETE":
          return client.delete(Uri.parse(url), headers: headerParams);
        case "PATCH":
          return client.patch(Uri.parse(url),
              headers: headerParams, body: msgBody);
        default:
          return client.get(Uri.parse(url), headers: headerParams);
      }
    }
  }

  // ///convert to crc32
  // int convertCRC32(Object body) {
  //   var checkSumResult = Crc32.calculate(jsonEncode(body));
  //   return checkSumResult;
  // }

  //Old method tobe removed SSL pinning check

  Future<Response> invokeAPI(
      String path,
      String method,
      List<QueryParam> queryParams,
      Object body,
      Map<String, String> headerParams,
      Map<String, String> formParams,
      String contentType,
      List<String> authNames) async {
    _updateParamsForAuth(authNames, queryParams, headerParams);

    var ps = queryParams
        .where((p) => p.value != null)
        .map((p) => '${p.name}=${p.value}');
    String queryString = ps.isNotEmpty ? '?' + ps.join('&') : '';

    // String url = basePath! + path + queryString;
    String url = path;

    headerParams.addAll(_defaultHeaderMap);
    headerParams['Content-Type'] = contentType;

    // // Firebase Performance trace the api call
    // String userID = await StorageHelper().getSecureData('USER_ID');
    //
    // final Trace httpTrace =
    //     FirebasePerformance.instance.newTrace('$userID-$path');
    // httpTrace.start();

    var response;

    // String connection = kIsWeb ? 'CONNECTION_SECURE' : await check_ssl(url);
    String connection = 'CONNECTION_SECURE';

    if (connection == "CONNECTION_NOT_SECURE") {
      return Response(
          '{"errorCode":"DEV_00_440","errorDesc":"","values":{"param1":"2"}}',
          401);
    } else {
      response = await callApi(
          body, method, url, headerParams, contentType, formParams);

      // httpTrace.setMetric('Response Code', response.statusCode);
      // httpTrace.stop();
      return response;
    }
  }

  callApi(
      Object body,
      String method,
      String url,
      Map<String, String> headerParams,
      String contentType,
      Map<String, String> formParams) async {
    if (body is MultipartRequest) {
      var request = new MultipartRequest(method, Uri.parse(url));
      request.fields.addAll(body.fields);
      request.files.addAll(body.files);
      request.headers.addAll(body.headers);
      request.headers.addAll(headerParams);
      var response = await client.send(request);

      return Response.fromStream(response);
    } else {
      try {
        var msgBody = contentType == "application/x-www-form-urlencoded"
            ? formParams
            : serialize(body);
        switch (method) {
          case "POST":
            return client
                .post(Uri.parse(url), headers: headerParams, body: msgBody)
                .timeout(Duration(seconds: REQUEST_TIMEOUT_TIME));
          case "PUT":
            return client
                .put(Uri.parse(url), headers: headerParams, body: msgBody)
                .timeout(Duration(seconds: REQUEST_TIMEOUT_TIME));
          case "DELETE":
            return client
                .delete(Uri.parse(url), headers: headerParams, body: msgBody)
                .timeout(Duration(seconds: REQUEST_TIMEOUT_TIME));
          case "PATCH":
            return client
                .patch(Uri.parse(url), headers: headerParams, body: msgBody)
                .timeout(Duration(seconds: REQUEST_TIMEOUT_TIME));
          default:
            return client
                .get(Uri.parse(url), headers: headerParams)
                .timeout(Duration(seconds: REQUEST_TIMEOUT_TIME));
        }
      } on TimeoutException catch (_) {
        // client.close();
        // client = new Client();

        throw ApiException(408, AppStrings.timedOutResponse);
      }
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // Flavor flavor = FlavorConfig.instance.variables["flavor"];
    // bool releaseMode = flavor == Flavor.PRODUCTION || flavor == Flavor.UAT;
    bool releaseMode = true;

    HttpClient client = super.createHttpClient(context);

    if (!releaseMode) // development mode only
    {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        debugPrint(
            "Warning: Accepting self-signed certificates in development for $host");
        return true;
      };
    }

    return client;
  }
}

class ExpiredTokenRetryPolicy extends RetryPolicy {
  @override
  int get maxRetryAttempts => 2;

  @override
  bool shouldAttemptRetryOnException(Exception reason) {
    return false;
  }

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    // if (response.statusCode >= 440) {
    //   await locator<TokenDataSource>().verifyAndRefreshTokens(response);
    //
    //   return true;
    // }

    return false;
  }
}
