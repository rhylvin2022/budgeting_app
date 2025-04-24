library swagger.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
// import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:base_code/global/app_strings.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

import 'package:flutter/foundation.dart';
// import 'package:base_code/storage/storage.helper.dart';

part 'api_client.dart';

part 'api_default_client.dart';

part 'api_exception.dart';

part 'api_helper.dart';

part 'auth/api_key_auth.dart';

part 'auth/authentication.dart';

part 'auth/http_basic_auth.dart';

part 'auth/oauth.dart';

part 'interceptors/logging_default_interceptor.dart';

part 'interceptors/logging_interceptor.dart';

///sample
part 'api/get_sample_repository_api.dart';
part 'model/sample_repository_response.dart';

ApiDefaultClient defaultApiClient = ApiDefaultClient();
