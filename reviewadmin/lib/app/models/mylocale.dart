class MyLocale {
  final String countryCode;
  final String dialCode;

  MyLocale(this.countryCode, this.dialCode);

  @override
  String toString() {
    return 'MyLocale(countryCode: $countryCode, dialCode: $dialCode)';
  }
}
