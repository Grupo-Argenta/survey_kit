import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:survey_kit/src/result/question/star_question_result.dart';
import 'package:survey_kit/src/result/step/video_step_result.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/survey_kit.dart';

part 'step_result.g.dart';

@JsonSerializable(explicitToJson: true)
class StepResult extends Result {
  @_Converter()
  final List<QuestionResult> results;

  StepResult({
    required Identifier? id,
    required DateTime startDate,
    required DateTime endDate,
    required this.results,
  }) : super(id: id, startDate: startDate, endDate: endDate);

  factory StepResult.fromQuestion({required QuestionResult questionResult}) {
    return StepResult(
      id: questionResult.id,
      startDate: questionResult.startDate,
      endDate: questionResult.endDate,
      results: [questionResult],
    );
  }

  factory StepResult.fromJson(Map<String, dynamic> json) =>
      _$StepResultFromJson(json);

  @override
  String toString() => 'StepResult: $id, $startDate, $results';

  Map<String, dynamic> toJson() => _$StepResultToJson(this);

  @override
  List<Object?> get props => [id, startDate, endDate];
}

class _Converter implements JsonConverter<List<QuestionResult>, Object> {
  const _Converter();

  @override
  Object toJson(List<QuestionResult> questionResults) {
    List<Map<String, dynamic>> allQuestionResultsEncoded = [];

    for (QuestionResult qr in questionResults) {
      if (qr is BooleanQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'BooleanQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is DateQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'DateQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is DoubleQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'DoubleQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is IntegerQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'IntegerQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is MultipleDoubleQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'MultipleDoubleQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is MultipleDoubleQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'MultipleDoubleQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is MultipleChoiceQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'MultipleChoiceQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is ScaleQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'ScaleQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is SingleChoiceQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'SingleChoiceQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is TextQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'TextQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is StarQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'StarQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is TimeQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'TimeQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is InstructionStepResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'InstructionStepResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is CompletionStepResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'CompletionStepResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is VideoStepResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'VideoStepResult';
        allQuestionResultsEncoded.add(qrJson);
      } else if (qr is ImageQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'ImageQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
			} else if (qr is MultipleImageQuestionResult){
				final qrJson = qr.toJson();
				qrJson['type'] = 'MultipleImageQuestionResult';
				allQuestionResultsEncoded.add(qrJson);
      } else if (qr is HandDrawQuestionResult) {
        final qrJson = qr.toJson();
        qrJson['type'] = 'HandDrawQuestionResult';
        allQuestionResultsEncoded.add(qrJson);
      } else {
        _registerLog(qr.toString());
      }
    }

    return allQuestionResultsEncoded;
  }

  @override
  List<QuestionResult> fromJson(Object json) {
    final List<QuestionResult> results = [];
    for (var element in json as List<dynamic>) {
      final qData = element as Map<String, dynamic>;
      final qType = qData['type'] as String;

      if (qType == 'BooleanQuestionResult') {
        results.add(BooleanQuestionResult.fromJson(qData));
      } else if (qType == 'DateQuestionResult') {
        results.add(DateQuestionResult.fromJson(qData));
      } else if (qType == 'DoubleQuestionResult') {
        results.add(DoubleQuestionResult.fromJson(qData));
      } else if (qType == 'IntegerQuestionResult') {
        results.add(IntegerQuestionResult.fromJson(qData));
      } else if (qType == 'MultipleChoiceQuestionResult') {
        results.add(MultipleChoiceQuestionResult.fromJson(qData));
      } else if (qType == 'MultipleDoubleQuestionResult') {
        results.add(MultipleDoubleQuestionResult.fromJson(qData));
      } else if (qType == 'ScaleQuestionResult') {
        results.add(ScaleQuestionResult.fromJson(qData));
      } else if (qType == 'StarQuestionResult') {
        results.add(StarQuestionResult.fromJson(qData));
      } else if (qType == 'SingleChoiceQuestionResult') {
        results.add(SingleChoiceQuestionResult.fromJson(qData));
      } else if (qType == 'TextQuestionResult') {
        results.add(TextQuestionResult.fromJson(qData));
      } else if (qType == 'TimeQuestionResult') {
        results.add(TimeQuestionResult.fromJson(qData));
      } else if (qType == 'InstructionStepResult') {
        results.add(InstructionStepResult.fromJson(qData));
      } else if (qType == 'CompletionStepResult') {
        results.add(CompletionStepResult.fromJson(qData));
      } else if (qType == 'VideoStepResult') {
        results.add(VideoStepResult.fromJson(qData));
      } else if (qType == 'ImageQuestionResult') {
        results.add(ImageQuestionResult.fromJson(qData));
      } else if (qType == 'MultipleImageQuestionResult') {
        results.add(MultipleImageQuestionResult.fromJson(qData));
      } else if (qType == 'HandDrawQuestionResult') {
        results.add(HandDrawQuestionResult.fromJson(qData));
      } else {
        _registerLog(qType);
      }
    }

    return results;
  }

  Future<void> _registerLog(String questionType) async {
    final crashlytics = FirebaseCrashlytics.instance;
    await crashlytics.setCustomKey('question_type', questionType);

    throw ('Unhandled Question Result Type');
  }
}
