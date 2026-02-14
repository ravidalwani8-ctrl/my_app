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
];
