import 'package:flutter/material.dart';
import 'package:tsa_software_2024/data/config/globals.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 48),
              child: Text(
                "About",
                style: TextStyle(fontSize: 36),
              ),
            ),
            Expanded(
                child: ListView(
                  children: const [
                    Text(
                      "$APP_NAME is an application designed to help promote medical transparency between users and their doctors. "
                          "Too often are people prescribed medication that they know little about, leading to an atmosphere to distrust among physicians. "
                          "One example is the COVID-19 pandemic, where misinformation regarding medical knowledge spread without bounds on social media platforms.",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "$APP_NAME solves this problem by giving users concise information on medication that doctors prescribe to them by simply taking pictures of their pill bottle. "
                          "We perform optical character recognition on the pictures that users take, and then use a state of the art machine learning model to extract medication names from detected words. "
                          "Then, the user is given medically-accurate information on their medication, ensuring that they aren't being fooled by misinformation over their prescriptions. "
                          "$APP_NAME also gives users the opportunity to schedule their pill intake and receive notifications for when they should take their medications. ",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
