import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:survey_kit/src/controller/survey_controller.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/step.dart' as surveystep;

class StepView extends StatelessWidget {
  const StepView({
    super.key,
    required this.step,
    required this.child,
    required this.title,
    required this.resultFunction,
    this.controller,
    this.isValid = true,
  });
  final surveystep.Step step;
  final Widget title;
  final Widget child;
  final QuestionResult<dynamic> Function() resultFunction;
  final bool isValid;
  final SurveyController? controller;

  @override
  Widget build(BuildContext context) {
    final _surveyController = controller ?? context.read<SurveyController>();

    return _content(_surveyController, context);
  }

  Widget _content(SurveyController surveyController, BuildContext context) {
    return SizedBox.expand(
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: title,
                ),
                child,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (step.canGoBack)
                      _goBackButton(surveyController, context),
                    _finishLaterButton(surveyController, context),
                    _nextButton(surveyController, context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _nextButton(SurveyController surveyController, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: OutlinedButton(
        onPressed: isValid || step.isOptional
            ? () => surveyController.nextStep(
                  context,
                  resultFunction,
                )
            : null,
        style: step.surveyStepConfiguration?.nextQuestionButtonStyle,
        child: Text(
          context.read<Map<String, String>?>()?['next'] ??
              step.buttonText ??
              'Next',
          style: TextStyle(
            color: isValid ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }

  Padding _finishLaterButton(
    SurveyController surveyController,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: FilledButton(
        onPressed: () => surveyController.saveSurvey(
          context: context,
          resultFunction: resultFunction,
        ),
        style: step.surveyStepConfiguration?.finishLaterButtonStyle ??
            const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Color(0xFF00C3A4),
              ),
            ),
        child: Text(
          context.read<Map<String, String>?>()?['finish_later'] ??
              step.buttonText ??
              'Finish Later',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Padding _goBackButton(
    SurveyController surveyController,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: FilledButton(
        onPressed: () => surveyController.stepBack(
          context: context,
          resultFunction: resultFunction,
        ),
        style: step.surveyStepConfiguration?.goBackButtonStyle ??
            const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Color(0xFFDADADA),
              ),
            ),
        child: Text(
          context.read<Map<String, String>?>()?['go_back'] ??
              step.buttonText ??
              'Go Back',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
