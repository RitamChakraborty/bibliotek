import 'package:bibliotek/widgets/value_tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ValueTile Widget test', (WidgetTester tester) async {
    await tester.pumpWidget(ValueTile(
      label: "L",
      value: "V",
    ));

    Finder labelFinder = find.text("L");
    Finder valueFinder = find.text("V");

    expect(labelFinder, findsOneWidget);
    expect(valueFinder, findsOneWidget);
  });
}
