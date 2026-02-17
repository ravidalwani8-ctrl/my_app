
class ScientificConstant {
  final String name;
  final String symbol;
  final String value;

  const ScientificConstant({
    required this.name,
    required this.symbol,
    required this.value,
  });
}

const List<ScientificConstant> scientificConstants = [
  ScientificConstant(name: "Speed of Light", symbol: "c", value: "3 × 10⁸ m/s"),
  ScientificConstant(
    name: "Gravitational Constant",
    symbol: "G",
    value: "6.674 × 10⁻¹¹ N·m²/kg²",
  ),
  ScientificConstant(
    name: "Planck Constant",
    symbol: "h",
    value: "6.626 × 10⁻³⁴ J·s",
  ),
  ScientificConstant(
    name: "Avogadro Number",
    symbol: "Nᴀ",
    value: "6.022 × 10²³",
  ),
  ScientificConstant(name: "Earth Gravity", symbol: "g", value: "9.8 m/s²"),
  ScientificConstant(
    name: "Boltzmann Constant",
    symbol: "k",
    value: "1.381 × 10⁻²³ J/K",
  ),
  ScientificConstant(
    name: "Gas Constant",
    symbol: "R",
    value: "8.314 J/(mol·K)",
  ),
  ScientificConstant(
    name: "Avogadro's Number",
    symbol: "Nₐ",
    value: "6.022 × 10²³ mol⁻¹",
  ),
  ScientificConstant(name: "Pi", symbol: "π", value: "3.14159"),
];
