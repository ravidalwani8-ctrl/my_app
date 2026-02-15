import '../models/unit.dart';
import '../models/category.dart';

final List<Category> allCategories = [
  // LENGTH
  Category(
    name: "Length",
    units: [
      Unit("Meter", 1, 'Base unit for length.'),
      Unit("Kilometer", 1000, '1 km = 1000 m'),
      Unit("Centimeter", 0.01, '100 cm = 1 m'),
      Unit("Millimeter", 0.001, '1000 mm = 1 m'),
      Unit("Foot", 0.3048, '1 ft = 0.3048 m'),
      Unit("Inch", 0.0254, '1 in = 2.54 cm'),
      Unit("Mile", 1609.34, '1 mile ≈ 1609.34 m'),
    ],
  ),

  // WEIGHT
  Category(
    name: "Weight",
    units: [
      Unit("Kilogram", 1, '1 kg = 1000 g'),
      Unit("Gram", 0.001, '1 g = 0.001 kg'),
      Unit("Milligram", 0.000001, '1 mg = 0.001 g'),
      Unit("Pound", 0.453592, '1 lb ≈ 0.453592 kg'),
      Unit("Ounce", 0.0283495, '1 oz ≈ 28.3495 g'),
    ],
  ),

  // TIME
  Category(
    name: "Time",
    units: [
      Unit("Second", 1, 'Base unit for time'),
      Unit("Minute", 60, '1 min = 60 s'),
      Unit("Hour", 3600, '1 hr = 60 min'),
      Unit("Day", 86400, '1 day = 24 hr'),
      Unit("Week", 604800, '1 week = 7 days'),
    ],
  ),

  // ENERGY
  Category(
    name: "Energy",
    units: [
      Unit("Joule", 1, 'Energy unit (J)'),
      Unit("Kilojoule", 1000, '1 kJ = 1000 J'),
      Unit("Calorie", 4.184, '1 cal = 4.184 J'),
      Unit("Kilocalorie", 4184, '1 kcal = 4184 J'),
      Unit("Watt-hour", 3600, '1 Wh = 3600 J'),
      Unit("Kilowatt-hour", 3600000, '1 kWh = 3,600,000 J'),
    ],
  ),

  // SPEED
  Category(
    name: "Speed",
    units: [
      Unit("m/s", 1, 'Meters per second'),
      Unit("km/h", 0.277778, '1 km/h ≈ 0.27778 m/s'),
      Unit("mph", 0.44704, '1 mph ≈ 0.44704 m/s'),
      Unit("knot", 0.514444, '1 knot ≈ 0.514444 m/s'),
    ],
  ),

  // PRESSURE
  Category(
    name: "Pressure",
    units: [
      Unit("Pascal", 1, 'Pa'),
      Unit("kPa", 1000, '1 kPa = 1000 Pa'),
      Unit("bar", 100000, '1 bar = 100000 Pa'),
      Unit("atm", 101325, '1 atm ≈ 101325 Pa'),
      Unit("psi", 6894.76, '1 psi ≈ 6894.76 Pa'),
    ],
  ),

  // DATA STORAGE
  Category(
    name: "Data",
    units: [
      Unit("Byte", 1, 'Base unit (B)'),
      Unit("Kilobyte", 1024, '1 KB = 1024 B'),
      Unit("Megabyte", 1024 * 1024, '1 MB = 1024 KB'),
      Unit("Gigabyte", 1024 * 1024 * 1024, '1 GB = 1024 MB'),
      Unit("Terabyte", 1024 * 1024 * 1024 * 1024, '1 TB = 1024 GB'),
    ],
  ),

  // NOTE: Temperature handled separately via temperature_screen.dart
];
