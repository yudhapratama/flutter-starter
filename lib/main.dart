import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/utils/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize LocalStorageService untuk data dummy
  await LocalStorageService.init();
  
  runApp(const ProviderScope(child: MyApp()));
}
