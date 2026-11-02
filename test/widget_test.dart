import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_commerce/app/app.dart';

void main() {
  testWidgets('opens after checking the saved session', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const EcommerceApp());
    await tester.pump();

    expect(find.text('Welcome Back To Route'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });
}
