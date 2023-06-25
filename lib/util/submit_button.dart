import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    this.formBloc,
  });

  final formBloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: formBloc.submit,
      child: Container(
        width: 100,
        child: Center(
          child: Text(
            'SUBMIT',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFF1C1B1F),
        ),
      ),
    );
  }
}
