import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthInterface {
  Future<UserCredential> signInWithGitHub(BuildContext context);
}
