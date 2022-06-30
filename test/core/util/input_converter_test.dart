import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/input_converter.dart';

void main() {
  InputConverter inputConverter;
  inputConverter = InputConverter();
  group('stringToUnsignedInt', () {
    test(
      'should return a integer when the string represents an unsigned integer',
      () {
        //arrange
        const tNumberString = '123';
        //act
        final result = inputConverter.stringToUnsignedInteger(tNumberString);
        //assert
        expect(result, const Right(123));
      },
    );

    test(
      'should return a failure when the string is not an integer',
      () {
        //arrange
        const tNumberString = 'abc';
        //act
        final result = inputConverter.stringToUnsignedInteger(tNumberString);
        //assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
    test(
      'should return a failure when the string is a negative integer',
      () {
        //arrange
        const tNumberString = '-123';
        //act
        final result = inputConverter.stringToUnsignedInteger(tNumberString);
        //assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
