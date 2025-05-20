import 'package:flutter/material.dart';
import 'package:survey_kit/src/configuration/survey_step_configuration.dart';
import 'package:survey_kit/src/result/step/instruction_step_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/instruction_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class InstructionView extends StatelessWidget {
  InstructionView({
    super.key,
    required this.instructionStep,
    this.surveyStepConfiguration,
  });

  final InstructionStep instructionStep;
  final DateTime _startDate = DateTime.now();
  final SurveyStepConfiguration? surveyStepConfiguration;

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: instructionStep,
      title: Text(
        instructionStep.title,
        style: Theme.of(context).textTheme.displayMedium,
        textAlign: TextAlign.center,
      ),
      resultFunction: () {
        return InstructionStepResult(
          instructionStep.stepIdentifier,
          _startDate,
          DateTime.now(),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Text(
          instructionStep.text,
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
