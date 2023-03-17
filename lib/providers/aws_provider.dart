import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:csv/csv.dart';

import '../models/sensor.dart';

class AWSProvider with ChangeNotifier {
  String msgStatus = 'Status';
  dynamic _dataReceived;
  final List<Sensor> _sensors = [];
  bool isConnected = false; //true when server connected
  bool stream = false; //true when data is transmitted
  bool hasData = false;
  File rightSensorFile = File('right.txt');
  File leftSensorFile = File('left.txt');
  TextEditingController idTextController =
      TextEditingController(); //may delete later
  bool csvTitlesAdded = false;

  String topic = 'sensor-data';

  List<Sensor> get sensors {
    return [..._sensors];
  }

  final MqttServerClient client = MqttServerClient(
      'a2yj29llu7rbln-ats.iot.ca-central-1.amazonaws.com', '' //AWS server key
      //second field left blank intentionally
      );

  @override
  void dispose() {
    idTextController.dispose();
    //close csv
  }

  void writeCsvHeaders() async {
    // List<List<String>> csvHeaders = [
    //   [
    //     'time',
    //     'x',
    //     'y',
    //     'z',
    //   ]
    // ];
    // String csvData = const ListToCsvConverter().convert(csvHeaders);
    await rightSensorFile.writeAsString('time,xdata,ydata,zdata,',
        mode: FileMode.write);
    await leftSensorFile.writeAsString('time,xdata,ydata,zdata,',
        mode: FileMode.write);
    csvTitlesAdded = true;
  }

  connectAWS() async {
    String uniqueId = 'jejard-desktop'; //name of the client connecting
    //insert headers into csv files
    Future localClient = mqttConnect(client, uniqueId);
    // print('AWS connection');
  }

  disconnectAWS() {
    // client.unsubscribe(topic); //add in later?
    client.disconnect();
    isConnected = false;
  }

  bool get isStreaming {
    return stream;
  }

  void _changeStreaming() {
    if (!stream) {
      stream = true;
      notifyListeners();
    } else {
      stream = false; //added in
    }
  }

