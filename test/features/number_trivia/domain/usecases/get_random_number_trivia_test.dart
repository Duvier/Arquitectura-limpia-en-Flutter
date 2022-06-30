import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivial.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

// class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository  {}
@GenerateMocks([NumberTriviaRepository])

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mocNumberTriviaRepository;

  // setUp((){
    mocNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mocNumberTriviaRepository);
  // });

  const NumberTrivia tNumberTrivia =  NumberTrivia(number: 1, text: 'test');

  test('Should get trivia from the repository', () async {
      // "On the fly" implementation of the Repository using the Mockito package.
      // When getConcreteNumberTrivia is called with any argument, always answer with
      // the Right "side" of Either containing a test NumberTrivia object.
      when(mocNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async =>  const Right(tNumberTrivia));
      // The "act" phase of the test. Call the not-yet-existent method.
      final result = await usecase(NoParams());
      // UseCase should simply return whatever was returned from the Repository
      expect(result, const Right(tNumberTrivia));
      // Verify that the method has been called on the Repository
      verify(mocNumberTriviaRepository.getRandomNumberTrivia());
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mocNumberTriviaRepository);
  });

}