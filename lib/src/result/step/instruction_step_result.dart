import 'package:survey_kit/src/result/question_result.dart';
import 'package:survey_kit/src/steps/identifier/step_identifier.dart';
import 'package:json_annotation/json_annotation.dart';

part 'instruction_step_result.g.dart';

@JsonSerializable(explicitToJson: true)
class InstructionStepResult extends QuestionResult {
  InstructionStepResult(
    StepIdentifier id,
    DateTime startDate,
    DateTime endDate,
  ) : super(
          id: id,
          startDate: startDate,
          endDate: endDate,
          valueIdentifier: 'instruction',
          result: null,
        );
  factory InstructionStepResult.fromJson(Map<String, dynamic> json) =>
      _$InstructionStepResultFromJson(json);

  Map<String, dynamic> toJson() => _$InstructionStepResultToJson(this);

  @override
  List<Object?> get props => [id, startDate, endDate, valueIdentifier];

  @override
  bool operator ==(o) => o is InstructionStepResult && o.id == id;

  @override
  int get hashCode => id.hashCode;
}
