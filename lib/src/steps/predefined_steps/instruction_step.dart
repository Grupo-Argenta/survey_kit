import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/configuration/survey_step_configuration.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/result/step/instruction_step_result.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';
import 'package:survey_kit/src/steps/step.dart';
import 'package:survey_kit/src/views/instruction_view.dart';

part 'instruction_step.g.dart';

@JsonSerializable(explicitToJson: true)
class InstructionStep extends Step {
  InstructionStep({
    required this.title,
    required this.text,
    this.result,
    super.isOptional,
    String super.buttonText,
    super.stepIdentifier,
    bool? canGoBack,
    bool? showProgress,
    super.showAppBar,
    super.surveyStepConfiguration,
  }) : super(
          canGoBack: canGoBack ?? false,
          showProgress: showProgress ?? false,
        );

  factory InstructionStep.fromJson(Map<String, dynamic> json) =>
      _$InstructionStepFromJson(json);
  final String title;
  final String text;
  final InstructionStepResult? result;

  @override
  Widget createView({
    required QuestionResult<dynamic>? questionResult,
    SurveyStepConfiguration? surveyStepConfiguration,
  }) {
    return InstructionView(
      instructionStep: this,
      surveyStepConfiguration: surveyStepConfiguration,
    );
  }

  @override
  Map<String, dynamic> toJson() => _$InstructionStepToJson(this);

  @override
  bool operator ==(Object o) =>
      super == o &&
      o is InstructionStep &&
      o.title == title &&
      o.text == text &&
      o.stepIdentifier == o.stepIdentifier;

  @override
  int get hashCode =>
      super.hashCode ^ title.hashCode ^ text.hashCode ^ stepIdentifier.hashCode;
}