  Future<MqttServerClient> mqttConnect(
      MqttServerClient client, String uniqueId) async {
    setStatus("Connecting MQTT Broker");

    print('inside MQTT connect');

    print('connecting AWS');
    if (!csvTitlesAdded) {
      writeCsvHeaders();
    }
    ByteData rootCA = await rootBundle.load('assets/mqtt/root-CA.crt');
    ByteData deviceCert = await rootBundle.load(
        'assets/mqtt/d9704a03ad1d01fa48eb96456b0333ca9525da8252c308d0ba8a08b703e07578-certificate.pem.crt');
    //('assets/mqtt/Jejard-certificate.pem.crt');
    ByteData privateKey = await rootBundle.load(
        'assets/mqtt/d9704a03ad1d01fa48eb96456b0333ca9525da8252c308d0ba8a08b703e07578-private.pem.key');

    SecurityContext ctx = SecurityContext.defaultContext;
    ctx.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    ctx.useCertificateChainBytes(deviceCert.buffer.asUint8List());
    ctx.usePrivateKeyBytes(privateKey.buffer.asUint8List());

    client.securityContext = ctx;

    client.logging(on: true);
    client.keepAlivePeriod = 20;
    client.setProtocolV31();
    client.port = 8883;
    client.secure = true;
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnect;
    client.pongCallback = pong;

    final MqttConnectMessage connectMsg =
        MqttConnectMessage().withClientIdentifier(uniqueId).startClean();
    client.connectionMessage = connectMsg;

    print('Attempting AWS connection');

    try {
      await client.connect();
    } catch (exception) {
      print(exception);
      isConnected = false;
      client.disconnect();
    }

    client.subscribe(
        'sensor-data', MqttQos.atLeastOnce); //add more if multiple topics exist
    //topic is the name of the topic being subscribed to

    setStatus('Subscribed');

    client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage>> incomingMsg) {
      _changeStreaming();

      for (int i = 0; i < incomingMsg.length; i++) {
        if (incomingMsg[i].topic == topic) {
          //same topic name as above
          final line = incomingMsg[0].payload as MqttPublishMessage;
          final pt = MqttPublishPayload.bytesToStringAsString(
              line.payload.message); //convert from bytes to string

          print('<-- START MESSAGE -- $pt -- END -->');
          parseLine(pt); //parse the line
        } else {
          print('Unknown data');
        }
      }
    });
    return client;
  }

  dynamic get json {
    return _dataReceived;
  }

  void setStatus(String status) {
    msgStatus = status;
  }

  void onConnected() {
    setStatus('Connected to client');
  }

  void onDisconnect() {
    setStatus('Disconnected from client');
    isConnected = false;
  }

  void pong() {}

  Sensor? findByName(String id) {
    if (_sensors.isEmpty) {
      return null;
    }
    return _sensors.firstWhere((element) => element.sensorId == id);
  }

  void addSensor(Sensor sensor) {
    // final newObj = Sensor(
    //   sensorId: sensor.sensorId,
    //   timestamp: sensor.timestamp,
    //   x: sensor.x,
    //   y: sensor.y,
    //   z: sensor.z,
    //   isConnected: true,
    // );
    _sensors.add(sensor);
    hasData = true;
    notifyListeners();
  }

  void parseLine(String line) async {
    Map<String, dynamic> json = jsonDecode(line);
    try {
      var sensorToUpdate = _sensors.firstWhere(
          (element) => element.sensorId == json['sensor_id'].toString().trim());
      sensorToUpdate.isConnected = true;
      sensorToUpdate.timestamp =
          double.parse(json['timestamp_s'].toString().trim());
      sensorToUpdate.x = double.parse(json['x'].toString().trim());
      sensorToUpdate.y = double.parse(json['y'].toString().trim());
      sensorToUpdate.z = double.parse(json['z'].toString().trim());
      // print(sensorToUpdate.sensorId);
      // print(_sensors.length);
      try {
        sensorToUpdate.img = chooseImage();
      } catch (e) {
        null;
      }
      List<List<String>> data = [
        [
          sensorToUpdate.timestamp.toString(),
          sensorToUpdate.x.toString(),
          sensorToUpdate.y.toString(),
          sensorToUpdate.z.toString(),
        ]
      ];
      if (json['sensor_id'].toString().trim() == "RA") {
        String csvData = const ListToCsvConverter().convert(data);
        await rightSensorFile.writeAsString('$csvData\r\n',
            mode: FileMode.append);
      } else if (json['sensor_id'].toString().trim() == "LA") {
        String csvData = const ListToCsvConverter().convert(data);
        await leftSensorFile.writeAsString('$csvData\r\n',
            mode: FileMode.append);
      } else {}
      hasData = true;
      notifyListeners();
    } catch (ex) {
      //no sensor with existing id
      var newSensor = Sensor(
        isConnected: true,
        sensorId: json['sensor_id'].toString().trim(),
        timestamp: double.parse(json['timestamp_s'].toString().trim()),
        x: double.parse(json['x'].toString().trim()),
        y: double.parse(json['y'].toString().trim()),
        z: double.parse(json['z'].toString().trim()),
      );
      try {
        newSensor.img = chooseImage();
      } catch (e) {
        null;
      }
      // print(newSensor.sensorId);
      // print(_sensors.length);
      if (_sensors.isEmpty) {
        _sensors.insert(0, newSensor);
        // print(_sensors.length);
        List<List<String>> data = [
          [
            newSensor.timestamp.toString(),
            newSensor.x.toString(),
            newSensor.y.toString(),
            newSensor.z.toString(),
          ]
        ];
        if (json['sensor_id'].toString().trim() == "RA") {
          String csvData = const ListToCsvConverter().convert(data);
          await rightSensorFile.writeAsString('$csvData\r\n',
              mode: FileMode.append);
        } else if (json['sensor_id'].toString().trim() == "LA") {
          String csvData = const ListToCsvConverter().convert(data);
          await leftSensorFile.writeAsString('$csvData\r\n',
              mode: FileMode.append);
        } else {}
        hasData = true;
        notifyListeners();
      } else {
        try {
          //second check for timing
          var sensorToUpdate = _sensors
              .firstWhere((element) => element.sensorId == newSensor.sensorId);
        } catch (ex) {
          //sensor not found, add it
          addSensor(newSensor);
        }
      }
    }
  }

  Sensor getSensorById(String id) {
    return _sensors.firstWhere((element) => element.sensorId == id);
  }

  AssetImage chooseImage() {
    try {
      Sensor right = getSensorById("RA");
      int thresholdR = right.determineThreshold(right.x, right.y, right.z);
      Sensor left = getSensorById("LA");
      int thresholdL = left.determineThreshold(left.x, left.y, left.z);

      AssetImage img;
      if (thresholdR == 1 && thresholdL == 1) {
        //both limbs not moving, both red
        img = AssetImage('assets/images/LRRR.png');
      } else if (thresholdR == 1 && thresholdL == 2) {
        //right red, left yellow
        img = AssetImage('assets/images/LYRR.png');
      } else if (thresholdR == 1 && thresholdL == 3) {
        //right red, left green
        img = AssetImage('assets/images/LGRR.png');
      } else if (thresholdR == 2 && thresholdL == 1) {
        //right yellow, left red
        img = AssetImage('assets/images/LRRY.png');
      } else if (thresholdR == 2 && thresholdL == 2) {
        //both yellow
        img = AssetImage('assets/images/LYRY.png');
      } else if (thresholdR == 2 && thresholdL == 3) {
        //right yellow, left green
        img = AssetImage('assets/images/LGRY.png');
      } else if (thresholdR == 3 && thresholdL == 1) {
        //right green, left red
        img = AssetImage('assets/images/LRRG.png');
      } else if (thresholdR == 3 && thresholdL == 2) {
        //right green, left yellow
        img = AssetImage('assets/images/LYRG.png');
      } else if (thresholdR == 3 && thresholdL == 3) {
        //both green
        img = AssetImage('assets/images/LGRG.png');
      } else {
        //incorrect data, or empty data. Display plain silhouette
        img = AssetImage('assets/images/silhouette.png');
      }
      // notifyListeners();
      return img;
    } catch (e) {
      return AssetImage('assets/images/silhouette.png');
    }
  }
}

