import 'package:flutter/material.dart';
import 'package:flutter_app/views/pages/collection_creating.dart';
import 'package:flutter_app/views/widgets/setting_app_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  bool isEditing = false;
  bool isPressed = false;
  bool isSwitched = false;
  double sliderValue = 0.0;
  String? menuItem;

  Future<void> printAllSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> keys = prefs.getKeys();

    if (keys.isEmpty) {
      print('SharedPreferences is empty.');
      return;
    }
    print('--- Printing all SharedPreferences ---');
    for (String key in keys) {
      final dynamic value = prefs.get(key);
      print('$key: $value (${value.runtimeType})');
    }
    print('------------------------------------');
  }

  Future<void> deleteAllPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('Shared Preferences cleaned.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SettingsAppBar(title: widget.title),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              //reset data button
              OutlinedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Are you sure you want to delete all data?',
                        ),
                        content: const Text('This action is irreversible.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              deleteAllPreferences();
                            },
                            child: const Text('Delete'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Reset your data'),
              ),
              SizedBox(height: 10),
              //create new collection button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CollectionCreating(),
                    ),
                  );
                },
                child: const Text('Create new Collection'),
              ),

              CheckboxListTile.adaptive(
                title: const Text('Enable Developer Mode'),
                value: isEditing,
                onChanged: (bool? value) {
                  setState(() {
                    isEditing = value!;
                  });
                },
              ),

              Visibility(
                visible: isEditing,
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        printAllSharedPreferences();
                      },
                      child: Text('Print Shared Preferences'),
                    ),

                    SwitchListTile.adaptive(
                      title: const Text('Enable Notifications'),
                      value: isSwitched,
                      onChanged: (bool value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                    ),

                    Slider.adaptive(
                      value: sliderValue,
                      onChanged: (double value) {
                        setState(() {
                          sliderValue = value;
                        });
                      },
                    ),
                    Text('Slider Value: ${sliderValue.toStringAsFixed(2)}'),

                    InkWell(
                      splashColor: Colors.red,
                      onTap: () {
                        setState(() {
                          isSwitched = !isSwitched;
                        });
                      },
                      child: Image.asset(
                        'assets/images/test.jpg',
                        height: 100,
                        width: 400,
                      ),
                    ),

                    Checkbox(
                      value: isPressed,
                      onChanged: (bool? value) {
                        setState(() {
                          isPressed = value!;
                        });
                      },
                    ),

                    FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('This is a snackbar'),
                            duration: Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text('Open Snackbar'),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      indent: 50.0,
                      endIndent: 50.0,
                    ),
                    Container(
                      height: 100,
                      width: 100,
                      child: VerticalDivider(
                        color: Colors.white,
                        thickness: 2.0,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Alert Dialog'),
                              content: const Text('This is an alert dialog.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text('Open Alert'),
                    ),

                    BackButton(onPressed: () {}),
                    CloseButton(onPressed: () {}),
                    DropdownButton(
                      value: menuItem,
                      items: [
                        const DropdownMenuItem(value: 'e1', child: Text('One')),
                        const DropdownMenuItem(value: 'e2', child: Text('Two')),
                        const DropdownMenuItem(
                          value: 'e3',
                          child: Text('Three'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          menuItem = value;
                        });
                      },
                    ),
                    TextField(
                      controller: firstnamecontroller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'First Name',
                      ),
                    ),
                    Text(firstnamecontroller.text),
                    TextField(
                      controller: lastnamecontroller,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Last Name',
                      ),
                      onEditingComplete: () {
                        setState(() {});
                      },
                    ),
                    Text(lastnamecontroller.text),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
