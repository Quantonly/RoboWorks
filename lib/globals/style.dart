import 'package:flutter/material.dart';

InputDecoration getTextFieldDecoration(String label) {
    return InputDecoration(
      labelStyle: const TextStyle(
        color: Colors.grey,
      ),
      labelText: label,
      fillColor: Colors.grey,
      contentPadding: const EdgeInsets.only(left: 30.0, right: 15.0),
      errorStyle: const TextStyle(color: Colors.red),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.0),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.0),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.0),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.0),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
    );
  }