// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:e_commerce_user_app/pages/launcher_page.dart';
import 'package:e_commerce_user_app/pages/user_profile.dart';
import 'package:flutter/material.dart';

import '../auth/auth_service.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        UserAccountsDrawerHeader(
            currentAccountPictureSize: Size.square(70),
            currentAccountPicture: AuthService.user!.photoURL == null
                ? Image.asset("assets/images/person.png")
                : ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(AuthService.user!.photoURL!)),
            accountName:
                Text(AuthService.user!.displayName ?? "Name not Available"),
            accountEmail:
                Text(AuthService.user!.email ?? "Email not Available")),
        Expanded(
            child: ListView(
          children: [
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, UserProfilePage.routeName);
              },
              leading: Icon(Icons.account_circle),
              title: Text("Profile"),
            ),
            ListTile(
              onTap: () {
                AuthService.logout();

                Navigator.pushReplacementNamed(context, LauncherPage.routeName);
              },
              leading: Icon(Icons.logout),
              title: Text("LogOut"),
            ),
          ],
        ))
      ],
    ));
  }
}
