import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:survey_kit/src/answer_format/integer_answer_format.dart';
import 'package:survey_kit/src/result/question/integer_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/decoration/input_decoration.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class IntegerAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final IntegerQuestionResult? result;

  const IntegerAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  _IntegerAnswerViewState createState() => _IntegerAnswerViewState();
}

class _IntegerAnswerViewState extends State<IntegerAnswerView> {
  late final IntegerAnswerFormat _integerAnswerFormat;
  late final TextEditingController _controller;
  late final DateTime _startDate;

  bool _changed = false;
  bool _isValid = false;
  FocusNode inputFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _integerAnswerFormat =
        widget.questionStep.answerFormat as IntegerAnswerFormat;
    _controller = TextEditingController();
    _controller.text = widget.result?.result?.toString() ??
        _integerAnswerFormat.savedResult?.result?.toString() ??
        '';
    _checkValidation(_controller.text);
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

  void _checkValidation(String text) {
    final sanitized = text.replaceAll(',', '.');
    setState(() {
      _isValid = text.isNotEmpty && double.tryParse(sanitized) != null;
      if (_isValid) _changed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      resultFunction: () {
        // Uses saved result only if there is not a local result
        if (!_changed &&
            _integerAnswerFormat.savedResult != null &&
            widget.result == null) {
          return _integerAnswerFormat.savedResult!;
        }

        final sanitized = _controller.text.replaceAll(',', '.');
        return IntegerQuestionResult(
          id: widget.questionStep.stepIdentifier,
          startDate: _startDate,
          endDate: DateTime.now(),
          valueIdentifier: _controller.text,
          result: double.tryParse(sanitized) ??
              _integerAnswerFormat.defaultValue ??
              null,
        );
      },
      isValid: _isValid || widget.questionStep.isOptional,
      title: widget.questionStep.title.isNotEmpty
          ? Text(
              widget.questionStep.title,
              style: widget.questionStep.title.length > 270
                  ? Theme.of(
                      context,
                    ).textTheme.displayMedium!.copyWith(fontSize: 21)
                  : Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            )
          : widget.questionStep.content,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: TextField(
            textInputAction: TextInputAction.next,
            focusNode: inputFocus,
            decoration: textFieldInputDecoration(
              hint: _integerAnswerFormat.hint,
            ),
            controller: _controller,
            onChanged: (String value) {
              _checkValidation(value);
            },
            keyboardType: TextInputType.numberWithOptions(
              signed: true,
              decimal: true,
            ),
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^-?\d*,?\d*$')),
            ],
          ),
        ),
      ),
    );
  }
}
