// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'star_answer_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StarAnswerFormat _$StarAnswerFormatFromJson(Map<String, dynamic> json) =>
    StarAnswerFormat(
      defaultValue: (json['defaultValue'] as num?)?.toDouble(),
      hint: json['hint'] as String? ?? '',
      savedResult: json['savedResult'] == null
          ? null
          : StarQuestionResult.fromJson(
              json['savedResult'] as Map<String, dynamic>),
      isChildQuestion: json['isChildQuestion'] as bool? ?? false,
      childQuestionId: json['childQuestionId'] == null
          ? null
          : StepIdentifier.fromJson(
              json['childQuestionId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StarAnswerFormatToJson(StarAnswerFormat instance) =>
    <String, dynamic>{
      'defaultValue': instance.defaultValue,
      'hint': instance.hint,
      'savedResult': instance.savedResult,
      'isChildQuestion': instance.isChildQuestion,
      'childQuestionId': instance.childQuestionId,
    };
