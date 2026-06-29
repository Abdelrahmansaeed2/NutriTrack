import 'package:flutter/material.dart';

extension Navigation on BuildContext {
  Future<dynamic> PushNamed(String routeName, {Object? arg}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arg);
  }

  Future<dynamic> PushReplacementNamed(String routeName, {Object? arg}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arg);
  }

  Future<dynamic> PushNamedAndRemoveUntil(String routeName, {Object? arg}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arg);
  }

  void pop() => Navigator.of(this).pop();
}
