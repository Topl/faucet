// Flutter imports
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:faucet/shared/constants/status.dart';
import 'package:faucet/shared/constants/network_name.dart';

part 'request.freezed.dart';
part 'request.g.dart';

@freezed
class Request with _$Request {
  const factory Request({
    /// String representing the transactionId
    String? transactionId,

    /// String representing the network.
    required NetworkName network,

    /// A String representing the wallet address a request was made to
    required String walletAddress,

    /// Enum representing status of request
    required Status status,

    /// DateTime representing when the request was created
    required DateTime dateTime,

    /// double representing the amount of tokens in a request
    required double tokensDisbursed,
  }) = _Request;

  factory Request.fromJson(Map<String, dynamic> json) => _$RequestFromJson(json);
}
