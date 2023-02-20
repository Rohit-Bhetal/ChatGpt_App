// ignore_for_file: public_member_api_docs, sort_constructors_first
class Chatmodel {
  final String msg;
  final int chatIndex;

  Chatmodel({
    required this.msg,
    required this.chatIndex,
  });

  factory Chatmodel.fromJson(Map<String, dynamic> json) => Chatmodel(
        msg: json['msg'],
        chatIndex: json['chatIndex'],
      );
}