// /// An annotated simple subscribe/publish usage example for mqtt_server_client. Please read in with reference
// /// to the MQTT specification. The example is runnable, also refer to test/mqtt_client_broker_test...dart
// /// files for separate subscribe/publish tests.

// /// First create a client, the client is constructed with a broker name, client identifier
// /// and port if needed. The client identifier (short ClientId) is an identifier of each MQTT
// /// client connecting to a MQTT broker. As the word identifier already suggests, it should be unique per broker.
// /// The broker uses it for identifying the client and the current state of the client. If you don’t need a state
// /// to be hold by the broker, in MQTT 3.1.1 you can set an empty ClientId, which results in a connection without any state.
// /// A condition is that clean session connect flag is true, otherwise the connection will be rejected.
// /// The client identifier can be a maximum length of 23 characters. If a port is not specified the standard port
// /// of 1883 is used.
// /// If you want to use websockets rather than TCP see below.

// final client = MqttServerClient('test.mosquitto.org', '');

// var pongCount = 0; // Pong counter

// Future<int> main() async {
//   /// A websocket URL must start with ws:// or wss:// or Dart will throw an exception, consult your websocket MQTT broker
//   /// for details.
//   /// To use websockets add the following lines -:
//   /// client.useWebSocket = true;
//   /// client.port = 80;  ( or whatever your WS port is)
//   /// There is also an alternate websocket implementation for specialist use, see useAlternateWebSocketImplementation
//   /// Note do not set the secure flag if you are using wss, the secure flags is for TCP sockets only.
//   /// You can also supply your own websocket protocol list or disable this feature using the websocketProtocols
//   /// setter, read the API docs for further details here, the vast majority of brokers will support the client default
//   /// list so in most cases you can ignore this.

//   /// Set logging on if needed, defaults to off
//   client.logging(on: true);

//   /// Set the correct MQTT protocol for mosquito
//   client.setProtocolV311();

//   /// If you intend to use a keep alive you must set it here otherwise keep alive will be disabled.
//   client.keepAlivePeriod = 20;

//   /// The connection timeout period can be set if needed, the default is 5 seconds.
//   client.connectTimeoutPeriod = 2000; // milliseconds

//   /// Add the unsolicited disconnection callback
//   client.onDisconnected = onDisconnected;

//   /// Add the successful connection callback
//   client.onConnected = onConnected;

//   /// Add a subscribed callback, there is also an unsubscribed callback if you need it.
//   /// You can add these before connection or change them dynamically after connection if
//   /// you wish. There is also an onSubscribeFail callback for failed subscriptions, these
//   /// can fail either because you have tried to subscribe to an invalid topic or the broker
//   /// rejects the subscribe request.
//   client.onSubscribed = onSubscribed;

//   /// Set a ping received callback if needed, called whenever a ping response(pong) is received
//   /// from the broker.
//   client.pongCallback = pong;

//   /// Create a connection message to use or use the default one. The default one sets the
//   /// client identifier, any supplied username/password and clean session,
//   /// an example of a specific one below.
//   final connMess = MqttConnectMessage()
//       .withClientIdentifier('Mqtt_MyClientUniqueId')
//       .withWillTopic('willtopic') // If you set this you must set a will message
//       .withWillMessage('My Will message')
//       .startClean() // Non persistent session for testing
//       .withWillQos(MqttQos.atLeastOnce);
//   print('EXAMPLE::Mosquitto client connecting....');
//   client.connectionMessage = connMess;

