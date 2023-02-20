import 'dart:developer';

import 'package:chatgptapp/constants/constant.dart';
import 'package:chatgptapp/providers/chatprovider.dart';
import 'package:chatgptapp/services/service_api.dart';
import 'package:chatgptapp/services/services.dart';
import 'package:chatgptapp/widgets/textwidget.dart';
import 'package:chatgptapp/widgets/widgetchat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/chat_model.dart';
import '../providers/assets_manager.dart';
import '../providers/model_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isTyping = false;

  late TextEditingController textEditingController;
  late ScrollController _listScrollController;
  late FocusNode focusNode;

  @override
  void initState() {
    textEditingController = TextEditingController();
    _listScrollController = ScrollController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController = TextEditingController();
    focusNode.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  //List<Chatmodel> chatlst = [];

  @override
  Widget build(BuildContext context) {
    final modelsProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    return Scaffold(
        appBar: const _CustomAppbar(),
        body: SafeArea(
            child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  controller: _listScrollController,
                  itemCount: chatProvider.getChatLst.length,
                  itemBuilder: (context, index) {
                    return ChatW(
                      msg: chatProvider.getChatLst[index].msg,
                      chatIndex: chatProvider.getChatLst[index].chatIndex,
                    );
                  }),
            ),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Material(
                color: const Color.fromARGB(66, 115, 114, 114),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        focusNode: focusNode,
                        style: const TextStyle(color: Colors.white),
                        controller: textEditingController,
                        onSubmitted: (value) async {
                          await sendMessages(
                              modelsProvider: modelsProvider,
                              chatProvider: chatProvider);
                        },
                        decoration: const InputDecoration.collapsed(
                            hintText: "Welcome! How can I help You?",
                            hintStyle: TextStyle(color: Colors.grey)),
                      )),
                      IconButton(
                          onPressed: () async {
                            await sendMessages(
                                modelsProvider: modelsProvider,
                                chatProvider: chatProvider);
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
              ),
            )
          ],
        )));
  }

  void scrollList() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeOut);
  }

  Future<void> sendMessages(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider}) async {
    if (_isTyping) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(
            label: 'No Multiple message can be sent at same time',
            fontsize: 14),
        backgroundColor: Colors.red,
      ));
      return;
    }
    if (textEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: TextWidget(label: 'No Input Detected !', fontsize: 14),
        backgroundColor: Colors.red,
      ));
      return;
    }
    try {
      String msg = textEditingController.text;
      setState(() {
        _isTyping = true;
        //chatlst.add(Chatmodel(msg: textEditingController.text, chatIndex: 0));
        chatProvider.addUserMessage(msg: msg);
        textEditingController.clear();
        focusNode.unfocus();
      });
      await chatProvider.sendMessageAnswer(
          msg: msg, chosenModelId: modelsProvider.getCurrentModel);
      //chatlst.addAll(await ApiService.sendMessages(
      //  message: textEditingController.text,
      //  modelId: modelsProvider.getCurrentModel));
      setState(() {});
    } catch (error) {
      log("error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: TextWidget(label: error.toString(), fontsize: 14),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        scrollList();
        _isTyping = false;
      });
    }
  }
}

class _CustomAppbar extends StatefulWidget with PreferredSizeWidget {
  const _CustomAppbar({super.key});

  @override
  _CustomAppbarState createState() => _CustomAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<_CustomAppbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Center(
        child: SizedBox(
          height: kToolbarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FittedBox(
                fit: BoxFit.contain,
                child: RotationTransition(
                  turns: _controller,
                  child: ColorFiltered(
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      child: Transform.scale(
                          scale: 0.6,
                          child: Image.asset(AssetsManager.imageBot))),
                ),
              ),
              const SizedBox(
                width: 0,
              ),
              Text(
                'ChatGPT',
                style: GoogleFonts.poppins(fontSize: 23),
              ).shimmer(
                  primaryColor: Colors.white, secondaryColor: Colors.white12)
            ],
          ),
        ),
      ),
      actions: [
        IconButton(
            onPressed: () async {
              await Services.showModelSheet(context: context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ))
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
