// ignore_for_file: deprecated_member_use
// ignore_for_file: missing_return

part of swagger.api;

class BaseApiClient {
  String? basePath;
  String? bankBasePath;
  String? authServerBasePath;
  String? kycServiceBasePath;

  int REQUEST_TIMEOUT_TIME = 60;

  Map<String, String> _defaultHeaderMap = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "*",
    "Access-Control-Allow-Headers":
        "Origin, X-Requested-With, Content-Type, Accept",
    'Accept': '*/*'
  };
  Map<String, Authentication> _authentications = {};

  final _RegList = new RegExp(r'^List<(.*)>$');
  final _RegMap = new RegExp(r'^Map<String,(.*)>$');

  setupBasePath() {
    // this.basePath = FlavorConfig.instance.variables['baseUrl'];
    // this.bankBasePath = FlavorConfig.instance.variables['bankBasePath'];
    // this.authServerBasePath =
    //     FlavorConfig.instance.variables['authServerBasePath'];
    // this.kycServiceBasePath =
    //     FlavorConfig.instance.variables['kycServiceBasePath'];
  }

  getBasePath() {
    // return FlavorConfig.instance.variables['baseUrl'];
  }

  void addDefaultHeader(String key, String value) {
    _defaultHeaderMap[key] = value;
  }

  dynamic _deserialize(dynamic value, String targetType) {
    try {
      switch (targetType) {
        case 'String':
          return '$value';
        case 'int':
          return value is int ? value : int.parse('$value');
        case 'bool':
          return value is bool ? value : '$value'.toLowerCase() == 'true';
        case 'double':
          return value is double ? value : double.parse('$value');

        ///sample
        case 'SampleRepositoryResponse':
          return SampleRepositoryResponse.fromJson(value);
        default:
          {
            Match match;
            if (value is List &&
                (match = _RegList.firstMatch(targetType!) as Match) != null) {
              var newTargetType = match[1];
              return value.map((v) => _deserialize(v, newTargetType!)).toList();
            } else if (value is Map &&
                (match = _RegMap.firstMatch(targetType!) as Match) != null) {
              var newTargetType = match[1];
              return Map.fromIterables(value.keys,
                  value.values.map((v) => _deserialize(v, newTargetType!)));
            }
          }
      }
    } catch (e, stack) {
      throw ApiException.withInner(
          500, 'Exception during deserialization.', e as Exception, stack);
    }
    throw ApiException(
        500, 'Could not find a suitable class for deserialization');
  }

  dynamic deserialize(String jsonVal, String targetType) {
    // Remove all spaces.  Necessary for reg expressions as well.
    targetType = targetType.replaceAll(' ', '');

    if (targetType == 'String') return jsonVal;

    jsonVal = jsonVal.replaceAll('Ã', 'Ñ');
    jsonVal = jsonVal.replaceAll('Ã±', 'ñ');
    jsonVal = jsonVal.replaceAll('â', '\'');
    jsonVal = jsonVal.replaceAll('â', '’');
    var decodedJson = json.decode(jsonVal);
    return _deserialize(decodedJson, targetType);
  }

  String serialize(Object obj) {
    String serialized = '';
    if (obj == null) {
      serialized = '';
    } else {
      serialized = json.encode(obj);
    }
    return serialized;
  }

  /// Update query and header parameters based on authentication settings.
  /// @param authNames The authentications to apply
  void _updateParamsForAuth(List<String> authNames,
      List<QueryParam>? queryParams, Map<String, String> headerParams) {
    for (var authName in authNames) {
      Authentication auth = _authentications[authName]!;
      if (auth == null) {
        throw ArgumentError("Authentication undefined: " + authName);
      }
      auth.applyToParams(queryParams!, headerParams);
    }
  }

  void setAccessToken(String accessToken) {
    _authentications.forEach((key, auth) {
      if (auth is OAuth) {
        auth.setAccessToken(accessToken);
      }
    });
  }

  Future<Response?> commonApiCall(
      String path,
      String method,
      List<QueryParam> queryParams,
      Object body,
      Map<String, String> headerParams,
      Map<String, String> formParams,
      String contentType,
      List<String> authNames,
      String basePath) async {}

  callApi(
      Object body,
      String method,
      String url,
      Map<String, String> headerParams,
      String contentType,
      Map<String, String> formParams) async {}

  Future<Response?> invokeKycAPI(
      String path,
      String method,
      List<QueryParam> queryParams,
      Object body,
      Map<String, String> headerParams,
      Map<String, String> formParams,
      String contentType,
      List<String> authNames) async {
    return commonApiCall(path, method, queryParams, body, headerParams,
        formParams, contentType, authNames, kycServiceBasePath!);
  }

  Future<Response?> invokeBankAPI(
      String path,
      String method,
      List<QueryParam> queryParams,
      Object body,
      Map<String, String> headerParams,
      Map<String, String> formParams,
      String contentType,
      List<String> authNames) async {
    return commonApiCall(path, method, queryParams, body, headerParams,
        formParams, contentType, authNames, bankBasePath!);
  }

  Future<Response?> invokeAuthServerAPI(
      String path,
      String method,
      List<QueryParam> queryParams,
      Object body,
      Map<String, String> headerParams,
      Map<String, String> formParams,
      String contentType,
      List<String> authNames) async {
    return commonApiCall(path, method, queryParams, body, headerParams,
        formParams, contentType, authNames, authServerBasePath!);
  }

  Future<Response?> invokeApiNew(
      String path,
      String method,
      List<QueryParam> queryParams,
      Object body,
      Map<String, String> headerParams,
      Map<String, String> formParams,
      String contentType,
      List<String> authNames) async {
    return commonApiCall(path, method, queryParams, body, headerParams,
        formParams, contentType, authNames, basePath!);
  }
}

class ApiDefaultClient extends BaseApiClient {
  ApiDefaultClient() {
    setupBasePath();
    _authentications['OauthSecurity'] = OAuth();
    HttpOverrides.global = MyHttpOverrides();
  }

  Client client = InterceptedClient.build(
    interceptors: [
      LoggingDefaultInterceptor(),
    ],
  );

  Future<Response> commonApiCall(
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
    //
    // var response;
    // String connection = kIsWeb ? 'CONNECTION_SECURE' : await check_ssl(url);

    var response;
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
}
