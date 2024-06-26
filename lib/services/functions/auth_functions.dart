// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> createAccountWithEmailPassword(
    String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    log(e.toString());
  }
}

Future signInWithEmailPassword(
    String email, String password, BuildContext context) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No user found for that email.'),
        backgroundColor: Colors.red,
      ));
    } else if (e.code == 'wrong-password') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Wrong password provided for that user.'),
        backgroundColor: Colors.red,
      ));
    } else if (e.code == 'invalid-credential') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Invalid Credential'),
        backgroundColor: Colors.red,
      ));
    }
  } catch (e) {
    log(e.toString());
  }
}

void signOut() async {
  try {
    await FirebaseAuth.instance.signOut();
  } on FirebaseAuthException catch (e) {
    log(e.toString());
  }
}
