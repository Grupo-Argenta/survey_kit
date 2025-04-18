import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:survey_kit/src/answer_format/answer_format.dart';
import 'package:survey_kit/src/result/question/time_question_result.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';

part 'time_answer_formart.g.dart';

@JsonSerializable()
class TimeAnswerFormat implements AnswerFormat {
  @_TimeOfDayJsonConverter()
  final TimeOfDay? defaultValue;

  final TimeQuestionResult? savedResult;
  final bool isChildQuestion;
  final StepIdentifier? childQuestionId;

  const TimeAnswerFormat({
    this.defaultValue,
    this.savedResult,
    this.isChildQuestion = false,
    this.childQuestionId,
  }) : super();

  factory TimeAnswerFormat.fromJson(Map<String, dynamic> json) =>
      _$TimeAnswerFormatFromJson(json);
  Map<String, dynamic> toJson() => _$TimeAnswerFormatToJson(this);
}

class _TimeOfDayJsonConverter
    implements JsonConverter<TimeOfDay?, Map<String, dynamic>> {
  const _TimeOfDayJsonConverter();

  @override
  TimeOfDay? fromJson(Map<String, dynamic> json) {
    if (json['hour'] == null || json['minute'] == null) {
      return null;
    }
    return TimeOfDay(
      hour: json['hour'] as int,
      minute: json['minute'] as int,
    );
  }

  @override
  Map<String, dynamic> toJson(TimeOfDay? timeOfDay) => <String, dynamic>{
        'hour': timeOfDay?.hour,
        'minute': timeOfDay?.minute,
      };
}
