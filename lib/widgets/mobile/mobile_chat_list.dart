import 'package:chat_app/services/provider/provider.dart';
import 'package:chat_app/widgets/common/search_bar_widget.dart';
import 'package:chat_app/widgets/mobile/mobile_chat_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MobileChatList extends StatelessWidget {
  const MobileChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: Colors.blueGrey,
          title: value.isSearch
              ? const SearchBarWidget()
              : Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person),
                      ),
                    ),
                    Text(
                      value.userName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .showSearchBar();
              },
              padding: const EdgeInsets.all(25),
              icon: Icon(
                value.isSearch ? Icons.close : Icons.search,
                size: 25,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: value.chatList.isEmpty
            ? const Center(
                child: Text("Search for a user you want to chat with"),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                ),
                itemCount: value.chatList.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    minVerticalPadding: 20,
                    leading: const CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person_2),
                    ),
                    title: Text(
                      value.chatList[index],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => ChatProvider(),
                            child: MobileChatDetails(
                              userName: value.chatList[index],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
