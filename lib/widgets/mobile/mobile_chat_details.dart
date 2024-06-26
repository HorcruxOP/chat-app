import 'dart:convert';
import 'dart:developer';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/pages/home_screen.dart';
import 'package:chat_app/services/provider/provider.dart';
import 'package:chat_app/widgets/common/message_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MobileChatDetails extends StatefulWidget {
  final String userName;
  const MobileChatDetails({super.key, required this.userName});

  @override
  State<MobileChatDetails> createState() => _MobileChatDetailsState();
}

class _MobileChatDetailsState extends State<MobileChatDetails> {
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();

    channel = WebSocketChannel.connect(Uri.parse('wss://34.131.141.162:8080'));
    scrollController = ScrollController();
    scrollToBottom();

    channel.stream.listen((message) {
      log('Message received: $message');
      final decodedMessage = jsonDecode(utf8.decode(message));
      MessageModel messageModel = MessageModel(
        message: decodedMessage['message'],
        username: decodedMessage['username'],
        dateTime: DateTime.parse(decodedMessage['dateTime']),
      );
      log("calling reciever");
      Provider.of<ChatProvider>(context, listen: false)
          .receiveChat(messageModel);
      log("calling reciever1");
      scrollToBottom();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    channel.sink.close();
    super.dispose();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth >= 1200) {
        return const HomeScreen();
      }
      return Scaffold(
        appBar: AppBar(
          elevation: 10,
          backgroundColor: Colors.blueGrey,
          toolbarHeight: 100,
          title: Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person_2),
                ),
              ),
              Text(
                widget.userName,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        body: Consumer<ChatProvider>(
          builder: (BuildContext context, ChatProvider value, Widget? child) {
            if (!value.isProviderInitial) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: value.chats.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Alignment alignment;
                        Color color;
                        if (value.chats[index].username == value.userName) {
                          alignment = Alignment.centerRight;
                          color = Colors.green;
                        } else {
                          alignment = Alignment.centerLeft;
                          color = Colors.blueGrey;
                        }
                        MessageModel messageModel = value.chats[index];
                        return MessageCard(
                          messageModel: messageModel,
                          alignment: alignment,
                          color: color,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                      left: 30,
                      right: 30,
                    ),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            log(controller.text);

                            MessageModel messageModel = MessageModel(
                              message: controller.text,
                              username: value.userName,
                              dateTime: DateTime.now(),
                            );

                            Provider.of<ChatProvider>(context, listen: false)
                                .sendChat(messageModel);

                            final messageJson =
                                jsonEncode(messageModel.toJson());
                            channel.sink.add(utf8.encode(messageJson));

                            controller.clear();
                            scrollToBottom();
                          },
                          icon: const Icon(
                            Icons.send,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      );
    });
  }
}
