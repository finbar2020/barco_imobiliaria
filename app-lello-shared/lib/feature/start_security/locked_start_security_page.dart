import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';

class BlockedApp extends StatefulWidget {
  @override
  State<BlockedApp> createState() => _BlockedAppState();
}

class _BlockedAppState extends State<BlockedApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Image.asset("assets/logo_lello.png"),
                ),
            ),
            Text(getString(context, "device_access_denied_root_or_emulator"),
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
  }
}