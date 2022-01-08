import 'dart:async';
import 'dart:io';

import 'dart:typed_data';

import 'package:network_info_plus/network_info_plus.dart';

// import 'package:socketlabs/socketlabs.dart';

class MyServer {
  MyServer({required this.onError, required this.onData});

  Function(Uint8List) onData;
  Function(dynamic) onError;
  ServerSocket? server;
  bool running = false;
  List<Socket> sockets = [];

  start() async {
    runZoned(() async {
      //In case the current setup doesnt work, Un comment the commented lines and comment line 25

      // for (int i in List.generate(998, (index) => index + 1)) {
      try {
        server = await ServerSocket.bind('192.168.43.1', 4040);
        // server = await ServerSocket.bind('192.168.43.'+i, 4040);
        print(server!.address);

        print('0.0.0.0');
        running = true;
        server!.listen(onRequest);
        onData(Uint8List.fromList('Server listening on port 4040'.codeUnits));
        // break;
      } catch (e) {
        print(e);
      }
      // }
    }, onError: (e) {
      onError(e);
    });
  }

  stop() async {
    await server!.close();
    server = null;
    running = false;
  }

  broadCast(String message) {
    onData(Uint8List.fromList('Broadcasting : $message'.codeUnits));
    for (Socket socket in sockets) {
      socket.write(message + '\n');
    }
  }

  onRequest(Socket socket) {
    if (!sockets.contains(socket)) {
      sockets.add(socket);
    }
    socket.listen((Uint8List data) {
      onData(data);
    });
  }
}
