// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_answer_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageAnswerFormat _$ImageAnswerFormatFromJson(Map<String, dynamic> json) =>
    ImageAnswerFormat(
      defaultValue: json['defaultValue'] as String?,
      buttonText: json['buttonText'] as String? ?? 'Image: ',
      useCamera: json['useCamera'] as bool? ?? true,
      useGallery: json['useGallery'] as bool? ?? true,
      hintImage: json['hintImage'] as String?,
      hintTitle: json['hintTitle'] as String?,
      savedResult: json['savedResult'] == null
          ? null
          : ImageQuestionResult.fromJson(
              json['savedResult'] as Map<String, dynamic>),
      isChildQuestion: json['isChildQuestion'] as bool? ?? false,
      childQuestionId: json['childQuestionId'] == null
          ? null
          : StepIdentifier.fromJson(
              json['childQuestionId'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ImageAnswerFormatToJson(ImageAnswerFormat instance) =>
    <String, dynamic>{
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