//   /// Connect the client, any errors here are communicated by raising of the appropriate exception. Note
//   /// in some circumstances the broker will just disconnect us, see the spec about this, we however will
//   /// never send malformed messages.
//   try {
//     await client.connect();
//   } on NoConnectionException catch (e) {
//     // Raised by the client when connection fails.
//     print('EXAMPLE::client exception - $e');
//     client.disconnect();
//   } on SocketException catch (e) {
//     // Raised by the socket layer
//     print('EXAMPLE::socket exception - $e');
//     client.disconnect();
//   }

//   /// Check we are connected
//   if (client.connectionStatus!.state == MqttConnectionState.connected) {
//     print('EXAMPLE::Mosquitto client connected');
//   } else {
//     /// Use status here rather than state if you also want the broker return code.
//     print(
//         'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
//     client.disconnect();
//     exit(-1);
//   }

//   /// Ok, lets try a subscription
//   print('EXAMPLE::Subscribing to the test/lol topic');
//   const topic = 'test/lol'; // Not a wildcard topic
//   client.subscribe(topic, MqttQos.atMostOnce);

//   /// The client has a change notifier object(see the Observable class) which we then listen to to get
//   /// notifications of published updates to each subscribed topic.
//   client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
//     final recMess = c![0].payload as MqttPublishMessage;
//     final pt =
//         MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

//     /// The above may seem a little convoluted for users only interested in the
//     /// payload, some users however may be interested in the received publish message,
//     /// lets not constrain ourselves yet until the package has been in the wild
//     /// for a while.
//     /// The payload is a byte buffer, this will be specific to the topic
//     print(
//         'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
//     print('');
//   });

//   /// If needed you can listen for published messages that have completed the publishing
//   /// handshake which is Qos dependant. Any message received on this stream has completed its
//   /// publishing handshake with the broker.
//   client.published!.listen((MqttPublishMessage message) {
//     print(
//         'EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
//   });

//   /// Lets publish to our topic
//   /// Use the payload builder rather than a raw buffer
//   /// Our known topic to publish to
//   const pubTopic = 'Dart/Mqtt_client/testtopic';
//   final builder = MqttClientPayloadBuilder();
//   builder.addString('Hello from mqtt_client');

//   /// Subscribe to it
//   print('EXAMPLE::Subscribing to the Dart/Mqtt_client/testtopic topic');
//   client.subscribe(pubTopic, MqttQos.exactlyOnce);

//   /// Publish it
//   print('EXAMPLE::Publishing our topic');
//   client.publishMessage(pubTopic, MqttQos.exactlyOnce, builder.payload!);

//   /// Ok, we will now sleep a while, in this gap you will see ping request/response
//   /// messages being exchanged by the keep alive mechanism.
//   print('EXAMPLE::Sleeping....');
//   await MqttUtilities.asyncSleep(60);

//   /// Finally, unsubscribe and exit gracefully
//   print('EXAMPLE::Unsubscribing');
//   client.unsubscribe(topic);

//   /// Wait for the unsubscribe message from the broker if you wish.
//   await MqttUtilities.asyncSleep(2);
//   print('EXAMPLE::Disconnecting');
//   client.disconnect();
//   print('EXAMPLE::Exiting normally');
//   return 0;
// }

// /// The subscribed callback
// void onSubscribed(String topic) {
//   print('EXAMPLE::Subscription confirmed for topic $topic');
// }

// /// The unsolicited disconnect callback
// void onDisconnected() {
//   print('EXAMPLE::OnDisconnected client callback - Client disconnection');
//   if (client.connectionStatus!.disconnectionOrigin ==
//       MqttDisconnectionOrigin.solicited) {
//     print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
//   } else {
//     print(
//         'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
//     exit(-1);
//   }
//   if (pongCount == 3) {
//     print('EXAMPLE:: Pong count is correct');
//   } else {
//     print('EXAMPLE:: Pong count is incorrect, expected 3. actual $pongCount');
//   }
// }

// /// The successful connect callback
// void onConnected() {
//   print(
//       'EXAMPLE::OnConnected client callback - Client connection was successful');
// }

// /// Pong callback
// void pong() {
//   print('EXAMPLE::Ping response client callback invoked');
//   pongCount++;
// }
