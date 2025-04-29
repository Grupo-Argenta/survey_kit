import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/answer_format/answer_format.dart';
import 'package:survey_kit/src/result/question/integer_question_result.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';

part 'integer_answer_format.g.dart';

@JsonSerializable()
class IntegerAnswerFormat implements AnswerFormat {
  final double? defaultValue;
  final String hint;
  final IntegerQuestionResult? savedResult;
  final bool isChildQuestion;
  final StepIdentifier? childQuestionId;

  const IntegerAnswerFormat({
    this.defaultValue,
    this.hint = '',
    this.savedResult,
    this.isChildQuestion = false,
    this.childQuestionId,
  }) : super();

  factory IntegerAnswerFormat.fromJson(Map<String, dynamic> json) =>
      _$IntegerAnswerFormatFromJson(json);
  Map<String, dynamic> toJson() => _$IntegerAnswerFormatToJson(this);
}
