import 'dart:io';
import 'package:http/io_client.dart';

IOClient createIOClientWithInsecureConnection() {
  final httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
  return IOClient(httpClient);
}
