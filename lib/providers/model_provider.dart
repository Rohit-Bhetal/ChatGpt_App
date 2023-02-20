import 'package:chatgptapp/models/models.dart';
import 'package:chatgptapp/services/service_api.dart';
import 'package:flutter/widgets.dart';

class ModelsProvider with ChangeNotifier {
  String currentModel = "davinci";
  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelsList = [];

  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
