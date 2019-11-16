import 'package:askkit/View/Theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextAreaForm extends StatelessWidget {
  String _hintText;
  String _validatorError;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();


  TextAreaForm(this._hintText, this._validatorError);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formkey,
        child: Container(
            height: 150.0,
            child: TextFormField(
                style: Theme.of(context).textTheme.subtitle,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: controller,
                decoration: new InputDecoration(
                    hintText: _hintText,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                ),
                validator: (String value) {
                  if (value.length == 0)
                    return _validatorError;
                  return null;
                }
            )
        )
    );
  }

  bool validate() {
    return formkey.currentState.validate();
  }

  String getText() {
    return controller.text;
  }

}