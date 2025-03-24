import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/identifier/identifier.dart';

part 'hand_draw_question_result.g.dart';

@JsonSerializable(explicitToJson: true)
class HandDrawQuestionResult
    extends QuestionResult<HandDrawQuestionSignatureResult?> {
  HandDrawQuestionResult({
    required Identifier id,
    required DateTime startDate,
    required DateTime endDate,
    required String valueIdentifier,
    required HandDrawQuestionSignatureResult? result,
  }) : super(
          id: id,
          startDate: startDate,
          endDate: endDate,
          valueIdentifier: valueIdentifier,
          result: result,
        );

  factory HandDrawQuestionResult.fromJson(Map<String, dynamic> json) =>
      _$HandDrawQuestionResultFromJson(json);

  Map<String, dynamic> toJson() => _$HandDrawQuestionResultToJson(this);

  @override
  List<Object?> get props => [id, startDate, endDate, valueIdentifier, result];
}

@JsonSerializable()
class HandDrawQuestionSignatureResult {
  String name;
  String? signatureImageUrl;

  HandDrawQuestionSignatureResult(
      {required this.name, required this.signatureImageUrl});

  factory HandDrawQuestionSignatureResult.fromJson(Map<String, dynamic> json) =>
      _$HandDrawQuestionSignatureResultFromJson(json);

  Map<String, dynamic> toJson() =>
      _$HandDrawQuestionSignatureResultToJson(this);
}
