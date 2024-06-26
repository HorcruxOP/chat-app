import 'package:chat_app/services/functions/auth_functions.dart';
import 'package:chat_app/services/provider/provider.dart';
import 'package:chat_app/widgets/common/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WebChatList extends StatelessWidget {
  const WebChatList({super.key, required this.maxWidth});
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 10,
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
                    maxWidth > 1200
                        ? Text(
                            value.userName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .showSearchBar();
              },
              padding: const EdgeInsets.all(20),
              icon: Icon(
                value.isSearch ? Icons.close : Icons.search,
                size: 20,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                signOut();
              },
              padding: const EdgeInsets.all(20),
              icon: const Icon(
                Icons.logout,
                size: 20,
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
                      Provider.of<ChatProvider>(context, listen: false)
                          .showWebChatScreen(value.chatList[index]);
                    },
                  );
                },
              ),
      ),
    );
  }
}
