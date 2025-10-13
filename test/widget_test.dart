import 'package:finovate_app/screens/splash/splash_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finovate_app/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FinovateApp());

    // Verify splash screen loads
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}