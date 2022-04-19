import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String errorMessage;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool autofocus;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final TextInputType? textTextInputType;
  final TextInputType? keyboardType;
  const CustomTextField(
      {this.label = '',
      this.errorMessage = '',
      this.controller,
      this.onChanged,
      this.maxLines,
      this.autofocus = false,
      this.textInputAction,
      this.textTextInputType,
      this.keyboardType,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      if (label.isNotEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      if (errorMessage.isNotEmpty)
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            errorMessage,
            style: TextStyle(fontSize: 14, color: Theme.of(context).errorColor),
          ),
        ),
      TextField(
        controller: controller,
        autofocus: autofocus,
        textInputAction: textInputAction,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: Theme.of(context).disabledColor.withOpacity(0.08),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ]);
  }
}

class CustomTextFieldLabel extends StatelessWidget {
  final String label;
  final String errorMessage;
  const CustomTextFieldLabel(this.label, {this.errorMessage = '', Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18),
          ),
        ),
        if (errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              errorMessage,
              style:
                  TextStyle(fontSize: 14, color: Theme.of(context).errorColor),
            ),
          )
      ],
    );
  }
}
