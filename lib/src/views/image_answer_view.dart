import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:survey_kit/src/answer_format/image_answer_format.dart';
import 'package:survey_kit/src/result/question/image_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class ImageAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final ImageQuestionResult? result;

  const ImageAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  State<ImageAnswerView> createState() => _ImageAnswerViewState();
}

class _ImageAnswerViewState extends State<ImageAnswerView> {
  late final ImageAnswerFormat _imageAnswerFormat;
  late final DateTime _startDate;
  final ImagePicker _picker = ImagePicker();

  bool _isValid = false;
  String filePath = '';

  @override
  void initState() {
    super.initState();
    _retrieveLostData();
    _imageAnswerFormat = widget.questionStep.answerFormat as ImageAnswerFormat;
    _startDate = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();

    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.file != null && response.file?.path != null)
          filePath = response.file!.path;

        debugPrint('retrieved path: $filePath');
      });
    } else {
      debugPrint(response.exception!.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      resultFunction: () => ImageQuestionResult(
        id: widget.questionStep.stepIdentifier,
        startDate: _startDate,
        endDate: DateTime.now(),
        valueIdentifier: filePath,
        result: filePath,
      ),
      isValid: _isValid || widget.questionStep.isOptional,
      title: widget.questionStep.title.isNotEmpty
          ? Text(
              widget.questionStep.title,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            )
          : widget.questionStep.content,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _optionsDialogBox();
                      },
                      child: Text(_imageAnswerFormat.buttonText),
                    ),
                    filePath.isNotEmpty
                        ? Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                filePath
                                    .split('/')[filePath.split('/').length - 1],
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_imageAnswerFormat.useCamera)
                  TextButton.icon(
                    onPressed: () {
                      if (_imageAnswerFormat.hintImage != null &&
                          _imageAnswerFormat.hintTitle != null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              _imageAnswerFormat.hintTitle.toString(),
                              style: TextStyle(color: Colors.black),
                            ),
                            content: Image.network(
                              _imageAnswerFormat.hintImage.toString(),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    await _openCamera();
                                  },
                                  child: Text('Abrir câmera')),
                            ],
                          ),
                        );
                      } else {
                        _openCamera();
                      }
                    },
                    icon: const Icon(
                      Icons.photo_camera,
                      size: 30,
                    ),
                    label: const Text(
                      'Câmera',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                if (_imageAnswerFormat.useGallery &&
                    _imageAnswerFormat.useCamera)
                  Padding(padding: EdgeInsets.all(8.0)),
                if (_imageAnswerFormat.useGallery)
                  TextButton.icon(
                      onPressed: _openGallery,
                      icon: const Icon(
                        Icons.collections,
                        size: 30,
                      ),
                      label: Text(
                        'Galeria',
                        style: TextStyle(fontSize: 20),
                      ))
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCamera() async {
    var picture = await _picker.pickImage(
      preferredCameraDevice: CameraDevice.rear,
      source: ImageSource.camera,
    );

    if (picture != null) Navigator.of(context).pop();

    setState(() {
      if (picture != null && picture.path.isNotEmpty) filePath = picture.path;

      if (filePath.isNotEmpty) {
        _isValid = true;
      }
    });
  }

  Future<void> _openGallery() async {
    var picture = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    Navigator.of(context).pop();

    picture?.readAsBytes().then((value) {
      setState(() {
        filePath = picture.path;

        if (filePath.isNotEmpty) {
          _isValid = true;
        }
      });
    });
  }
}
