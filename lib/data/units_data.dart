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
      Unit("Micrometer", 0.000001, '1 μm = 0.000001 m'),
      Unit("Foot", 0.3048, '1 ft = 0.3048 m'),
      Unit("Inch", 0.0254, '1 in = 2.54 cm'),
      Unit("Yard", 0.9144, '1 yd = 0.9144 m'),
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
      Unit("Month", 2592000, '1 month ≈ 30 days'),
      Unit("Year", 31536000, '1 year = 365 days'),
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
      Unit("ft/s", 0.3048, '1 ft/s = 0.3048 m/s'),
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
      Unit("mmHg", 133.322, '1 mmHg ≈ 133.322 Pa'),
      Unit("Torr", 133.322, '1 Torr ≈ 133.322 Pa'),
    ],
  ),

  // DATA STORAGE
  Category(
    name: "Data",
    units: [
      Unit("Bit", 0.125, '8 bits = 1 Byte'),
      Unit("Byte", 1, 'Base unit (B)'),
      Unit("Kilobyte", 1024, '1 KB = 1024 B'),
      Unit("Megabyte", 1024 * 1024, '1 MB = 1024 KB'),
      Unit("Gigabyte", 1024 * 1024 * 1024, '1 GB = 1024 MB'),
      Unit("Terabyte", 1024 * 1024 * 1024 * 1024, '1 TB = 1024 GB'),
    ],
  ),

  // AREA
  Category(
    name: "Area",
    units: [
      Unit("Square meter", 1, 'Base unit (m²)'),
      Unit("Square kilometer", 1000000, '1 km² = 1,000,000 m²'),
      Unit("Square centimeter", 0.0001, '1 cm² = 0.0001 m²'),
      Unit("Square millimeter", 0.000001, '1 mm² = 0.000001 m²'),
      Unit("Square foot", 0.092903, '1 ft² ≈ 0.092903 m²'),
      Unit("Square inch", 0.00064516, '1 in² = 0.00064516 m²'),
      Unit("Square mile", 2589990, '1 mi² ≈ 2,589,990 m²'),
      Unit("Acre", 4046.8564224, '1 acre ≈ 4046.856 m²'),
      Unit("Hectare", 10000, '1 hectare = 10,000 m²'),
    ],
  ),

  // POWER
  Category(
    name: "Power",
    units: [
      Unit("Watt", 1, 'Base unit (W)'),
      Unit("Kilowatt", 1000, '1 kW = 1000 W'),
      Unit("Megawatt", 1000000, '1 MW = 1,000,000 W'),
      Unit("Horsepower", 745.7, '1 hp ≈ 745.7 W'),
    ],
  ),

  // FREQUENCY
  Category(
    name: "Frequency",
    units: [
      Unit("Hertz", 1, 'Base unit (Hz)'),
      Unit("Kilohertz", 1000, '1 kHz = 1000 Hz'),
      Unit("Megahertz", 1000000, '1 MHz = 1,000,000 Hz'),
      Unit("Gigahertz", 1000000000, '1 GHz = 1,000,000,000 Hz'),
      Unit("RPM", 1 / 60, '1 RPM = 1/60 Hz'),
    ],
  ),

  // NOTE: Temperature handled separately via temperature_screen.dart
];
