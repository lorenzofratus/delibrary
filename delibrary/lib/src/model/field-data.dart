class FieldData {
  final String text;
  final String label;
  final String Function(String) validator;
  final bool obscurable;

  FieldData({
    this.text = "",
    this.label = "",
    this.validator,
    this.obscurable = false,
  });
}
