// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_choice_answer_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipleChoiceAnswerFormat _$MultipleChoiceAnswerFormatFromJson(
        Map<String, dynamic> json) =>
    MultipleChoiceAnswerFormat(
      textChoices: (json['textChoices'] as List<dynamic>)
          .map((e) => TextChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      defaultValue: (json['defaultValue'] as List<dynamic>?)
              ?.map((e) => TextChoice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      otherField: json['otherField'] as bool? ?? false,
      maxAnswers: (json['maxAnswers'] as num?)?.toInt() ?? 100,
      savedResult: json['savedResult'] == null
          ? null
          : MultipleChoiceQuestionResult.fromJson(
              json['savedResult'] as Map<String, dynamic>),
      isChildQuestion: json['isChildQuestion'] as bool? ?? false,
      childQuestionId: json['childQuestionId'] == null
          ? null
          : StepIdentifier.fromJson(
              json['childQuestionId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MultipleChoiceAnswerFormatToJson(
        MultipleChoiceAnswerFormat instance) =>
    <String, dynamic>{
      'textChoices': instance.textChoices,
      'defaultValue': instance.defaultValue,
      'savedResult': instance.savedResult,
      'otherField': instance.otherField,
      'maxAnswers': instance.maxAnswers,
      'isChildQuestion': instance.isChildQuestion,
      'childQuestionId': instance.childQuestionId,
    };
