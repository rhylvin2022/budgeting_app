part of swagger.api;

class LoggingInterceptor implements InterceptorContract {
  static const TOKEN = "TOKEN";

  @override
  Future<RequestData> interceptRequest({RequestData? data}) async {
    // if (!FlavorConfig.instance.variables["secure"]) {
    //   print(
    //       "================================     HTTP REQUEST START  ++++   ================================");
    //   print("URI            ::  ${data!.baseUrl}");
    //   print("REQUEST PARAMS ::  ${data.params}");
    //   print("METHOD         ::  ${data.method}");
    //
    //   print("HEADERS BEFORE    ::  ${data.headers}");
    //   print("HEADERS   AFTER     ::  ${data.headers}");
    //   print("REQUEST BODY   ::  ${data.body}");
    // }

    return data!;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData? data}) async {
    // if (!FlavorConfig.instance.variables["secure"]) {
    //   print(
    //       "================================          RESPONSE          ================================");
    //   print("STATUS CODE    ::  ${data!.statusCode}");
    //   print("HEADERS        ::  ${data!.headers}");
    //   print("RESPONSE BODY  ::  ${data!.body}");
    //   print(
    //       "================================      HTTP REQUEST END      ================================");
    // }
    return data!;
  }

  getSecureTokenData(String _key) async {
    try {
      String? _data = await const FlutterSecureStorage().read(key: _key);
      return _data;
    } catch (e) {
      return print(e);
    }
  }
}
