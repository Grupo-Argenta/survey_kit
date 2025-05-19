import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/configuration/survey_step_configuration.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/result/step/completion_step_result.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';
import 'package:survey_kit/src/steps/step.dart';
import 'package:survey_kit/src/views/completion_view.dart';

part 'completion_step.g.dart';

@JsonSerializable()
class CompletionStep extends Step {
  CompletionStep({
    super.isOptional,
    required StepIdentifier super.stepIdentifier,
    String super.buttonText = 'End Survey',
    super.showAppBar,
    required this.title,
    required this.text,
    this.result,
    this.assetPath = '',
    super.surveyStepConfiguration,
  });

  factory CompletionStep.fromJson(Map<String, dynamic> json) =>
      _$CompletionStepFromJson(json);

  final String title;
  final String text;
  final String assetPath;
  final CompletionStepResult? result;

  @override
  Widget createView({
    required QuestionResult<dynamic>? questionResult,
    SurveyStepConfiguration? surveyStepConfiguration,
  }) {
    return CompletionView(
      completionStep: this,
      assetPath: assetPath,
      surveyStepConfiguration: surveyStepConfiguration,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$CompletionStepToJson(this);

  @override
  bool operator ==(o) =>
      super == o && o is CompletionStep && o.title == title && o.text == text;

  @override
  int get hashCode => super.hashCode ^ title.hashCode ^ text.hashCode;
}
