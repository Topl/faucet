import 'package:grpc/grpc.dart';
import '../../chain/models/chains.dart';

ClientChannel getChannel(Chains selectedChain) {
  return ClientChannel(
    selectedChain.hostUrl,
    port: selectedChain.port,
  );
}
