class Unit {
  final String name;
  final double factor;
  final String hint; // short mnemonic or formula for this unit

  Unit(this.name, this.factor, [this.hint = '']);
}
