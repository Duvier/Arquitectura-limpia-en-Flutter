import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivial.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(Empty()) {
    on<GetTriviaForConcreteNumber>((event, emit) async {
      await _getTriviaForConcreteNumber(event, emit);
    });
    on<GetTriviaForRandomNumber>((event, emit) async {
      await _getTriviaForRandomNumber(event, emit);
    });
  }

  Future<void> _getTriviaForConcreteNumber(event, emit) async {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    await inputEither.fold(
      (failure) {
        emit(const Error(message: invalidInputFailureMessage));
      },
      (integer) async {
        emit(Loading());
        final failureOrTrivia = await getConcreteNumberTrivia(
          Params(number: integer),
        );
        await failureOrTrivia.fold(
          (failure) => emit(Error(
            message: _mapFailureToMessage(failure),
          )),
          (trivia) => emit(Loaded(numberTrivia: trivia)),
        );
      },
    );
  }

  Future<void> _getTriviaForRandomNumber(event, emit) async {
    emit(Loading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    failureOrTrivia.fold(
      (failure) => emit(Error(message: _mapFailureToMessage(failure))),
      (trivia) => emit(Loaded(numberTrivia: trivia)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected Error';
    }
  }
}
