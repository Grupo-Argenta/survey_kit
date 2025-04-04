// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hand_draw_answer_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HandDrawAnswerFormat _$HandDrawAnswerFormatFromJson(
        Map<String, dynamic> json) =>
    HandDrawAnswerFormat(
      savedResult: json['savedResult'] == null
          ? null
          : HandDrawQuestionResult.fromJson(
              json['savedResult'] as Map<String, dynamic>),
      isChildQuestion: json['isChildQuestion'] as bool? ?? false,
      childQuestionId: json['childQuestionId'] == null
          ? null
          : StepIdentifier.fromJson(
              json['childQuestionId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HandDrawAnswerFormatToJson(
        HandDrawAnswerFormat instance) =>
    <String, dynamic>{
      'savedResult': instance.savedResult,
      'isChildQuestion': instance.isChildQuestion,
      'childQuestionId': instance.childQuestionId,
    };
