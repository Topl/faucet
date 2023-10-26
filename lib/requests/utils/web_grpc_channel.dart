import 'package:grpc/grpc_web.dart';
import '../../chain/models/chains.dart';

GrpcWebClientChannel getChannel(Chains selectedChain) {
  final protocol = selectedChain.hostUrl == 'localhost' ? 'http' : 'https';
  return GrpcWebClientChannel.xhr(Uri.parse('$protocol://${selectedChain.hostUrl}:${selectedChain.port}'));
}
