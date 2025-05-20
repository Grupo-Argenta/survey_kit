import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:survey_kit/src/configuration/app_bar_configuration.dart';
import 'package:survey_kit/src/navigator/navigable_task_navigator.dart';
import 'package:survey_kit/src/navigator/task_navigator.dart';
import 'package:survey_kit/src/presenter/survey_event.dart';
import 'package:survey_kit/src/presenter/survey_state.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/result/step_result.dart';
import 'package:survey_kit/src/result/survey/survey_result.dart';
import 'package:survey_kit/src/steps/identifier/identifier.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';
import 'package:survey_kit/src/steps/predefined_steps/instruction_step.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/steps/step.dart';

//TO DO: Extract gathering of the results into another class
class SurveyPresenter extends Bloc<SurveyEvent, SurveyState> {
  SurveyPresenter({
    required this.taskNavigator,
    required this.onResult,
  }) : super(LoadingSurveyState()) {
    on<StartSurvey>((event, emit) {
      emit(_handleInitialStep());
    });

    on<NextStep>((event, emit) {
      if (state is PresentingSurveyState) {
        emit(_handleNextStep(event, state as PresentingSurveyState));
      }
    });

    on<StepBack>((event, emit) {
      if (state is PresentingSurveyState) {
        emit(_handleStepBack(event, state as PresentingSurveyState));
      }
    });

    on<CloseSurvey>((event, emit) {
      if (state is PresentingSurveyState) {
        emit(_handleClose(event, state as PresentingSurveyState));
      }
    });

    on<SaveSurvey>((event, emit) {
      if (state is PresentingSurveyState) {
        emit(_handleSave(event, state as PresentingSurveyState));
      }
    });

    startDate = DateTime.now();
    add(StartSurvey());
  }

  final TaskNavigator taskNavigator;
  final void Function(SurveyResult) onResult;

  Set<QuestionResult<dynamic>> results = {};
  late final DateTime startDate;

  SurveyState _handleInitialStep() {
    final Step? step = taskNavigator.firstStep();

    // If first step is not the beginning of the survey
    if (taskNavigator.task.initalStepIdentifier != null) {
      // adds all results and add previous steps to history

      _insertSavedResults();
    }

    if (step != null) {
      return PresentingSurveyState(
        currentStep: step,
        questionResults: results,
        steps: taskNavigator.task.steps,
        currentStepIndex: currentStepIndex(step),
        stepCount: countSteps,
        appBarConfiguration: AppBarConfiguration(
          showProgress: step.showProgress,
          canGoBackWithLeading: step.canGoBack,
        ),
      );
    }

    //If no steps are provided we finish the survey
    final taskResult = SurveyResult(
      id: taskNavigator.task.id,
      startDate: startDate,
      endDate: DateTime.now(),
      startExecution: DateTime.now(),
      endExecution: DateTime.now(),
      finishReason: FinishReason.COMPLETED,
      results: const [],
      lastQuestionId: taskNavigator.peekHistory()?.stepIdentifier.id,
    );
    return SurveyResultState(
      result: taskResult,
      currentStep: null,
    );
  }

  void _insertSavedResults({Identifier? lastAnsweredQuestionId}) {
    final initialQuestionIndex = taskNavigator.task.steps.indexWhere(
      (step) =>
          step.stepIdentifier.id == taskNavigator.task.initalStepIdentifier?.id,
    );

    final lastAnsweredQuestionIndex = taskNavigator.task.steps.indexWhere(
      (step) => step.stepIdentifier.id == lastAnsweredQuestionId?.id,
    );

    for (int index = 0; index < taskNavigator.task.steps.length; index++) {
      final step = taskNavigator.task.steps[index];
      final isQuestionStep = step is QuestionStep;

      if (isQuestionStep) {
        // if doesn't have a base question, adds all results
        if (lastAnsweredQuestionId == null ||
            // if there is a base question, adds results from all questions that come after the base one,
            (lastAnsweredQuestionIndex > 0 &&
                index > lastAnsweredQuestionIndex &&
                // if they don't already have results
                !results.any(
                  (res) => res.id!.id == lastAnsweredQuestionId.id,
                ))) {
          _addResult(step.answerFormat.savedResult);
        }
      } else if (step is InstructionStep) {
        _addResult(step.result);
      }
      // // Only adds completion step
      // else if (step is CompletionStep && lastAnsweredQuestionId == null) {
      //   _addResult(step.result);
      // }

      if (isQuestionStep &&
          step.answerFormat.isChildQuestion &&
          step.answerFormat.savedResult == null) {
      }
      // only records steps until initial step (that is, the first question of a new survey or last answered question of a saved survey)
      else if (lastAnsweredQuestionId == null && index < initialQuestionIndex) {
        taskNavigator.record(step);
      }
    }
  }

  SurveyState _handleNextStep(
    NextStep event,
    PresentingSurveyState currentState,
  ) {
    _addResult(event.questionResult);
    final Step? nextStep = taskNavigator.nextStep(
      step: currentState.currentStep,
      questionResult: event.questionResult,
    );

    if (nextStep == null) {
      return _handleSurveyFinished(currentState);
    }

    final QuestionResult<dynamic>? questionResult =
        _getResultByStepIdentifier(nextStep.stepIdentifier);

    _resetChildQuestionState(questionResult, currentState);

    return PresentingSurveyState(
      currentStep: nextStep,
      result: questionResult,
      steps: taskNavigator.task.steps,
      questionResults: results,
      currentStepIndex: currentStepIndex(nextStep),
      stepCount: countSteps,
      appBarConfiguration: AppBarConfiguration(
        showProgress: nextStep.showProgress,
        canGoBackWithLeading: nextStep.canGoBack,
      ),
    );
  }

