import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/identifier/identifier.dart';

part 'multiple_image_question_result.g.dart';

@JsonSerializable(explicitToJson: true)
class MultipleImageQuestionResult extends QuestionResult<List<String>?> {
  MultipleImageQuestionResult({
    required Identifier id,
    required DateTime startDate,
    required DateTime endDate,
    required String valueIdentifier,
    required List<String>? result,
  }) : super(
         id: id,
         startDate: startDate,
         endDate: endDate,
         valueIdentifier: valueIdentifier,
         result: result,
       );

  factory MultipleImageQuestionResult.fromJson(Map<String, dynamic> json) =>
      _$MultipleImageQuestionResultFromJson(json);

  Map<String, dynamic> toJson() => _$MultipleImageQuestionResultToJson(this);

  @override
  List<Object?> get props => [id, startDate, endDate, valueIdentifier, result];
}
