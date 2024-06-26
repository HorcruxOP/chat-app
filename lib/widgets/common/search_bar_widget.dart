import 'package:chat_app/services/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter a username to search ...",
            hintStyle: TextStyle(
              color: Colors.white,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
      optionsBuilder: (textEditingValue) {
        var searchTerms =
            Provider.of<ChatProvider>(context, listen: false).userNamesList;
        if (textEditingValue.text == "") {
          return const Iterable.empty();
        }
        return searchTerms.where(
          (element) => element
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()),
        );
      },
      onSelected: (item) {
        Provider.of<ChatProvider>(context, listen: false).addUserToList(item);
        Provider.of<ChatProvider>(context, listen: false).showSearchBar();
      },
    );
  }
}
