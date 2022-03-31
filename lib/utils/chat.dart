
import 'package:adhara_socket_io/adhara_socket_io.dart';

class ChatSocket {
  static ChatSocket _instance;
  factory ChatSocket() => _getInstance();
  SocketOptions _socketOptions = SocketOptions('http://192.168.0.101:9999/');
  SocketIOManager _socketIOManager;
  SocketIO socketIO;
  ChatSocket._internal() {
    _socketIOManager = SocketIOManager();
    _socketIOManager.createInstance(_socketOptions).then((SocketIO socket) {
      this.socketIO =socket;
      socket.onConnect((data){
        print("connected...");
        print(data);
        socket.emit("message", ["Hello world!", '231']);
      });
      // socket.on("news", (data){   //sample event
      //   print("news");
      //   print(data);
      // });
      socket.connect();
    });
  }
  static ChatSocket _getInstance() {
    if (_instance == null) {
      _instance = new ChatSocket._internal();
    }
    return _instance;
  }
  
}