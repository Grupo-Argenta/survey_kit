// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_choice_answer_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SingleChoiceAnswerFormat _$SingleChoiceAnswerFormatFromJson(
        Map<String, dynamic> json) =>
    SingleChoiceAnswerFormat(
      textChoices: (json['textChoices'] as List<dynamic>)
          .map((e) => TextChoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      savedResult: json['savedResult'] == null
          ? null
          : SingleChoiceQuestionResult.fromJson(
              json['savedResult'] as Map<String, dynamic>),
      isChildQuestion: json['isChildQuestion'] as bool? ?? false,
      childQuestionId: json['childQuestionId'] == null
          ? null
          : StepIdentifier.fromJson(
              json['childQuestionId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SingleChoiceAnswerFormatToJson(
        SingleChoiceAnswerFormat instance) =>
    <String, dynamic>{
      'textChoices': instance.textChoices,
      'savedResult': instance.savedResult,
      'isChildQuestion': instance.isChildQuestion,
      'childQuestionId': instance.childQuestionId,
    };
