import 'package:faucet/requests/models/request.dart';
import 'package:faucet/shared/constants/status.dart';
import 'package:faucet/shared/constants/network_name.dart';

List<Request> getMockRequests(int reqNumber) {
  List<Request> requests = [];

  for (int i = 0; i < reqNumber; i++) {
    requests.add(
      Request(
        network: NetworkName.testnet,
        walletAddress: '${i.toString()}8EhwUBiHJ3evyGidV1WH8QMfrLF6N8UDze9Yw7jqi6w',
        status: Status.confirmed,
        dateTime: DateTime.now(),
        tokensDisbursed: i.toDouble(),
      ),
    );
  }

  return requests;
}
