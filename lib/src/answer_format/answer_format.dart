// Edited by Antonio Bruno, Giacomo Ignesti and Massimo Martinelli  2022

import 'package:survey_kit/src/answer_format/boolean_answer_format.dart';
import 'package:survey_kit/src/answer_format/date_answer_format.dart';
import 'package:survey_kit/src/answer_format/double_answer_format.dart';
import 'package:survey_kit/src/answer_format/multiple_choice_auto_complete_answer_format.dart';
import 'package:survey_kit/src/answer_format/multiple_double_answer_format.dart';
import 'package:survey_kit/src/answer_format/image_answer_format.dart';
import 'package:survey_kit/src/answer_format/multiple_image_answer_format.dart';
import 'package:survey_kit/src/answer_format/integer_answer_format.dart';
import 'package:survey_kit/src/answer_format/multiple_choice_answer_format.dart';
import 'package:survey_kit/src/answer_format/scale_answer_format.dart';
import 'package:survey_kit/src/answer_format/single_choice_answer_format.dart';
import 'package:survey_kit/src/answer_format/star_answer_format.dart';
import 'package:survey_kit/src/answer_format/text_answer_format.dart';
import 'package:survey_kit/src/answer_format/time_answer_formart.dart';
import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';
import 'package:survey_kit/src/steps/predefined_steps/answer_format_not_defined_exception.dart';

abstract class AnswerFormat {
  const AnswerFormat({
    this.savedResult,
    this.isChildQuestion = false,
    this.childQuestionId,
  });

  final QuestionResult? savedResult;
  final bool isChildQuestion;
  final StepIdentifier? childQuestionId;

  factory AnswerFormat.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'bool':
        return BooleanAnswerFormat.fromJson(json);
      case 'integer':
        return IntegerAnswerFormat.fromJson(json);
      case 'double':
        return DoubleAnswerFormat.fromJson(json);
      case 'text':
        return TextAnswerFormat.fromJson(json);
      case 'date':
        return DateAnswerFormat.fromJson(json);
      case 'single':
        return SingleChoiceAnswerFormat.fromJson(json);
      case 'multiple':
        return MultipleChoiceAnswerFormat.fromJson(json);
      case 'multiple_double':
        return MultipleDoubleAnswerFormat.fromJson(json);
      case 'multiple_auto_complete':
        return MultipleChoiceAutoCompleteAnswerFormat.fromJson(json);
      case 'scale':
        return ScaleAnswerFormat.fromJson(json);
      case 'time':
        return TimeAnswerFormat.fromJson(json);
      case 'file':
        return ImageAnswerFormat.fromJson(json);
      case 'multiple_file':
        return MultipleImageAnswerFormat.fromJson(json);
      case 'star':
        return StarAnswerFormat.fromJson(json);
      default:
        throw AnswerFormatNotDefinedException();
    }
  }
  Map<String, dynamic> toJson();
}
