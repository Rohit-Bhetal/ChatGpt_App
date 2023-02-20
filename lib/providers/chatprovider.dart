import 'package:chatgptapp/models/chat_model.dart';
import 'package:chatgptapp/services/service_api.dart';
import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier {
  List<Chatmodel> chatLst = [];
  List<Chatmodel> get getChatLst {
    return chatLst;
  }

  void addUserMessage({required String msg}) {
    chatLst.add(Chatmodel(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAnswer(
      {required String msg, required String chosenModelId}) async {
    chatLst.addAll(
        await ApiService.sendMessages(message: msg, modelId: chosenModelId));
    notifyListeners();
  }
}
