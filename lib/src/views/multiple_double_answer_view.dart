import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/src/answer_format/multi_double.dart';
import 'package:survey_kit/src/answer_format/multiple_double_answer_format.dart';
import 'package:survey_kit/src/result/question/multiple_double_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class MultipleDoubleAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final MultipleDoubleQuestionResult? result;

  const MultipleDoubleAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  State<MultipleDoubleAnswerView> createState() =>
      _MultipleDoubleAnswerViewState();
}

class _MultipleDoubleAnswerViewState extends State<MultipleDoubleAnswerView> {
  late final MultipleDoubleAnswerFormat _multipleDoubleAnswer;
  late final List<TextEditingController> _controller;
  late final DateTime _startDate;

  bool _isValid = false;
  bool _changed = false;
  List<MultiDouble> _insertedValues = [];

  @override
  void initState() {
    super.initState();
    _multipleDoubleAnswer =
        widget.questionStep.answerFormat as MultipleDoubleAnswerFormat;
    _controller = _multipleDoubleAnswer.hints.map((e) {
      return TextEditingController();
    }).toList();

    for (int i = 0; i <= _controller.length; i++) {
      final controller = _controller.elementAt(i);

      final val = widget.result?.result?.elementAtOrNull(i) ??
          _multipleDoubleAnswer.savedResult?.result?.elementAtOrNull(i);

      controller.text = val != null ? val.toString() : '';

      _checkValidation(controller.text);
    }

    _insertedValues = List.generate(
        _multipleDoubleAnswer.hints.length,
        (index) => MultiDouble(
              text: '',
              value: 0.0,
            ));

    _startDate = DateTime.now();
  }

  @override
  void dispose() {
    _controller.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  void _checkValidation(String text) {
    setState(() {
      _isValid =
          text.isNotEmpty && double.tryParse(text.replaceAll(',', '.')) != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    CurrencyTextInputFormatter _formatter = CurrencyTextInputFormatter.currency(
      locale: 'pt_BR',
      symbol: r'R$',
    );

    return StepView(
      step: widget.questionStep,
      resultFunction: () {
        // Uses saved result only if there is not a local result
        if (!_changed &&
            _multipleDoubleAnswer.savedResult != null &&
            widget.result == null) {
          return _multipleDoubleAnswer.savedResult!;
        }

        return MultipleDoubleQuestionResult(
          id: widget.questionStep.stepIdentifier,
          startDate: _startDate,
          endDate: DateTime.now(),
          valueIdentifier: _controller.map((e) => e.text).join(', '),
          result: _insertedValues,
        );
      },
      isValid: _isValid || widget.questionStep.isOptional,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text(
                widget.questionStep.text,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Column(
              children: [
                Divider(
                  color: Colors.grey,
                ),
                ..._multipleDoubleAnswer.hints
                    .asMap()
                    .entries
                    .map((MapEntry<int, String> md) {
                  return TextField(
                    inputFormatters: [_formatter],
                    textInputAction: TextInputAction.next,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: md.value,
                    ),
                    controller: _controller[md.key],
                    onChanged: (String value) {
                      value = _formatter.getUnformattedValue().toString();

                      _checkValidation(value);

                      _insertedValues[md.key] = MultiDouble(
                        text: md.value,
                        value: double.parse(value),
                      );

                      if (_isValid) _changed = true;
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                  );
                }).toList(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
