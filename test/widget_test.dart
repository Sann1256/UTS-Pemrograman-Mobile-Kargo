import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('staff can sign in and reach the cargo dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CargoFlowApp());

    expect(find.text('Masuk staf lapangan'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), 'Pegawai');
    await tester.enterText(find.byType(TextField).at(1), '1234');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Manifes Muatan'), findsWidgets);
    expect(find.text('Armada tersedia'), findsOneWidget);
    expect(find.text('Colt Diesel'), findsOneWidget);
  });

  testWidgets('invalid staff credentials show a warning', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CargoFlowApp());
    await tester.enterText(find.byType(TextField).at(0), 'Pegawai');
    await tester.enterText(find.byType(TextField).at(1), 'salah');
    await tester.tap(find.text('Masuk'));
    await tester.pump();

    expect(find.text('ID staf atau kata sandi salah.'), findsOneWidget);
  });

  testWidgets('confirmed cargo booking returns a receipt to the dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CargoFlowApp());
    await tester.enterText(find.byType(TextField).at(0), 'Pegawai');
    await tester.enterText(find.byType(TextField).at(1), '1234');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView).first, const Offset(0, -280));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pilih Armada').first);
    await tester.pumpAndSettle();
    expect(find.text('Booking Kargo'), findsOneWidget);

    await tester.drag(find.byType(ListView).last, const Offset(0, -500));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('destinationField')), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('destinationField')),
      'Bandung',
    );
    tester.testTextInput.hide();
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Hitung biaya logistik'),
      200,
      scrollable: find
          .descendant(
            of: find.byType(ListView).last,
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hitung biaya logistik'));
    await tester.pumpAndSettle();
    expect(find.text('Rincian Biaya Surat Jalan'), findsOneWidget);

    await tester.tap(find.text('Konfirmasi penerbitan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya, terbitkan'));
    await tester.pumpAndSettle();

    expect(find.textContaining('berhasil diterbitkan.'), findsOneWidget);
    expect(find.text('Bandung'), findsWidgets);
  });
}
