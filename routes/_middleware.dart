import 'package:dart_frog/dart_frog.dart';
import 'package:firedart/firestore/firestore.dart';

Handler middleware(Handler handler) {
  return (context) async {
    if(!Firestore.initialized){
      Firestore.initialize('todolist-6e402');
    }

    final response = await handler(context);

    return response;
  };
}
