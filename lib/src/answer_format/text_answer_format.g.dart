// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_answer_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextAnswerFormat _$TextAnswerFormatFromJson(Map<String, dynamic> json) =>
    TextAnswerFormat(
      maxLines: (json['maxLines'] as num?)?.toInt(),
      hint: json['hint'] as String? ?? '',
      validationRegEx: json['validationRegEx'] as String? ?? r'^(?!s*$).+',
      savedResult: json['savedResult'] == null
          ? null
          : TextQuestionResult.fromJson(
              json['savedResult'] as Map<String, dynamic>),
      isChildQuestion: json['isChildQuestion'] as bool? ?? false,
      childQuestionId: json['childQuestionId'] == null
          ? null
          : StepIdentifier.fromJson(
              json['childQuestionId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TextAnswerFormatToJson(TextAnswerFormat instance) =>
    <String, dynamic>{
      'maxLines': instance.maxLines,
      'hint': instance.hint,
      'savedResult': instance.savedResult,
      'isChildQuestion': instance.isChildQuestion,
      'childQuestionId': instance.childQuestionId,
      'validationRegEx': instance.validationRegEx,
    };
