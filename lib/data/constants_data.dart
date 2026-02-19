class ScientificConstant {
  final String category;
  final String name;
  final String symbol;
  final String value;

  const ScientificConstant({
    required this.category,
    required this.name,
    required this.symbol,
    required this.value,
  });
}

const List<ScientificConstant> scientificConstants = [
  ScientificConstant(
    category: "Mathematics",
    name: "Pi",
    symbol: "π",
    value: "3.141592653589793",
  ),
  ScientificConstant(
    category: "Mathematics",
    name: "Euler's Number",
    symbol: "e",
    value: "2.718281828459045",
  ),
  ScientificConstant(
    category: "Mechanics & Gravitation",
    name: "Speed of Light",
    symbol: "c",
    value: "2.99792458 × 10⁸ m/s",
  ),
  ScientificConstant(
    category: "Mechanics & Gravitation",
    name: "Gravitational Constant",
    symbol: "G",
    value: "6.67430 × 10⁻¹¹ N·m²/kg²",
  ),
  ScientificConstant(
    category: "Mechanics & Gravitation",
    name: "Standard Gravity",
    symbol: "g",
    value: "9.80665 m/s²",
  ),
  ScientificConstant(
    category: "Mechanics & Gravitation",
    name: "Earth Mass",
    symbol: "M⊕",
    value: "5.9722 × 10²⁴ kg",
  ),
  ScientificConstant(
    category: "Mechanics & Gravitation",
    name: "Astronomical Unit",
    symbol: "au",
    value: "1.495978707 × 10¹¹ m",
  ),
  ScientificConstant(
    category: "Quantum & Atomic Physics",
    name: "Planck Constant",
    symbol: "h",
    value: "6.62607015 × 10⁻³⁴ J·s",
  ),
  ScientificConstant(
    category: "Quantum & Atomic Physics",
    name: "Reduced Planck Constant",
    symbol: "ħ",
    value: "1.054571817 × 10⁻³⁴ J·s",
  ),
  ScientificConstant(
    category: "Quantum & Atomic Physics",
    name: "Elementary Charge",
    symbol: "q",
    value: "1.602176634 × 10⁻¹⁹ C",
  ),
  ScientificConstant(
    category: "Quantum & Atomic Physics",
    name: "Electron Mass",
    symbol: "mₑ",
    value: "9.1093837015 × 10⁻³¹ kg",
  ),
  ScientificConstant(
    category: "Thermodynamics & Chemistry",
    name: "Boltzmann Constant",
    symbol: "k",
    value: "1.380649 × 10⁻²³ J/K",
  ),
  ScientificConstant(
    category: "Thermodynamics & Chemistry",
    name: "Gas Constant",
    symbol: "R",
    value: "8.314462618 J/(mol·K)",
  ),
  ScientificConstant(
    category: "Thermodynamics & Chemistry",
    name: "Avogadro Constant",
    symbol: "Nₐ",
    value: "6.02214076 × 10²³ mol⁻¹",
  ),
  ScientificConstant(
    category: "Thermodynamics & Chemistry",
    name: "Faraday Constant",
    symbol: "F",
    value: "96485.33212 C/mol",
  ),
  ScientificConstant(
    category: "Electromagnetism",
    name: "Vacuum Permittivity",
    symbol: "ε₀",
    value: "8.8541878128 × 10⁻¹² F/m",
  ),
  ScientificConstant(
    category: "Electromagnetism",
    name: "Vacuum Permeability",
    symbol: "μ₀",
    value: "1.25663706212 × 10⁻⁶ N/A²",
  ),
];
