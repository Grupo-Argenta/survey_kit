// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_double_answer_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipleDoubleAnswerFormat _$MultipleDoubleAnswerFormatFromJson(
        Map<String, dynamic> json) =>
    MultipleDoubleAnswerFormat(
      defaultValue: (json['defaultValue'] as List<dynamic>?)
          ?.map((e) => MultiDouble.fromJson(e as Map<String, dynamic>))
          .toList(),
      hints:
          (json['hints'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      savedResult: json['savedResult'] == null
          ? null
          : MultipleDoubleQuestionResult.fromJson(
              json['savedResult'] as Map<String, dynamic>),
      isChildQuestion: json['isChildQuestion'] as bool? ?? false,
      childQuestionId: json['childQuestionId'] == null
          ? null
          : StepIdentifier.fromJson(
              json['childQuestionId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MultipleDoubleAnswerFormatToJson(
        MultipleDoubleAnswerFormat instance) =>
    <String, dynamic>{
      'defaultValue': instance.defaultValue,
      'hints': instance.hints,
      'savedResult': instance.savedResult,
      'isChildQuestion': instance.isChildQuestion,
      'childQuestionId': instance.childQuestionId,
    };
