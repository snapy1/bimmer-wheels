import 'package:bimmer_wheels/pages/homescreen_page.dart';
import 'package:bimmer_wheels/statics/app_settings.dart';
import 'package:bimmer_wheels/widgets/select_model_widget.dart';
import 'package:bimmer_wheels/widgets/share_data_selection_widget.dart';
import 'package:bimmer_wheels/widgets/unit_selection_widget.dart';
import 'package:flutter/material.dart';

class InitialSetup extends StatefulWidget {
  const InitialSetup({super.key, this.jsonSettingsData});

  final Map<String, dynamic>? jsonSettingsData;

  @override
  State<InitialSetup> createState() => _InitialSetupState();
}

class _InitialSetupState extends State<InitialSetup> {
  bool isSettingsLoaded = false;
  bool newUser = true; // Default to true until settings are loaded.

  Future<bool> isFirstTime() async {
  
    if (await AppSettings.isNewUser()) {
      // New user should continue through initial setup flow.
      return true;
    }

    // otherwise if the user is existing then go ahead and initalize there settings and favorites. 
    await AppSettings.ensureSettingsExists();
    await AppSettings.ensureFavoritesExists();
    return false;
  }

  Future<void> initalizeSettings() async {}

  Future<void> initializeFavorites() async {}

  @override
  void initState() {
    super.initState();
    // Load settings then route based on whether this is a new user.
    isFirstTime().then((isFirstTimeUser) {
      if (!mounted) return;
      if (isFirstTimeUser) {
        // Navigate to the initial setup flow.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InitialSetupFlow()),
        );
      } else {
        // Navigate to the homepage.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomescreenPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class InitialSetupFlow extends StatelessWidget {
  const InitialSetupFlow({super.key});



  @override
  Widget build(BuildContext context) {

    // AppSettings.setNewUserToFalse(context);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Initial Setup Flow'),

    
            // model selection
            const SelectModelWidget(),


            UnitSelectionWidget(selectedUnit: 'metric', onUnitChanged: (unit) {
              AppSettings.setUnit(unit);
            },),
            
            ShareDataSelectionWidget(onOptionSelected: (option) {
              if (option == 'share') {
                AppSettings.setShareData(true);
              } else {
                AppSettings.setShareData(false);
              }
            },),


            ElevatedButton(
              onPressed: () {
                // Set new user to false and navigate to the homepage.
                AppSettings.setNewUser(false);
                AppSettings.printSettings();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomescreenPage()),
                );

          },
          child: const Text('Save Settings and Continue'),
        ),
      ]),
    ));  
  }
}
