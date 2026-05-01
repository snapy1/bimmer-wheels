import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AppSettings {

  static const String _defaultSettingsPath = 'assets/default_settings.json';

  /// Helper function to get the file reference for a given
  /// file name in the app's documents directory.
  static Future<File> getFile(String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$fileName');
  }

  /// Ensures that the specified file exists. 
  /// If it does not, it creates the file and populates it 
  /// with default data from the provided asset path.
  static Future<bool> ensureSettingsExists() async {
    final file = await getFile("settings.json");
    if (!await file.exists()) {
      await createSettings();
      return true;
    }

    try {
      if (!await validateSettings()) {
        await file.delete();
        await createSettings();
      }
    } catch (_) {
      if (await file.exists()) {
        await file.delete();
      }
      await createSettings();
    }

    return true;
  }

  /// validate the settings and make sure all the keys in our default_settings.json are present in the settings file. 
  /// If any keys are missing, we will throw an exception.
  static Future<bool> validateSettings() async {
    final file = await getFile("settings.json");
    final contents = await file.readAsString();
    final settingsData = Map<String, dynamic>.from(jsonDecode(contents));

    final String defaultSettingsJson =
        await rootBundle.loadString(_defaultSettingsPath);
    final Map<String, dynamic> defaultSettingsData =
        Map<String, dynamic>.from(jsonDecode(defaultSettingsJson));

    for (var key in defaultSettingsData.keys) {
      if (!settingsData.containsKey(key)) {
        return false;
      }
    }
    return true;
  }

  /// Creates the settings file with default data from the default_settings.json in our assets.
  static Future<void> createSettings() async {
    final file = await getFile("settings.json");
    if (!await file.exists()) {
      final String defaultSettingsJson =
          await rootBundle.loadString(_defaultSettingsPath);
      await file.writeAsString(defaultSettingsJson);
    }
  }

  /// Creates the favorites file with an empty list if it does not already exist.
  /// This is really only ran if "new_user" in settings.json is true, otherwise we should already have a favorites file.
  static Future<void> createFavorites() async {
    // Create an empty favorites file if it doesn't exist.
    final file = await getFile("favorites.json");
    if (!await file.exists()) {
      await file.writeAsString(jsonEncode([]));
    }
  }


  /// Gets the settings from the settings.json file and returns it as a Map.
  static Future<Map<String, dynamic>> getSettings() async {
    await ensureSettingsExists();
    final file = await getFile("settings.json");
    final contents = await file.readAsString();
    return Map<String, dynamic>.from(jsonDecode(contents));
  }

  /// Saves the provided settings Map to the settings.json file, overwriting any existing data.
  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    final oldSettings = await getSettings();

    for (var key in oldSettings.keys) {
      if (!settings.containsKey(key)) {
        throw Exception('Missing key: $key');
      }
    }

    final file = await getFile("settings.json");

    const encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(settings));

    // lastly we will validate the settings. 
    if (!await validateSettings()) {
      await file.delete();
      throw Exception('Settings file is invalid after saving. It has been deleted and will be recreated with default settings on next app launch.');
    }
  }

    /// Prints the current settings to the console for debugging purposes.
    static Future<void> printSettings() async {
      final settings = await getSettings();
      print('Current settings: $settings');
    }

    /// resets the settings by deleting the settings file. 
    /// and then re-creating it with the default settings.
    static Future<void> resetSettings() async {
      final file = await getFile("settings.json");
      if (await file.exists()) {
        await file.delete();
      }

      // re-create the settings with the default values. 
      await createSettings();
    }

    /// Sets the model in the settings to the provided model name and saves the updated settings.
    static Future<void> setModel(String model) async {
      final settings = await getSettings();
      settings['model'] = model;
      await saveSettings(settings);
    }

    /// Sets the new_user flag in the settings to false and saves the updated settings.
    static Future<bool> isNewUser() async {
      final settings = await getSettings();
      return settings['new_user'] == true;
    }

    /// Gets the model from the settings and returns it. If no model is set, returns an empty string.
    static Future<String> getModel() async {
      final settings = await getSettings();
      return settings['model'] ?? '';
    }

    /// Gets the unit from the settings and returns it. If no unit is set, returns 'metric' as the default.
    static Future<String> getUnit() async {
      final settings = await getSettings();
      return settings['unit'] ?? 'metric';
    }

    /// Gets the share_data flag from the settings and returns it. If no value is set, returns true as the default.
    static Future<bool> getShareData() async {
      final settings = await getSettings();
      return settings['share_data'] == true;
    }

    /// Sets the new_user flag in the settings to false and saves the updated settings.
    static Future<void> setUnit(String unit) async {
      final settings = await getSettings();
      settings['unit'] = unit;
      await saveSettings(settings);
    }

    /// Sets the share_data flag in the settings to the provided value and saves the updated settings.
    static Future<void> setShareData(bool shareData) async {
      final settings = await getSettings();
      settings['share_data'] = shareData;
      await saveSettings(settings);
    }

    /// Sets the new_user flag in the settings to the provided value and saves the updated settings.
    static Future<void> setNewUser(bool newUser) async {
      final settings = await getSettings();
      settings['new_user'] = newUser;
      await saveSettings(settings);
    }

    static Future<void> ensureFavoritesExists() async {
      final file = await getFile("favorites.json");
      if (!await file.exists()) {
        await createFavorites();
      }
    }

    static Future<void> resetFavorites() async {
      final file = await getFile("favorites.json");
      if (await file.exists()) {
        await file.delete();
      }

      // re-create the favorites with an empty list. 
      await createFavorites();
    }

    static Future<void> addFavorite(String favorite) async {
      final file = await getFile("favorites.json");
      List<String> favorites = [];
      if (await file.exists()) {
        final contents = await file.readAsString();
        favorites = List<String>.from(jsonDecode(contents));
      }
      favorites.add(favorite);
      await file.writeAsString(jsonEncode(favorites));
    }

    static Future<List<String>> getFavorites() async {
      final file = await getFile("favorites.json");
      if (await file.exists()) {
        final contents = await file.readAsString();
        return List<String>.from(jsonDecode(contents));
      }
      return [];
    }

    static Future<void> printFavorites() async {
      final favorites = await getFavorites();
      print('Current favorites: $favorites');
    }

}