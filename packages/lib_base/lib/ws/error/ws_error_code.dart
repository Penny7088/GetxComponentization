// ignore_for_file: lines_longer_than_80_chars

import 'package:collection/collection.dart';

/// Complete list of errors that are returned by the API
/// together with the description and API code.
enum WsErrorCode {
  // Client errors

  /// Unauthenticated, token not defined
  undefinedToken,

  // Bad Request

  /// Wrong data/parameter is sent to the API
  inputError,

  /// Event is not supported
  eventNotSupported,

  // Unauthorised

  /// Unauthenticated, problem with authentication
  authenticationError,

  /// Unauthenticated, token expired
  tokenExpired,

  /// Unauthenticated, token date incorrect
  tokenBeforeIssuedAt,

  /// Unauthenticated, token not valid yet
  tokenNotValid,

  /// Unauthenticated, token signature invalid
  tokenSignatureInvalid,

  /// Access Key invalid
  accessKeyError,

  // Forbidden

  /// Unauthorised / forbidden to make request
  notAllowed,

  /// App suspended
  appSuspended,

  // Miscellaneous

  /// Resource not found
  doesNotExist,

  /// Request timed out
  requestTimeout,

  /// Payload too big
  payloadTooBig,

  /// Too many requests in a certain time frame
  rateLimitError,

  /// Request headers are too large
  maximumHeaderSizeExceeded,

  /// Something goes wrong in the system
  internalSystemError,
}

const _errorCodeWithDescription = {
  WsErrorCode.undefinedToken: MapEntry(1000, 'Unauthorised, token not defined'),
  WsErrorCode.inputError:
      MapEntry(4, 'Wrong data/parameter is sent to the API'),
  WsErrorCode.eventNotSupported: MapEntry(18, 'Event is not supported'),
  WsErrorCode.authenticationError:
      MapEntry(5, 'Unauthenticated, problem with authentication'),
  WsErrorCode.tokenExpired: MapEntry(40, 'Unauthenticated, token expired'),
  WsErrorCode.tokenBeforeIssuedAt:
      MapEntry(42, 'Unauthenticated, token date incorrect'),
  WsErrorCode.tokenNotValid:
      MapEntry(41, 'Unauthenticated, token not valid yet'),
  WsErrorCode.tokenSignatureInvalid:
      MapEntry(43, 'Unauthenticated, token signature invalid'),
  WsErrorCode.accessKeyError: MapEntry(2, 'Access Key invalid'),
  WsErrorCode.notAllowed:
      MapEntry(17, 'Unauthorised / forbidden to make request'),
  WsErrorCode.appSuspended: MapEntry(99, 'App suspended'),
  WsErrorCode.doesNotExist: MapEntry(16, 'Resource not found'),
  WsErrorCode.requestTimeout: MapEntry(23, 'Request timed out'),
  WsErrorCode.payloadTooBig: MapEntry(22, 'Payload too big'),
  WsErrorCode.rateLimitError:
      MapEntry(9, 'Too many requests in a certain time frame'),
  WsErrorCode.maximumHeaderSizeExceeded:
      MapEntry(24, 'Request headers are too large'),
  WsErrorCode.internalSystemError:
      MapEntry(-1, 'Something goes wrong in the system'),
};

const _authenticationErrors = [
  WsErrorCode.undefinedToken,
  WsErrorCode.authenticationError,
  WsErrorCode.tokenExpired,
  WsErrorCode.tokenBeforeIssuedAt,
  WsErrorCode.tokenNotValid,
  WsErrorCode.tokenSignatureInvalid,
  WsErrorCode.accessKeyError,
];

///
WsErrorCode? wsErrorCodeFromCode(int code) => _errorCodeWithDescription.keys
    .firstWhereOrNull((key) => _errorCodeWithDescription[key]!.key == code);

///
extension WsErrorCodeX on WsErrorCode {
  ///
  String get message => _errorCodeWithDescription[this]!.value;

  ///
  int get code => _errorCodeWithDescription[this]!.key;

  ///
  bool get isAuthenticationError => _authenticationErrors.contains(this);
}
