import 'dart:io';
import 'dart:typed_data';

import 'package:network_info_plus/network_info_plus.dart';

import 'models.dart';

class Client {
  Client({
    required this.onError,
    required this.onData,
    required this.hostname,
    required this.port,
  });

  String hostname;
  int port;
  Uint8ListCallback onData;
  DynamicCallback onError;
  bool connected = false;

  Socket? socket;

  connect() async {
    //In case the current setup doesnt work, Un comment the commented lines and comment line 31

    // for (int i in List.generate(998, (index) => index + 1)) {
    try {
      print("BEfore");

      socket = await Socket.connect('192.168.43.1', 4040);
      // socket = await Socket.connect('192.168.43.1' + i.toString(), 4040);
      print("After");
      socket!.listen(
        onData,
        onError: onError,
        onDone: disconnect,
        cancelOnError: false,
      );
      connected = true;
      // break;
    } on Exception catch (exception) {
      print(exception);
      onData(Uint8List.fromList("Error : $exception".codeUnits));
    }
    // }
  }

  write(String message) {
    //Connect standard in to the socket
    socket!.write(message + '\n');
  }

  disconnect() {
    if (socket != null) {
      socket!.destroy();
      connected = false;
    }
  }
}
