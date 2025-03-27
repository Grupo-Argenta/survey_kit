import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:survey_kit/src/answer_format/multiple_image_answer_format.dart';
import 'package:survey_kit/src/result/question/multiple_image_question_result.dart';
import 'package:survey_kit/survey_kit.dart';

class MultipleImageAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final MultipleImageQuestionResult? result;
  const MultipleImageAnswerView({
    super.key,
    required this.questionStep,
    required this.result,
  });

  @override
  State<MultipleImageAnswerView> createState() =>
      _MultipleImageAnswerViewState();
}

class _MultipleImageAnswerViewState extends State<MultipleImageAnswerView> {
  late final MultipleImageAnswerFormat _multipleImageAnswerFormat;
  late final DateTime _startDate;
  final ImagePicker _picker = ImagePicker();

  bool _isValid = false;
  bool _changed = false;
  List<String> filePaths = [];

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      resultFunction: () {
        if (!_changed && _multipleImageAnswerFormat.savedResult != null) {
          return _multipleImageAnswerFormat.savedResult!;
        }
        return MultipleImageQuestionResult(
          id: widget.questionStep.stepIdentifier,
          startDate: _startDate,
          endDate: DateTime.now(),
          valueIdentifier: filePaths.toString(),
          result: filePaths,
        );
      },
      title:
          widget.questionStep.title.isNotEmpty
              ? Text(
                widget.questionStep.title,
                style:
                    widget.questionStep.title.length > 270
                        ? Theme.of(
                          context,
                        ).textTheme.displayMedium!.copyWith(fontSize: 21)
                        : Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              )
              : widget.questionStep.content,
      child: Text('Carregando imagens'),
    );
  }

  @override
  void initState() {
    print('iniciou multiple image');
    super.initState();
    _retrieveLostData();
    _multipleImageAnswerFormat =
        widget.questionStep.answerFormat as MultipleImageAnswerFormat;
  }

  _retrieveLostData() async {
    return false;
  }
}
