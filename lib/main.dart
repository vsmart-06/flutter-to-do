import "package:flutter/material.dart";
import "package:to_do_application/pages/edit_page.dart";
import "package:to_do_application/pages/home_page.dart";
import "package:to_do_application/pages/create_page.dart";

void main() {
  runApp(
    MaterialApp(
      routes: {
        "/": (context) => Home(),
        "/create_task": (context) => CreateTask(),
        "/edit_task": (context) => EditTask(),
      }
    )
  );
}