import 'package:cubit_flutter/bloc/bloc_actions.dart';
import 'package:cubit_flutter/bloc/person.dart';
import 'package:cubit_flutter/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

const mockedPersons1 = [
  Person(
    name: "Foo",
    age: 20,
  ),
  Person(
    name: "Bar",
    age: 25,
  ),
];

const mockedPersons2 = [
  Person(
    name: "Foo",
    age: 20,
  ),
  Person(
    name: "Bar",
    age: 25,
  ),
];

Future<Iterable<Person>> mockGetPersons1(String _) =>
    Future.value(mockedPersons1);
Future<Iterable<Person>> mockGetPersons2(String _) =>
    Future.value(mockedPersons2);

void main() {
  group(
    'Testing Bloc',
    () {
      late PersonBloc bloc;
      setUp(() {
        bloc = PersonBloc();
      });
      //arrange,

      //act,
      blocTest<PersonBloc, FetchResult?>(
        "Test initial state",
        build: () => bloc,
        verify: (bloc) => expect(null, bloc.state),
      );
      //fetch data for the first mocked data and compare it with FetchResult
      blocTest<PersonBloc, FetchResult?>(
          "Mock receiving person from first iteration",
          build: () => bloc,
          act: (bloc) {
            bloc.add(
              const LoadPersonAction(
                loader: mockGetPersons1,
                url: "dummy_url1",
              ),
            );
            bloc.add(
              const LoadPersonAction(
                loader: mockGetPersons1,
                url: "dummy_url1",
              ),
            );
          },
          expect: () => [
                const FetchResult(
                  persons: mockedPersons1,
                  isRetrievedFromCache: false,
                ),
                const FetchResult(
                  persons: mockedPersons1,
                  isRetrievedFromCache: true,
                ),
              ]);
      //fetch data on the second mocked data and compare it with FetchResult
      blocTest<PersonBloc, FetchResult?>(
          "Mock receiving person from first iteration",
          build: () => bloc,
          act: (bloc) {
            bloc.add(
              const LoadPersonAction(
                loader: mockGetPersons2,
                url: "dummy_url2",
              ),
            );
            bloc.add(
              const LoadPersonAction(
                loader: mockGetPersons2,
                url: "dummy_url2",
              ),
            );
          },
          expect: () => [
                const FetchResult(
                  persons: mockedPersons2,
                  isRetrievedFromCache: false,
                ),
                const FetchResult(
                  persons: mockedPersons2,
                  isRetrievedFromCache: true,
                ),
              ]);
      //assert,
    },
  );
}
