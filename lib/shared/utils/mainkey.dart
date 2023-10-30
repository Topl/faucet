import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:topl_common/proto/quivr/models/shared.pb.dart';

class Mainkey {
  static Future<void> loadEnvVariables() async {
    await dotenv.load(fileName: '.env');
    return Future.value();
  }

  static Future<KeyPair> getMainkey() {
    final mainkeyJson = dotenv.env['MAINKEY'] as String;

    final keyPair = KeyPair.fromJson(mainkeyJson);
    return Future.value(keyPair);
  }
}
