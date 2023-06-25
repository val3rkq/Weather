import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_api_client.dart';

class AsyncFieldValidationFormBloc extends FormBloc<String, String> {
  final city = TextFieldBloc(
    initialValue: '',
    validators: [
      _emptyCheck,
      FieldBlocValidators.required,
    ],
    asyncValidatorDebounceTime: const Duration(milliseconds: 300),
  );

  AsyncFieldValidationFormBloc() {
    addFieldBlocs(fieldBlocs: [city]);

    city.addAsyncValidators(
      [_checkcity],
    );
  }

  static String? _emptyCheck(String? city) {
    if (city == null || city.isEmpty) {
      return 'Enter city name, please';
    }
    return null;
  }

  WeatherApiClient client = WeatherApiClient();
  int? code;

  Future<String?> _checkcity(String? city) async {
    await Future.delayed(const Duration(milliseconds: 500));
    code = await client.getCode(city);
    if (code == 404) {
      return 'City is not found';
    }
    if (code == 401) {
      return 'API error';
    }
    if (code == 500) {
      return 'Server error';
    }
    return null;
  }

  @override
  void onSubmitting() async {
    debugPrint(city.value);

    try {
      await Future<void>.delayed(const Duration(milliseconds: 500));

      emitSuccess();
    } catch (e) {
      emitFailure();
    }
  }
}
