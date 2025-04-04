// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'multiple_image_answer_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MultipleImageAnswerFormat _$MultipleImageAnswerFormatFromJson(
  Map<String, dynamic> json,
) => MultipleImageAnswerFormat(
  defaultValue:
      (json['defaultValue'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  buttonText: json['buttonText'] as String? ?? 'Image: ',
  useCamera: json['useCamera'] as bool? ?? true,
  useGallery: json['useGallery'] as bool? ?? true,
  hintImage:
      (json['hintImage'] as List<dynamic>?)?.map((e) => e as String).toList(),
  hintTitle:
      (json['hintTitle'] as List<dynamic>?)?.map((e) => e as String).toList(),
  savedResult:
      json['savedResult'] == null
          ? null
          : MultipleImageQuestionResult.fromJson(
            json['savedResult'] as Map<String, dynamic>,
          ),
  isChildQuestion: json['isChildQuestion'] as bool? ?? false,
  childQuestionId:
      json['childQuestionId'] == null
          ? null
          : StepIdentifier.fromJson(
            json['childQuestionId'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$MultipleImageAnswerFormatToJson(
  MultipleImageAnswerFormat instance,
) => <String, dynamic>{
  'defaultValue': instance.defaultValue,
  'savedResult': instance.savedResult,
  'buttonText': instance.buttonText,
  'useCamera': instance.useCamera,
  'useGallery': instance.useGallery,
  'hintImage': instance.hintImage,
  'hintTitle': instance.hintTitle,
  'isChildQuestion': instance.isChildQuestion,
  'childQuestionId': instance.childQuestionId,
};
