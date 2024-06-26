// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> saveUserDetails(
    String email, String password, String userName) async {
  try {
    var userDetails = {
      "userName": userName,
      "email": email,
      "password": password,
    };

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("userDetails").doc("UserDetails");

    await documentReference.update({
      "data": FieldValue.arrayUnion([userDetails])
    });
  } catch (e) {
    log(e.toString());
  }
}

Future<String> getUserName() async {
  try {
    String email = FirebaseAuth.instance.currentUser!.email!;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("userDetails")
        .doc("UserDetails")
        .get();

    List<dynamic> data = documentSnapshot.get('data');
    for (var element in data) {
      if (email == element["email"]) {
        return element["userName"];
      }
    }
  } catch (e) {
    log(e.toString());
  }
  return "";
}

Future<bool> checkUserName(String userName, BuildContext context) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("userDetails")
        .doc("UserDetails")
        .get();

    List<dynamic> data = documentSnapshot.get('data');
    for (var element in data) {
      if (userName == element["userName"]) {
        return true;
      }
    }
  } catch (e) {
    log(e.toString());
  }
  return false;
}

Future<List<String>> fetchUserNamesList() async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("userDetails")
        .doc("UserDetails")
        .get();

    List<dynamic> data = documentSnapshot.get('data');
    List<String> usernamesList = [];
    for (var element in data) {
      usernamesList.add(element["userName"]);
    }
    return usernamesList;
  } catch (e) {
    log(e.toString());
  }
  return [];
}

Future<bool> checkEmail(String email, BuildContext context) async {
  try {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("userDetails")
        .doc("UserDetails")
        .get();

    List<dynamic> data = documentSnapshot.get('data');
    for (var element in data) {
      if (email == element["email"]) {
        return true;
      }
    }
  } catch (e) {
    log(e.toString());
  }
  return false;
}