  SurveyState _handleStepBack(
    StepBack event,
    PresentingSurveyState currentState,
  ) {
    _addResult(event.questionResult);
    final Step? previousStep =
        taskNavigator.previousInList(currentState.currentStep);

    if (previousStep != null) {
      final QuestionResult<dynamic>? questionResult =
          _getResultByStepIdentifier(previousStep.stepIdentifier);

      return PresentingSurveyState(
        currentStep: previousStep,
        result: questionResult,
        steps: taskNavigator.task.steps,
        questionResults: results,
        currentStepIndex: currentStepIndex(previousStep),
        appBarConfiguration: AppBarConfiguration(
          showProgress: previousStep.showProgress,
          canGoBackWithLeading: previousStep.canGoBack,
        ),
        isPreviousStep: true,
        stepCount: countSteps,
      );
    }

    //If theres no previous step we can't go back further
    return state;
  }

  QuestionResult<dynamic>? _getResultByStepIdentifier(
    StepIdentifier? identifier,
  ) {
    return results.firstWhereOrNull(
      (element) => element.id == identifier,
    );
  }

  SurveyState _handleSave(
    SaveSurvey event,
    PresentingSurveyState currentState,
  ) {
    _addResult(event.questionResult);

    // Re-adds all saved results of questions that don't have new answers
    // and come after the current question, so that those saved answers aren't
    // lost
    _insertSavedResults(lastAnsweredQuestionId: event.questionResult!.id);

    final List<StepResult> stepResults =
        results.map((e) => StepResult.fromQuestion(questionResult: e)).toList();

    final taskResult = SurveyResult(
      id: taskNavigator.task.id,
      startDate: startDate,
      endDate: DateTime.now(),
      finishReason: FinishReason.SAVED,
      results: stepResults,
      startExecution: startDate,
      endExecution: DateTime.now(),
      lastQuestionId: currentState.currentStep.stepIdentifier.id,
    );
    return SurveyResultState(
      result: taskResult,
      stepResult: currentState.result,
      currentStep: currentState.currentStep,
    );
  }

  SurveyState _handleClose(
    CloseSurvey event,
    PresentingSurveyState currentState,
  ) {
    _addResult(event.questionResult);

    final List<StepResult> stepResults =
        results.map((e) => StepResult.fromQuestion(questionResult: e)).toList();

    final taskResult = SurveyResult(
      id: taskNavigator.task.id,
      startDate: startDate,
      endDate: DateTime.now(),
      startExecution: startDate,
      endExecution: DateTime.now(),
      finishReason: FinishReason.DISCARDED,
      results: stepResults,
      lastQuestionId: taskNavigator.peekHistory()?.stepIdentifier.id,
    );
    return SurveyResultState(
      result: taskResult,
      stepResult: currentState.result,
      currentStep: currentState.currentStep,
    );
  }

  //Currently we are only handling one question per step
  SurveyState _handleSurveyFinished(PresentingSurveyState currentState) {
    final List<StepResult> stepResults =
        results.map((e) => StepResult.fromQuestion(questionResult: e)).toList();
    final taskResult = SurveyResult(
      id: taskNavigator.task.id,
      startDate: startDate,
      endDate: DateTime.now(),
      startExecution: startDate,
      endExecution: DateTime.now(),
      finishReason: FinishReason.COMPLETED,
      results: stepResults,
      lastQuestionId: taskNavigator.peekHistory()?.stepIdentifier.id,
    );
    return SurveyResultState(
      result: taskResult,
      currentStep: currentState.currentStep,
      stepResult: currentState.result,
    );
  }

  void _addResult(
    QuestionResult<dynamic>? questionResult,
  ) {
    if (questionResult == null) {
      return;
    }
    results
      ..removeWhere(
        (QuestionResult<dynamic> result) => result.id == questionResult.id,
      )
      ..add(
        questionResult,
      );
  }

  int get countSteps => taskNavigator.countSteps;
  int currentStepIndex(Step step) {
    return taskNavigator.currentStepIndex(step);
  }

  void _resetChildQuestionState(
    QuestionResult<dynamic>? questionResult,
    PresentingSurveyState currentState,
  ) {
    if (questionResult != null &&
        taskNavigator is NavigableTaskNavigator &&
        currentState.currentStep is QuestionStep) {
      final navigator = taskNavigator as NavigableTaskNavigator;
      final currentStep = currentState.currentStep as QuestionStep;
      final childId = currentStep.answerFormat.childQuestionId;
      if (childId != null) {
        final nextStepIdentifier = navigator.getNextStepIdentifierByRule(
          currentStep.stepIdentifier,
          null,
          null,
        );

        // If next step is not the child,
        if (nextStepIdentifier?.id != childId.id) {
          // removes any saved result from the child question from the results stack
          results
              .removeWhere((whereResult) => whereResult.id?.id == childId.id);
          // removes child step from history
          taskNavigator.history.removeWhere(
            (whereStep) =>
                whereStep is QuestionStep &&
                whereStep.stepIdentifier.id == childId.id,
          );
        }
      }
    }
  }
}
