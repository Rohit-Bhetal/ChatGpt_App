import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgptapp/constants/constant.dart';
import 'package:chatgptapp/providers/assets_manager.dart';
import 'package:chatgptapp/widgets/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatW extends StatelessWidget {
  const ChatW({super.key, required this.msg, required this.chatIndex});

  final String msg;
  final int chatIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color:
              chatIndex == 0 ? cardColor : Color.fromARGB(255, 101, 101, 101),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  chatIndex == 0
                      ? AssetsManager.userImage
                      : AssetsManager.chatGpt,
                  height: 30,
                  width: 30,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                    child: chatIndex == 0
                        ? TextWidget(label: msg, fontsize: 16.0)
                        : DefaultTextStyle(
                            style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                            child: AnimatedTextKit(
                              isRepeatingAnimation: false,
                              repeatForever: false,
                              displayFullTextOnTap: true,
                              totalRepeatCount: 1,
                              animatedTexts: [TyperAnimatedText(msg.trim())],
                            ),
                          )),
                chatIndex == 0
                    ? const SizedBox.shrink()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.thumb_up_alt_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.thumb_down_alt_outlined,
                            color: Colors.white,
                          ),
                        ],
                      )
              ],
            ),
          ),
        )
      ],
    );
  }
}
