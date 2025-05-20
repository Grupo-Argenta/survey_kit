import 'package:flutter/material.dart';
import 'package:survey_kit/src/answer_format/boolean_answer_format.dart';
import 'package:survey_kit/src/result/question/boolean_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/selection_list_tile.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class BooleanAnswerView extends StatefulWidget {
  const BooleanAnswerView({
    super.key,
    required this.questionStep,
    required this.result,
  });

  final QuestionStep questionStep;
  final BooleanQuestionResult? result;

  @override
  State<BooleanAnswerView> createState() => _BooleanAnswerViewState();
}

class _BooleanAnswerViewState extends State<BooleanAnswerView> {
  late final BooleanAnswerFormat _answerFormat;
  late final DateTime _startDate;
  BooleanResult? _result;
  bool _changed = false;

  @override
  void initState() {
    super.initState();
    _answerFormat = widget.questionStep.answerFormat as BooleanAnswerFormat;
    _result = widget.result?.result ??
        _answerFormat.savedResult?.result ??
        _answerFormat.result;
    _startDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      resultFunction: () {
        // Uses saved result only if there is not a local result
        if (!_changed &&
            _answerFormat.savedResult != null &&
            widget.result == null) {
          return _answerFormat.savedResult!;
        }

        return BooleanQuestionResult(
          id: widget.questionStep.stepIdentifier,
          startDate: _startDate,
          endDate: DateTime.now(),
          valueIdentifier: _result == BooleanResult.POSITIVE
              ? _answerFormat.positiveAnswer
              : _result == BooleanResult.NEGATIVE
                  ? _answerFormat.negativeAnswer
                  : '',
          result: _result,
        );
      },
      title: widget.questionStep.title.isNotEmpty
          ? Text(
              widget.questionStep.title,
              style: widget.questionStep.title.length > 270
                  ? Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 21)
                  : Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            )
          : widget.questionStep.content,
      isValid: widget.questionStep.isOptional ||
          (_result != BooleanResult.NONE && _result != null),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Text(
              widget.questionStep.text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            children: [
              const Divider(
                color: Colors.grey,
              ),
              SelectionListTile(
                text: _answerFormat.positiveAnswer,
                onTap: () {
                  if (_result == BooleanResult.POSITIVE) {
                    _result = null;
                  } else {
                    _result = BooleanResult.POSITIVE;
                  }
                  setState(() {
                    _changed = true;
                  });
                },
                isSelected: _result == BooleanResult.POSITIVE,
              ),
              SelectionListTile(
                text: _answerFormat.negativeAnswer,
                onTap: () {
                  if (_result == BooleanResult.NEGATIVE) {
                    _result = null;
                  } else {
                    _result = BooleanResult.NEGATIVE;
                  }
                  setState(() {
                    _changed = true;
                  });
                },
                isSelected: _result == BooleanResult.NEGATIVE,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
