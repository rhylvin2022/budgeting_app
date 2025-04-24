part of swagger.api;

class ApiKeyAuth implements Authentication {
  ApiKeyAuth(this.location, this.paramName);

  final String? location;
  final String? paramName;
  String? apiKey;
  String? apiKeyPrefix;

  @override
  void applyToParams(
      List<QueryParam> queryParams, Map<String, String> headerParams) {
    String value;
    if (apiKeyPrefix != null) {
      value = '$apiKeyPrefix $apiKey';
    } else {
      value = apiKey!;
    }

    if (location == 'query' && value != null) {
      queryParams.add(QueryParam(paramName!, value));
    } else if (location == 'header' && value != null) {
      headerParams[paramName!] = value;
    }
  }
}
