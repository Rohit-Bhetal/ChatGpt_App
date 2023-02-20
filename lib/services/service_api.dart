import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chatgptapp/constants/api_key.dart';
import 'package:http/http.dart' as http;

import '../models/chat_model.dart';
import '../models/models.dart';

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var jsonResponse = await http.get(Uri.parse("$Base_Url/models"),
          headers: {"Authorization": "Bearer $API_KEY"});
      Map jsondeCode = jsonDecode(jsonResponse.body);
      if (jsondeCode['error'] != null) {
        //print("jsonResponse['error'] ${jsondeCode['error']['message']}");
        throw HttpException(jsondeCode['error']['message']);
      }
      // print("Json response : $jsondeCode");

      List temp = [];
      for (var value in jsondeCode["data"]) {
        temp.add(value);
        log('temp $value');
      }
      return ModelsModel.modelFromSnapshot(temp);
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  static Future<List<Chatmodel>> sendMessages(
      {required String message, required String modelId}) async {
    try {
      var jsonResponse = await http.post(Uri.parse("$Base_Url/completions"),
          headers: {
            "Authorization": "Bearer $API_KEY",
            "Content-Type": "application/json"
          },
          body: jsonEncode(
              {"model": modelId, "prompt": message, "max_tokens": 100}));
      Map jsondeCode = jsonDecode(jsonResponse.body);
      if (jsondeCode['error'] != null) {
        //print("jsonResponse['error'] ${jsondeCode['error']['message']}");  useless tries to check the error
        throw HttpException(jsondeCode['error']['message']);
      }
      List<Chatmodel> chatList = [];

      if (jsondeCode["choices"].length > 0) {

        chatList = List.generate(
            jsondeCode["choices"].length,
            (index) => Chatmodel(
                msg: jsondeCode["choices"][index]["text"], chatIndex: 1));
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
