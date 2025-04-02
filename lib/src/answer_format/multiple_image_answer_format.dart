import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/answer_format/answer_format.dart';
import 'package:survey_kit/src/result/question/image_question_result.dart';
import 'package:survey_kit/src/result/question/multiple_image_question_result.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';

part 'multiple_image_answer_format.g.dart';

@JsonSerializable()
class MultipleImageAnswerFormat implements AnswerFormat {
  final List<String>? defaultValue;
  final MultipleImageQuestionResult? savedResult;
  final String buttonText;
  final bool useCamera;
  final bool useGallery;
  final List<String>? hintImage;
  final List<String>? hintTitle;

  final bool isChildQuestion;
  final StepIdentifier? childQuestionId;

  @override
  toString() => 'MultipleImageAnswerFormat(${toJson()})';

  const MultipleImageAnswerFormat({
    this.defaultValue,
    this.buttonText = 'Image: ',
    this.useCamera = true,
    this.useGallery = true,
    this.hintImage,
    this.hintTitle,
    this.savedResult,
    this.isChildQuestion = false,
    this.childQuestionId,
  }) : super();

  factory MultipleImageAnswerFormat.fromJson(Map<String, dynamic> json) =>
      _$MultipleImageAnswerFormatFromJson(json);

  Map<String, dynamic> toJson() => _$MultipleImageAnswerFormatToJson(this);
}
