import 'package:faucet/requests/models/request.dart';
import 'package:faucet/requests/providers/requests_provider.dart';
import 'package:faucet/shared/constants/network_name.dart';
import 'package:faucet/shared/constants/status.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';

class MockRequestNotifier extends Mock implements RequestNotifier {
  MockRequestNotifier(
    ref,
    selectedChain,
  ) : super() {
    when(makeRequest(
      ref,
      Request(
        network: NetworkName.testnet,
        walletAddress: "textWalletEditingController.text",
        status: Status.confirmed,
        dateTime: DateTime.now(),
        tokensDisbursed: 100,
      ),
    )).thenThrow(Exception("Invalid test token request"));
  }
}
