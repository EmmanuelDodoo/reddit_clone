import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reddit_clone/models/theme/app_colors.dart';
import 'package:reddit_clone/models/theme/theme_provider.dart';

class AppearanceSettings extends StatefulWidget {
  const AppearanceSettings({Key? key}) : super(key: key);

  @override
  State<AppearanceSettings> createState() => _AppearanceSettingsState();
}

class _AppearanceSettingsState extends State<AppearanceSettings> {
  void _handleToggleMaterial3(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleMaterial3();
  }

  void _handleToggleTheme(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleDarkMode();
  }

  void _handleColorSelection(BuildContext context, AppColor newColor) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.changeAppColor(newColor: newColor);
  }

  Widget _colorSelector(BuildContext context) {
    ThemeProvider themeProvider =
        Provider.of<ThemeProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Change Color Scheme",
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          DropdownButton<AppColor>(
            value: themeProvider.getCurrentAppColor(),
            elevation: 16,
            underline: Container(
              height: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
            onChanged: (value) => _handleColorSelection(context, value!),
            items: AppColor.values.map<DropdownMenuItem<AppColor>>((val) {
              return DropdownMenuItem(
                value: val,
                child: Text(
                  val.name.substring(0, 1).toUpperCase() +
                      val.name.substring(1),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Text(
                    "APPEARANCE SETTINGS",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text(
                  "Use Material 3",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                value: Theme.of(context).useMaterial3,
                onChanged: (bool value) => _handleToggleMaterial3(context),
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.only(left: 0),
                title: Text(
                  "Dark mode",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                value:
                    Theme.of(context).colorScheme.brightness == Brightness.dark,
                onChanged: (bool value) => _handleToggleTheme(context),
              ),
              _colorSelector(context),
            ],
          ),
        ),
      ),
    );
  }
}
