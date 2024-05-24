// ignore_for_file: cascade_invocations, avoid_dynamic_calls, strict_raw_type, lines_longer_than_80_chars, omit_local_variable_types, prefer_final_locals
import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:firedart/firestore/firestore.dart';

Future<Object> onRequest(RequestContext context) async {
  return switch(context.request.method){
    HttpMethod.get => getRequestHandler(),
    HttpMethod.post => _postRequestHandler(context),
    _ => await Future.value(
      Response.json(
        body: 'Missing function for that', 
        statusCode: HttpStatus.methodNotAllowed,
      ),
    ),
  };  
}
Future<Response> _postRequestHandler(RequestContext context) async {
  List data = await Firestore.instance.collection('users').get();
  final request = await context.request.json() as Map<String, dynamic>;
  String? name = request['name'] as String?;
  bool? married = request['married'] as bool?;
  final user = User(id: data.length + 1, name: name!, married: married!);
  final id = await Firestore.instance.collection('users').add(User.toJson(user)).then((doc){
    return doc.id;
  });
  return Response.json(
    body: {
      'message': 'User created succesfully',
      'id': id,
    },
  );
}

Future<Response> getRequestHandler() async {
  List<Map<String, dynamic>> usersList = <Map<String, dynamic>>[];
  await Firestore.instance.collection('users').get().then((docs){
    for(var doc in docs){
      usersList.add(doc.map);
    }
  });
  return Response.json(
    body: {
      'message': 'User retrieved succesfully',
      'user': usersList,
    },
  );
}

class User{
  User({
    required this.id,
    required this.name,
    required this.married,
  });

  final int id;
  final String name;
  final bool married;

  static Map<String, dynamic> toJson(User user){
    return {
      'id': user.id,
      'name': user.name,
      'married': user.married,
    };
  }
}

List<User> users = <User>[];
