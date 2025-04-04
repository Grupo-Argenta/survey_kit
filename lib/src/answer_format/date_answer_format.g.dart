// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'date_answer_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateAnswerFormat _$DateAnswerFormatFromJson(Map<String, dynamic> json) =>
    DateAnswerFormat(
      defaultValue: json['defaultValue'] == null
          ? null
          : DateTime.parse(json['defaultValue'] as String),
      minDate: json['minDate'] == null
          ? null
          : DateTime.parse(json['minDate'] as String),
      maxDate: json['maxDate'] == null
          ? null
          : DateTime.parse(json['maxDate'] as String),
      savedResult: json['savedResult'] == null
          ? null
          : DateQuestionResult.fromJson(
              json['savedResult'] as Map<String, dynamic>),
      isChildQuestion: json['isChildQuestion'] as bool? ?? false,
      childQuestionId: json['childQuestionId'] == null
          ? null
          : StepIdentifier.fromJson(
              json['childQuestionId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DateAnswerFormatToJson(DateAnswerFormat instance) =>
    <String, dynamic>{
      'defaultValue': instance.defaultValue?.toIso8601String(),
      'minDate': instance.minDate?.toIso8601String(),
      'maxDate': instance.maxDate?.toIso8601String(),
      'savedResult': instance.savedResult,
      'isChildQuestion': instance.isChildQuestion,
      'childQuestionId': instance.childQuestionId,
    };
