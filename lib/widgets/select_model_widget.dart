// Loop through all the available models and display them in a list. 
import 'dart:io';
import 'package:bimmer_wheels/statics/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectModelWidget extends StatelessWidget {

  const SelectModelWidget({ super.key });

  /// This function will get the models from the assets/models directory and return a list of the model paths.
  /// It will check the platform and look for the appropriate model files (.mlpackage.zip for iOS and .tflite.zip for Android).
  /// It will return a list of the model paths that can be used to populate the dropdown menu in the UI.
  Future<List<String>> getModels(String directory) async {
    final Set<String> models = <String>{};
    final AssetManifest manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final Iterable<String> files = manifest.listAssets().where((path) => path.startsWith('$directory/'));

    // if we are on iOS, lets
    if (Platform.isIOS) {
      // get the models from the assets/models directory

      // under the assets directory, we need to go to models and look for any 
      // files that in .mlpackage.zip format and add them to the models list.
      for (var file in files) {
        if (file.endsWith('.mlpackage.zip') || file.endsWith('.mlpackage')) {
          models.add(file.split('/')[2]);
        }
      }
      print('Models found for iOS: $models');
      return models.toList();
    } 

    // if we are on android. 
    if (Platform.isAndroid) {
      // get the models from the assets/models directory
      // we will use the path_provider package to get the path to the documents directory and then read the files in the assets/models directory
      for (var file in files) {
        if (file.endsWith('.tflite') || file.endsWith('.tflite.zip')) {
          models.add(file.split('/')[2]);
          }
        }
      print('Models found for Android: $models');
      return models.toList();
      }
    else throw Exception('Unsupported platform: ${Platform.operatingSystem}');
    }


    void onModelSelected(String modelName) {
      // Handle model selection change


      AppSettings.setModel(modelName);
      print('Selected model: $modelName');
    }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getModels('assets/models'),
      builder: (context, snapshot) {
        final List<String> models = snapshot.data ?? [];

        return DropdownButtonFormField<String>(
          isExpanded: models.isNotEmpty,
          menuMaxHeight: 280,
          decoration: const InputDecoration(
            labelText: 'Select a model',
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          items: models.map((modelPath) {
            String modelName = modelPath; // Get the file name from the path
            return DropdownMenuItem<String>(
              value: modelPath,
              child: Text(
                modelName,
                overflow: TextOverflow.ellipsis,
              ), // Display the file name in the dropdown
            );
          }).toList(),
          onChanged: (String? newValue) {
            // Handle model selection change
            if (newValue != null) {
              onModelSelected(newValue);
            }
          },
          hint: const Text('Select a model'),
        );
      },
    );
  }

}