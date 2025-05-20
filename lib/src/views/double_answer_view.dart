import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:survey_kit/src/answer_format/double_answer_format.dart';
import 'package:survey_kit/src/result/question/double_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/decoration/input_decoration.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class DoubleAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final DoubleQuestionResult? result;

  const DoubleAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  _DoubleAnswerViewState createState() => _DoubleAnswerViewState();
}

class _DoubleAnswerViewState extends State<DoubleAnswerView> {
  late final DoubleAnswerFormat _doubleAnswerFormat;
  late final TextEditingController _controller;
  late final DateTime _startDate;

  bool _isValid = false;
  bool _changed = false;
  FocusNode inputFocus = FocusNode();

  final CurrencyTextInputFormatter _formatter =
      CurrencyTextInputFormatter.currency(
    locale: 'pt_BR',
    symbol: r'R$',
  );

  @override
  void initState() {
    super.initState();
    _doubleAnswerFormat =
        widget.questionStep.answerFormat as DoubleAnswerFormat;
    _controller = TextEditingController();
    _controller.text = widget.result?.valueIdentifier ??
        _doubleAnswerFormat.savedResult?.result?.toString() ??
        '';
    _checkValidation(_controller.text, _controller.text);
    _startDate = DateTime.now();

    Future.delayed(Duration(seconds: 0), () {
      inputFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkValidation(String text, String value) {
    double parsedValue = 0.0;
    if (double.tryParse(text
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .replaceAll('R', '')
            .replaceAll('\$', '')
            .replaceAll(' ', '')) !=
        null) {
      parsedValue = double.tryParse(text
          .replaceAll('.', '')
          .replaceAll(',', '.')
          .replaceAll('R', '')
          .replaceAll('\$', '')
          .replaceAll(' ', ''))!;
    }
    setState(() {
      _isValid = value.isNotEmpty &&
          text.isNotEmpty &&
          double.tryParse(text
                  .replaceAll('.', '')
                  .replaceAll(',', '.')
                  .replaceAll('R', '')
                  .replaceAll('\$', '')
                  .replaceAll(' ', '')) !=
              null &&
          parsedValue > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      resultFunction: () {
        // Uses saved result only if there is not a local result
        if (!_changed &&
            _doubleAnswerFormat.savedResult != null &&
            widget.result == null) {
          return _doubleAnswerFormat.savedResult!;
        }

        return DoubleQuestionResult(
          id: widget.questionStep.stepIdentifier,
          startDate: _startDate,
          endDate: DateTime.now(),
          valueIdentifier: _controller.text,
          result: double.tryParse(_controller.text
                  .replaceAll('.', '')
                  .replaceAll(',', '.')
                  .replaceAll('R', '')
                  .replaceAll('\$', '')
                  .replaceAll(' ', '')) ??
              _doubleAnswerFormat.defaultValue ??
              null,
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
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            inputFormatters: [_formatter],
            focusNode: inputFocus,
            decoration: textFieldInputDecoration(
              hint: _doubleAnswerFormat.hint,
            ),
            controller: _controller,
            onChanged: (String value) {
              setState(() {
                _changed = true;
              });
              _checkValidation(
                  _formatter.getUnformattedValue().toString(), value);
            },
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
