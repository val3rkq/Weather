import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app/model/db_model.dart';
import 'package:weather_app/util/settings_tile.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

import 'package:weather_app/util/async_text_field/async_field_validation_form_bloc.dart';
import 'package:weather_app/util/async_text_field/loading_dialog.dart';
import 'package:weather_app/util/submit_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // add database on HIVE
  var mainBox = Hive.box("mainBox");
  DB db = DB();

  // this key needs for checking is textformfield empty
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (mainBox.get("HISTORY") == null) {
      db.initData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  bool isDialogOpened = false;

  // show dialog for changing city
  void changeCity(dynamic formBloc) {
    isDialogOpened = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          // backgroundColor: Colors.grey[900],
          content: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            height: 210,
            width: 350,
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    // title
                    Text(
                      'Change your city',
                      style: GoogleFonts.bebasNeue(fontSize: 25),
                    ),

                    // seacrh field
                    Form(
                      key: _formKey,
                      child: TextFieldBlocBuilder(
                        textFieldBloc: formBloc.city,
                        suffixButton: SuffixButton.asyncValidating,
                        decoration: const InputDecoration(
                          hintText: 'Enter city name',
                          prefixIcon: Icon(Icons.search_rounded),
                        ),
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),

                    // submit button

                    SubmitButton(
                      formBloc: formBloc,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      // make textformfield empty
      formBloc.city.updateInitialValue('');

      isDialogOpened = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AsyncFieldValidationFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.read<AsyncFieldValidationFormBloc>();

          return FormBlocListener<AsyncFieldValidationFormBloc, String, String>(
            onSubmitting: (context, state) {
              LoadingDialog.show(context);
            },
            onSubmissionFailed: (context, state) {
              LoadingDialog.hide(context);
            },
            onSuccess: (context, state) {
              LoadingDialog.hide(context);

              // update city
              setState(() {
                // set default city
                db.myCity = formBloc.city.value.toString();
                db.updateMyCity();
              });

              // make textformfield empty
              formBloc.city.updateInitialValue('');

              // close dialog
              if (isDialogOpened) {
                Navigator.pop(context);
                isDialogOpened = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(hours: 5000),
                    content:
                    Text('Close and reopen app to update settings..'),
                  ),
                );
              }
            },
            onFailure: (context, state) {
              LoadingDialog.hide(context);

              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.failureResponse!)));
            },
            child: SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  leading: GestureDetector(
                    child: Container(
                      margin: EdgeInsets.all(6.5),
                      height: 17,
                      width: 17,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  centerTitle: true,
                  title: Text(
                    'Settings',
                    style: GoogleFonts.bebasNeue(
                      fontSize: 27,
                    ),
                  ),
                ),
                body: Center(
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 10, 16, 20),
                      child: ListView(
                        children: [
                          SettingsTile(
                            onTap: () {
                              changeCity(formBloc);
                            },
                            item: db.myCity!,
                            itemDesc: 'Your city',
                            icon: CupertinoIcons.placemark_fill,
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Weather units',
                              style: GoogleFonts.bebasNeue(
                                fontSize: 25,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          SettingsTile(
                            onTap: () {
                              setState(() {
                                if (db.temperatureUnit == '°C') {
                                  db.temperatureUnit = '°F';
                                } else {
                                  db.temperatureUnit = '°C';
                                }
                                db.updateDB();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(hours: 5000),
                                  content:
                                  Text('Close and reopen app to update settings..'),
                                ),
                              );
                            },
                            item: db.temperatureUnit!,
                            itemDesc: 'Temperature',
                            icon: CupertinoIcons.thermometer,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SettingsTile(
                            onTap: () {
                              setState(() {
                                if (db.windSpeedUnit == 'm / s') {
                                  db.windSpeedUnit = 'km / h';
                                } else if (db.windSpeedUnit == 'km / h') {
                                  db.windSpeedUnit = 'mph / h';
                                } else {
                                  db.windSpeedUnit = 'm / s';
                                }
                                db.updateDB();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(hours: 10),
                                  content:
                                  Text('Close and reopen app to update settings..'),
                                ),
                              );
                            },
                            item: db.windSpeedUnit!,
                            itemDesc: 'Wind Speed',
                            icon: Icons.wind_power_rounded,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
