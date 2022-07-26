import 'dart:convert';
import 'dart:io';

import 'package:cubit_flutter/bloc/bloc_actions.dart';
import 'package:cubit_flutter/bloc/persons_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/person.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Flutter demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => PersonBloc(),
        child: const HomePage(),
      ),
    ),
  );
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(children: [
        Row(
          children: [
            TextButton(
              onPressed: () {
                context.read()<PersonBloc>().add(
                      const LoadPersonAction(
                        url: person1Url,
                        loader: getPersons,
                      ),
                    );
              },
              child: const Text("Load Json #1"),
            ),
            TextButton(
              onPressed: () {
                context.read()<PersonBloc>().add(
                      const LoadPersonAction(
                        url: person2Url,
                        loader: getPersons,
                      ),
                    );
              },
              child: const Text("Load Json #2"),
            ),
          ],
        ),
        BlocBuilder<PersonBloc, FetchResult?>(
          buildWhen: (previousResult, currentResult) {
            return previousResult?.persons != currentResult?.persons;
          },
          builder: ((context, fetchResult) {
            final persons = fetchResult?.persons;
            if (persons == null) {
              return const SizedBox();
            }
            return Expanded(
              child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index]!;
                    return ListTile(
                        title: Text(
                      person.name,
                    ));
                  }),
            );
          }),
        )
      ]),
    );
  }
}
