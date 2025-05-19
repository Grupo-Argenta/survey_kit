import 'package:flutter/material.dart';
import 'package:survey_kit/src/answer_format/text_answer_format.dart';
import 'package:survey_kit/src/result/question/text_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/decoration/input_decoration.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class TextAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final TextQuestionResult? result;

  const TextAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  _TextAnswerViewState createState() => _TextAnswerViewState();
}

class _TextAnswerViewState extends State<TextAnswerView> {
  late final TextAnswerFormat _textAnswerFormat;
  late final DateTime _startDate;

  late final TextEditingController _controller;
  bool _isValid = false;
  bool _changed = false;
  FocusNode inputFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _textAnswerFormat = widget.questionStep.answerFormat as TextAnswerFormat;

    if (widget.result?.result != null) {
      _controller.text = widget.result?.result ?? '';
    } else if (_textAnswerFormat.savedResult != null) {
      _controller.text = _textAnswerFormat.savedResult?.result ?? '';
    }
    _checkValidation(_controller.text);
    _startDate = DateTime.now();

    Future.delayed(Duration(seconds: 0), () {
      inputFocus.requestFocus();
    });
  }

  void _checkValidation(String text) {
    setState(() {
      if (_textAnswerFormat.validationRegEx != null) {
        RegExp regExp = new RegExp(_textAnswerFormat.validationRegEx!);
        _isValid = regExp.hasMatch(text);
      } else {
        _isValid = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      resultFunction: () {
        if (!_changed && _textAnswerFormat.savedResult != null) {
          return _textAnswerFormat.savedResult!;
        }

        return TextQuestionResult(
          id: widget.questionStep.stepIdentifier,
          startDate: _startDate,
          endDate: DateTime.now(),
          valueIdentifier: _controller.text,
          result: _controller.text,
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
      isValid: _isValid || widget.questionStep.isOptional,
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 32.0, left: 14.0, right: 14.0),
            child: Text(
              widget.questionStep.text,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: TextField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              focusNode: inputFocus,
              decoration: textFieldInputDecoration(
                hint: _textAnswerFormat.hint,
              ),
              controller: _controller,
              textAlign: TextAlign.center,
              onChanged: (String text) {
                _checkValidation(text);

                if (_isValid) {
                  setState(() {
                    _changed = true;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
