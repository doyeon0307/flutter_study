import 'package:flutter_riverpod/flutter_riverpod.dart';

// 이건 일반적인 Future Provider
// final familyModifierProvider = FutureProvider<List<int>>(
//   (ref) async {
//     await Future.delayed(Duration(seconds: 2));
//     return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
//   },
// );

// Family Modifier
// family는 두 번째 파라미터가 팔요하다 (data, generic에는 data의 타입)
final familyModifierProvider = FutureProvider.family<List<int>, int>(
  (ref, data) async {
    await Future.delayed(Duration(seconds: 2));
    return List.generate(5, (index) => index * data);
  },
);
