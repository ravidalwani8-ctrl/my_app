class Converters {
  // -------------------------
  // TEMPERATURE → Convert any to Celsius
  // -------------------------
  static double toCelsius(String from, double value) {
    switch (from) {
      case "Celsius":
        return value;

      case "Fahrenheit":
        return (value - 32) * 5 / 9;

      case "Kelvin":
        return value - 273.15;

      default:
        return value;
    }
  }

  // -------------------------
  // Convert Celsius → Target unit
  // -------------------------
  static double fromCelsius(String to, double celsius) {
    switch (to) {
      case "Celsius":
        return celsius;

      case "Fahrenheit":
        return (celsius * 9 / 5) + 32;

      case "Kelvin":
        return celsius + 273.15;

      default:
        return celsius;
    }
  }

  // -------------------------
  // CUSTOM UNITS
  // Example: 1 A = X B
  // -------------------------
  static double convertCustom(double input, double a, double b) {
    // input * (B / A)
    return input * (b / a);
  }

  // -------------------------
  // Factor-based units
  // Example: value in fromFactor -> toFactor
  // -------------------------
  static double convertByFactors(
    double value,
    double fromFactor,
    double toFactor,
  ) {
    final baseValue = value * fromFactor;
    return baseValue / toFactor;
  }
}
