import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/esports_services.dart';
import 'package:finalproject_npinkelton_ksmith_nsmith_msmith/data_parser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(() {
    HttpOverrides.global = _DevHttpOverrides();
    return true;
  }());
  await dotenv.load(fileName: '.env');
  runApp(const MaterialApp(home: EligibilityScreen()));
}

class _DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}

class EligibilityScreen extends StatefulWidget {
  const EligibilityScreen({super.key});
}
