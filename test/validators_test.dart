import 'package:flutter_test/flutter_test.dart';
import 'package:myportfolio/utils/validators.dart';

/// Un validator retourne null si la valeur est bonne, un message sinon.
void main() {
  test('required : vide refusé, trop long refusé', () {
    final validator = Validators.required('Le titre', max: 5);
    expect(validator(''), 'Le titre est obligatoire.');
    expect(validator('   '), 'Le titre est obligatoire.');
    expect(validator('Trop long'), isNotNull);
    expect(validator('OK'), isNull);
  });

  test('email', () {
    expect(Validators.email('louatiyessine70@gmail.com'), isNull);
    expect(Validators.email('pas-un-email'), isNotNull);
    expect(Validators.email(''), isNotNull);
  });

  test('phone', () {
    expect(Validators.phone('+216 58 636 767'), isNull);
    expect(Validators.phone('12'), isNotNull);
    expect(Validators.phone('abc12345678'), isNotNull);
  });

  test('year', () {
    expect(Validators.year('2026'), isNull);
    expect(Validators.year('1990'), isNotNull);
    expect(Validators.year('deux mille'), isNotNull);
  });

  test('optionalUrl : vide accepté, https exigé sinon', () {
    expect(Validators.optionalUrl(''), isNull);
    expect(Validators.optionalUrl('https://github.com/louatiyessine'), isNull);
    expect(Validators.optionalUrl('github.com'), isNotNull);
  });

  test('optionalGithubLogin', () {
    expect(Validators.optionalGithubLogin(''), isNull);
    expect(Validators.optionalGithubLogin('louatiyessine'), isNull);
    expect(Validators.optionalGithubLogin('nom avec espaces'), isNotNull);
  });
}
