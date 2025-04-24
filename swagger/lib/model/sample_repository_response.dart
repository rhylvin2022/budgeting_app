part of swagger.api;

class SampleRepositoryResponse {
  String? type;

  String? setup;

  String? punchline;

  int? id;

  SampleRepositoryResponse();

  @override
  String toString() {
    return 'SampleRepositoryResponse[type=$type, setup=$setup, punchline=$punchline, id=$id, ]';
  }

  SampleRepositoryResponse.fromJson(Map<String, dynamic> json) {
    if (json == null) return;
    type = json['type'];
    setup = json['setup'];
    punchline = json['punchline'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    return {'type': type, 'setup': setup, 'punchline': punchline, 'id': id};
  }

  static List<SampleRepositoryResponse> listFromJson(List<dynamic> json) {
    return json == null
        ? <SampleRepositoryResponse>[]
        : json
            .map((value) => SampleRepositoryResponse.fromJson(value))
            .toList();
  }

  static Map<String, SampleRepositoryResponse> mapFromJson(
      Map<String, Map<String, dynamic>> json) {
    var map = <String, SampleRepositoryResponse>{};
    if (json != null && json.isNotEmpty) {
      json.forEach((String key, Map<String, dynamic> value) =>
          map[key] = SampleRepositoryResponse.fromJson(value));
    }
    return map;
  }
}
