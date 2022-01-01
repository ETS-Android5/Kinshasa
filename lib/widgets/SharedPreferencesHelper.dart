/* * This class is a helper class that provides methods for storing and retrieving
 * user preferences. For example it provides a method to check whether the user
 * wants to confirm before deleting or not. 
 * Using a helper class is a better way to use SharedPreferences compared to 
 * creating methods to access and retrieve preferences in every single file where
 * SharedPreferences will be needed.
 */

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final String confirmDeleteKey = 'confirmDelete';

// Method that gets user decision whether to confirm before deleting an item in
// favorites
  static Future<bool> getDeleteConfirmationPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(confirmDeleteKey) ?? true;
  }

// Method that saves user decision whether to confirm before deleting an item in
// favorites
  static Future<bool> setConfirmDelete(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(confirmDeleteKey, value);
  }
}
