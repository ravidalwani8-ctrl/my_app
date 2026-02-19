import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/utils/converters.dart';

void main() {
  group('Converters.toCelsius', () {
    test('Celsius to Celsius is identity', () {
      expect(Converters.toCelsius('Celsius', 25), closeTo(25, 1e-9));
    });

    test('Fahrenheit to Celsius', () {
      expect(Converters.toCelsius('Fahrenheit', 32), closeTo(0, 1e-9));
      expect(Converters.toCelsius('Fahrenheit', 212), closeTo(100, 1e-9));
    });

    test('Kelvin to Celsius', () {
      expect(Converters.toCelsius('Kelvin', 273.15), closeTo(0, 1e-9));
      expect(Converters.toCelsius('Kelvin', 373.15), closeTo(100, 1e-9));
    });
  });

  group('Converters.fromCelsius', () {
    test('Celsius to Fahrenheit', () {
      expect(Converters.fromCelsius('Fahrenheit', 0), closeTo(32, 1e-9));
      expect(Converters.fromCelsius('Fahrenheit', 100), closeTo(212, 1e-9));
    });

    test('Celsius to Kelvin', () {
      expect(Converters.fromCelsius('Kelvin', 0), closeTo(273.15, 1e-9));
      expect(Converters.fromCelsius('Kelvin', 100), closeTo(373.15, 1e-9));
    });
  });

  group('Converters.convertCustom', () {
    test('converts using ratio b / a', () {
      expect(Converters.convertCustom(2, 1, 3), closeTo(6, 1e-9));
      expect(Converters.convertCustom(10, 2, 5), closeTo(25, 1e-9));
    });
  });
}
