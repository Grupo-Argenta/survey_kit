import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/answer_format/answer_format.dart';
import 'package:survey_kit/src/answer_format/text_choice.dart';
import 'package:survey_kit/src/result/question/single_choice_question_result.dart';

part 'single_choice_answer_format.g.dart';

@JsonSerializable()
class SingleChoiceAnswerFormat implements AnswerFormat {
  final List<TextChoice> textChoices;
  final SingleChoiceQuestionResult? savedResult;

  const SingleChoiceAnswerFormat({
    required this.textChoices,
    this.savedResult,
  }) : super();

  factory SingleChoiceAnswerFormat.fromJson(Map<String, dynamic> json) =>
      _$SingleChoiceAnswerFormatFromJson(json);
  Map<String, dynamic> toJson() => _$SingleChoiceAnswerFormatToJson(this);
}
