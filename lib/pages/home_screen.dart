import 'package:chat_app/services/provider/provider.dart';
import 'package:chat_app/widgets/mobile/mobile_chat_list.dart';
import 'package:chat_app/widgets/web/web_chat_details.dart';
import 'package:chat_app/widgets/web/web_chat_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatProvider>(
      create: (context) => ChatProvider(),
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          if (maxWidth <= 1200) {
            return const MobileChatList();
          }

          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 20,
                  borderOnForeground: false,
                  margin: const EdgeInsets.only(right: 5),
                  child: WebChatList(
                    maxWidth: maxWidth,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: !Provider.of<ChatProvider>(context).isInitial
                    ? const Center(
                        child: Text("Select a chat"),
                      )
                    : const WebChatDetails(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
