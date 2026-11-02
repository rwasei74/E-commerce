import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Future.wait([
    Hive.openBox<String>('cart_cache'),
    Hive.openBox<String>('wishlist_cache'),
  ]);
  runApp(const EcommerceApp());
}
