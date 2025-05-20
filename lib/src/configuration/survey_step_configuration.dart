import 'package:flutter/material.dart';

class SurveyStepConfiguration {
  const SurveyStepConfiguration({
    this.nextQuestionButtonStyle,
    this.goBackButtonStyle,
    this.finishLaterButtonStyle,
  });

  final ButtonStyle? nextQuestionButtonStyle;
  final ButtonStyle? goBackButtonStyle;
  final ButtonStyle? finishLaterButtonStyle;
}
