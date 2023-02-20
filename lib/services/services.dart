import 'package:flutter/material.dart';

import '../constants/constant.dart';
import '../widgets/dropdown.dart';
import '../widgets/textwidget.dart';

class Services {
  static Future<void> showModelSheet({required BuildContext context}) async {
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        backgroundColor: scaffoldBackgroundColor,
        context: context,
        builder: (context) {
          return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Flexible(
                        child: TextWidget(label: "Models :", fontsize: 16)),
                    Flexible(flex: 2, child: ModelDrwan())
                  ]));
        });
  }
}
