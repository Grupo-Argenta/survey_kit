// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_answer_formart.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeAnswerFormat _$TimeAnswerFormatFromJson(Map<String, dynamic> json) =>
    TimeAnswerFormat(
      defaultValue: _$JsonConverterFromJson<Map<String, dynamic>, TimeOfDay?>(
          json['defaultValue'], const _TimeOfDayJsonConverter().fromJson),
      savedResult: json['savedResult'] == null
          ? null
          : TimeQuestionResult.fromJson(
              json['savedResult'] as Map<String, dynamic>),
      isChildQuestion: json['isChildQuestion'] as bool? ?? false,
      childQuestionId: json['childQuestionId'] == null
          ? null
          : StepIdentifier.fromJson(
              json['childQuestionId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimeAnswerFormatToJson(TimeAnswerFormat instance) =>
    <String, dynamic>{
      'defaultValue':
          const _TimeOfDayJsonConverter().toJson(instance.defaultValue),
      'savedResult': instance.savedResult,
      'isChildQuestion': instance.isChildQuestion,
      'childQuestionId': instance.childQuestionId,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
