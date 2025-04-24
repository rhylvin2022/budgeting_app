part of swagger.api;

///developed by Rhylvin May 2023
class GetSampleRepositoryAPI {
  GetSampleRepositoryAPI([ApiClient? apiClientCommon]) {
    if (apiClientCommon == null) {
      apiClient = defaultApiClient;
    } else {
      apiClient = apiClientCommon;
    }
  }

  var apiClient;

  ///
  ///
  ///
  Future<SampleRepositoryResponse> getSampleRepository(
      // GetSampleRepositoryRequest body,
      // String clientId,
      // String clientSecret,
      // String token,
      ) async {
    Object postBody = {};

    // verify required params are set

    // create path and map variables
    String path = "https://official-joke-api.appspot.com/random_joke"
        .replaceAll("{format}", "json");

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> formParams = {};
    Map<String, String> headerParams = {
      HttpHeaders.contentTypeHeader: "application/json",
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=5, max=1000",
    };

    List<String> contentTypes = [
      "application/json",
      "application/xml",
      "multipart/form-data"
    ];

    // headerParams["clientId"] = clientId;
    // headerParams["clientSecret"] = clientSecret;
    // headerParams["Authorization"] = "Bearer $token";

    String contentType =
        contentTypes.isNotEmpty ? contentTypes[0] : "application/json";
    List<String> authNames = ["OauthSecurity"];

    if (contentType.startsWith("multipart/form-data")) {
      bool hasFields = false;
      MultipartRequest mp = MultipartRequest("", Uri.parse(""));
      if (hasFields) postBody = mp;
    } else {}
    var response = await apiClient.invokeAPI(path, 'GET', queryParams, postBody,
        headerParams, formParams, contentType, authNames);

    if (response.statusCode >= 400) {
      throw ApiException(response.statusCode, response.body);
    } else if (response.body != null) {
      return apiClient.deserialize(response.body, 'SampleRepositoryResponse')
          as SampleRepositoryResponse;
    } else {
      return SampleRepositoryResponse();
    }
  }
}
