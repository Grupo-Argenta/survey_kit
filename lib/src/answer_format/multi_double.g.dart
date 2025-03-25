// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multi_double.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultiDouble _$MultiDoubleFromJson(Map<String, dynamic> json) => MultiDouble(
      text: json['text'] as String,
      value: (json['value'] as num).toDouble(),
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

Map<String, dynamic> _$MultiDoubleToJson(MultiDouble instance) =>
    <String, dynamic>{
      'text': instance.text,
      'value': instance.value,
      'savedResult': instance.savedResult,
      'isChildQuestion': instance.isChildQuestion,
      'childQuestionId': instance.childQuestionId,
    };
