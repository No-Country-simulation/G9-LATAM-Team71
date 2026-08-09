import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wallet_flutter/screen/DashboardScreen.dart';
import 'package:wallet_flutter/screen/MetasScreen.dart';
import 'package:wallet_flutter/screen/SituacionScreen.dart';
import 'package:wallet_flutter/utils/WAColors.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  const AppScaffold({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: boldTextStyle(color: Colors.white)),
        backgroundColor: WAPrimaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              toast("Notificaciones");
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: WAPrimaryColor),
              accountName: Text("Andre Garcia", style: TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text("andre@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: WAPrimaryColor, size: 40),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: WAPrimaryColor),
              title: const Text("Dashboard"),
              onTap: () {
                finish(context); // Cerrar drawer
                const DashboardScreen().launch(context, isNewTask: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.track_changes, color: WAPrimaryColor),
              title: const Text("Metas"),
              onTap: () {
                finish(context);
                const MetasScreen().launch(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics, color: WAPrimaryColor),
              title: const Text("Situación"),
              onTap: () {
                finish(context);
                const SituacionScreen().launch(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person_outline, color: WAPrimaryColor),
              title: const Text("Información del Usuario"),
              onTap: () {
                finish(context);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
              onTap: () {
                finish(context);
              },
            ),
            20.height,
          ],
        ),
      ),
      body: body,
    );
  }
}
