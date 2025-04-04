// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_choice_auto_complete_answer_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipleChoiceAutoCompleteAnswerFormat
    _$MultipleChoiceAutoCompleteAnswerFormatFromJson(
            Map<String, dynamic> json) =>
        MultipleChoiceAutoCompleteAnswerFormat(
          textChoices: (json['textChoices'] as List<dynamic>)
              .map((e) => TextChoice.fromJson(e as Map<String, dynamic>))
              .toList(),
          defaultValue: (json['defaultValue'] as List<dynamic>?)
                  ?.map((e) => TextChoice.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
          suggestions: (json['suggestions'] as List<dynamic>?)
                  ?.map((e) => TextChoice.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
          otherField: json['otherField'] as bool? ?? false,
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

Map<String, dynamic> _$MultipleChoiceAutoCompleteAnswerFormatToJson(
        MultipleChoiceAutoCompleteAnswerFormat instance) =>
    <String, dynamic>{
      'textChoices': instance.textChoices,
      'defaultValue': instance.defaultValue,
      'savedResult': instance.savedResult,
      'suggestions': instance.suggestions,
      'otherField': instance.otherField,
      'isChildQuestion': instance.isChildQuestion,
      'childQuestionId': instance.childQuestionId,
    };
