import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';

import 'package:devfest/core/interface/interface.dart';

class AuthService implements AuthInterface {
  Future<UserCredential> signInWithGitHub(BuildContext context) async {
    // Create a GitHubSignIn instance
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: 'c93b4dddb59a3af396b9',
        clientSecret: '0866c430f8cb5f30951bfbcdeebde568ec4f2fbe',
        redirectUrl:
            'https://devfest2022-cb2a3.firebaseapp.com/__/auth/handler');

    // Trigger the sign-in flow
    final result = await gitHubSignIn.signIn(context);

    // Create a credential from the access token
    final githubAuthCredential = GithubAuthProvider.credential(result.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(githubAuthCredential);
  }
}
