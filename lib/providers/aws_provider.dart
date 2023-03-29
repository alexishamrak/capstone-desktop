import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jejard_desktop/models/silhouette.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
// import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import '../models/sensor.dart';

class AWSProvider with ChangeNotifier {
  String msgStatus = 'Status';
  dynamic _dataReceived;
  List<Sensor> _sensors = [];
  Silhouette _silhouette = Silhouette();
  bool isConnected = false; //true when server connected
  bool stream = false; //true when data is transmitted
  bool hasData = false;
  File rightSensorFile = File('right.csv');
  File leftSensorFile = File('left.csv');
  TextEditingController idTextController =
      TextEditingController(); //may delete later
  bool csvTitlesAdded = false;

  String topic = 'sensor-data';
  final FileStorage files = FileStorage();

  List<Sensor> get sensors {
    return [..._sensors];
  }

  Silhouette get person {
    return _silhouette;
  }

  final MqttServerClient client = MqttServerClient(
      'a2yj29llu7rbln-ats.iot.ca-central-1.amazonaws.com', '' //AWS server key
      //second field left blank intentionally
      );

  @override
  void dispose() {
    idTextController.dispose();
  }

  connectAWS() async {
    String uniqueId = 'jejard-desktop'; //name of the client connecting
    //insert headers into csv files
    Future localClient = mqttConnect(client, uniqueId);
  }

  disconnectAWS() {
    // client.unsubscribe(topic); //add in later?
    client.disconnect();
    isConnected = false;
  }

  bool get isStreaming {
    return stream;
  }

  Future<MqttServerClient> mqttConnect(
      MqttServerClient client, String uniqueId) async {
    setStatus("Connecting MQTT Broker");

    // print('inside MQTT connect');

    // print('connecting AWS');
    if (!csvTitlesAdded) {
      files.writeHeaderLeft();
      files.writeHeaderRight();
    }
    ByteData rootCA = await rootBundle.load('assets/mqtt/root-CA.crt');
    ByteData deviceCert = await rootBundle.load(
        'assets/mqtt/d9704a03ad1d01fa48eb96456b0333ca9525da8252c308d0ba8a08b703e07578-certificate.pem.crt');
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

    try {
      await client.connect();
    } catch (exception) {
      isConnected = false;
      client.disconnect();
    }

    client.subscribe(
        'sensor-data', MqttQos.atLeastOnce); //add more if multiple topics exist
    //topic is the name of the topic being subscribed to

    setStatus('Subscribed');
    stream = true;

    client.updates!
        .listen((List<MqttReceivedMessage<MqttMessage>> incomingMsg) {
      stream = true;
      for (int i = 0; i < incomingMsg.length; i++) {
        if (incomingMsg[i].topic == topic) {
          //same topic name as above
          final line = incomingMsg[0].payload as MqttPublishMessage;
          final pt = MqttPublishPayload.bytesToStringAsString(
              line.payload.message); //convert from bytes to string

          print('<-- START MESSAGE -- $pt -- END -->');
          if (pt.contains("Stream terminating")) {
            stream = false; //stop receiving data
            //notifyListeners?? delete _sensor?
            //POTENTIAL ERRORS HERE
          }
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

  void pong() {
    // _changeStreaming();
    // if (_sensors.isNotEmpty) {
    //   stream = false;
    //   _sensors = [];
    //   notifyListeners();
    // }
  }

  Sensor? findByName(String id) {
    if (_sensors.isEmpty) {
      return null;
    }
    return _sensors.firstWhere((element) => element.sensorId == id);
  }

  void changeUI(Object error) {
    return;
  }

  void addSensor(Sensor sensor) {
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
      try {
        // sensorToUpdate.img = chooseImage();
        _silhouette.img = chooseImage();
      } catch (e) {
        null;
      }
      if (json['sensor_id'].toString().trim() == "RA") {
        String csvData =
            '${sensorToUpdate.timestamp},${sensorToUpdate.x.toString()},${sensorToUpdate.y.toString()},${sensorToUpdate.z.toString()}';
        files.writeLineRight(csvData);
      } else if (json['sensor_id'].toString().trim() == "LA") {
        String csvData =
            '${sensorToUpdate.timestamp},${sensorToUpdate.x.toString()},${sensorToUpdate.y.toString()},${sensorToUpdate.z.toString()}';
        files.writeLineLeft(csvData);
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
        // newSensor.img = chooseImage();
        _silhouette.img = chooseImage();
      } catch (e) {
        null;
      }
      if (_sensors.isEmpty) {
        _sensors.insert(0, newSensor);
        if (json['sensor_id'].toString().trim() == "RA") {
          String csvData =
              '${newSensor.timestamp},${newSensor.x.toString()},${newSensor.y.toString()},${newSensor.z.toString()}';
          files.writeLineRight(csvData);
        } else if (json['sensor_id'].toString().trim() == "LA") {
          String csvData =
              '${newSensor.timestamp},${newSensor.x.toString()},${newSensor.y.toString()},${newSensor.z.toString()}';
          files.writeLineLeft(csvData);
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

class FileStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFileRight async {
    final path = await _localPath;
    return File('$path/right.csv');
  }

  Future<File> get _localFileLeft async {
    final path = await _localPath;
    return File('$path/left.csv');
  }

  Future<int> readRightFile() async {
    try {
      final file = await _localFileRight;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<int> readLeftFile() async {
    try {
      final file = await _localFileLeft;

      // Read the file
      final contents = await file.readAsString();

      return 1;
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeHeaderRight() async {
    final rightFile = await _localFileRight;
    return rightFile.writeAsString('time,x,y,z\n', mode: FileMode.append);
  }

  Future<File> writeHeaderLeft() async {
    final leftFile = await _localFileLeft;
    return leftFile.writeAsString('time,x,y,z\n', mode: FileMode.append);
  }

  Future<File> writeLineRight(String line) async {
    final file = await _localFileRight;
    return file.writeAsString('$line\n', mode: FileMode.append);
    // Write the file
    // return file.writeAsString('$counter\n', mode: FileMode.append);
  }

  Future<File> writeLineLeft(String line) async {
    final file = await _localFileLeft;
    return file.writeAsString('$line\n', mode: FileMode.append);
    // Write the file
    // return file.writeAsString('$counter\n', mode: FileMode.append);
  }
}
