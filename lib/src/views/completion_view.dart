import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:survey_kit/src/configuration/survey_step_configuration.dart';
import 'package:survey_kit/src/result/step/completion_step_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/completion_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class CompletionView extends StatelessWidget {
  CompletionView({
    super.key,
    required this.completionStep,
    this.assetPath = '',
    this.surveyStepConfiguration,
  });

  final CompletionStep completionStep;
  final DateTime _startDate = DateTime.now();
  final String assetPath;
  final SurveyStepConfiguration? surveyStepConfiguration;

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: completionStep,
      resultFunction: () => CompletionStepResult(
        completionStep.stepIdentifier,
        _startDate,
        DateTime.now(),
      ),
      title: Text(
        completionStep.title,
        style: Theme.of(context).textTheme.displayMedium,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: Column(
          children: [
            Text(
              completionStep.text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: SizedBox(
                width: 150,
                height: 150,
                child: assetPath.isNotEmpty
                    ? Lottie.asset(
                        assetPath,
                        repeat: false,
                      )
                    : Lottie.asset(
                        'assets/fancy_checkmark.json',
                        package: 'survey_kit',
                        repeat: false,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
