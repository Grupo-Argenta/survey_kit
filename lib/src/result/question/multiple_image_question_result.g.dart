// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_image_question_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipleImageQuestionResult _$MultipleImageQuestionResultFromJson(
        Map<String, dynamic> json) =>
    MultipleImageQuestionResult(
      id: Identifier.fromJson(json['id'] as Map<String, dynamic>),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      valueIdentifier: json['valueIdentifier'] as String,
      result:
          (json['result'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$MultipleImageQuestionResultToJson(
        MultipleImageQuestionResult instance) =>
    <String, dynamic>{
      'id': instance.id?.toJson(),
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'result': instance.result,
      'valueIdentifier': instance.valueIdentifier,
    };
