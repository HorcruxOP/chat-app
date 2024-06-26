import 'dart:developer';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/services/functions/database_functions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatProvider with ChangeNotifier {
  ChatProvider() {
    _initialize();
  }

  late Box<MessageModel> chatBox;
  bool isInitial = false;
  bool isProviderInitial = false;
  bool isSearch = false;
  String userName = "Loading...";
  String localUserName = "Loading...";
  late List<String> userNamesList;
  List<String> chatList = [];

  Future<void> _initialize() async {
    await initHive();
    await fetchUserName();
    await initialise();
  }

  Future<void> initHive() async {
    try {
      await Hive.openBox<MessageModel>('chatBox');
      chatBox = Hive.box<MessageModel>('chatBox');
      isProviderInitial = true;
      userNamesList = await fetchUserNamesList();
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  List<MessageModel> get chats => chatBox.values.toList();

  Future<void> initialise() async {}

  void addUserToList(String item) {
    if (!chatList.contains(item)) {
      chatList.add(item);
      notifyListeners();
    }
  }

  void showWebChatScreen(String username) {
    isInitial = true;
    localUserName = username;
    notifyListeners();
  }

  void showSearchBar() {
    isSearch = !isSearch;
    notifyListeners();
  }

  Future<void> fetchUserName() async {
    userName = await getUserName();
    notifyListeners();
  }

  void sendChat(MessageModel messageModel) {
    if (!chatBox.isOpen) return;
    chatBox.add(messageModel);
    notifyListeners();
  }

  void receiveChat(MessageModel messageModel) {
    if (!chatBox.isOpen) {
      return;
    }

    bool messageExists = chatBox.values.any((msg) =>
        msg.message == messageModel.message &&
        msg.dateTime == messageModel.dateTime);

    if (!messageExists) {
      chatBox.add(messageModel);
      notifyListeners();
    }
  }

  Future<void> deleteChatBox() async {
    isInitial = true;
    await chatBox.deleteFromDisk();
    notifyListeners();
  }
}
