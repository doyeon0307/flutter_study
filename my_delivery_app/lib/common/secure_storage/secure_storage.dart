import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// provider가 한 번 생성되면
// 프로그램 내내 하나의 storage 인스턴스를 사용하게 된다
final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => FlutterSecureStorage(),
);
