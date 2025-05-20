import 'package:flutter/widgets.dart';

class AppBarConfiguration {
  const AppBarConfiguration({
    required this.showProgress,
    this.canGoBackWithLeading = false,
    this.leading,
    this.trailing,
  });

  final Widget? leading;
  final bool? showProgress;
  final bool? canGoBackWithLeading;
  final Widget? trailing;
}
