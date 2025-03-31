import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:survey_kit/src/answer_format/image_answer_format.dart';
import 'package:survey_kit/src/result/question/image_question_result.dart';
import 'package:survey_kit/src/steps/predefined_steps/question_step.dart';
import 'package:survey_kit/src/views/widget/step_view.dart';

class ImageAnswerView extends StatefulWidget {
  const ImageAnswerView({
    super.key,
    required this.questionStep,
    required this.result,
  });
  final QuestionStep questionStep;
  final ImageQuestionResult? result;

  @override
  State<ImageAnswerView> createState() => _ImageAnswerViewState();
}

class _ImageAnswerViewState extends State<ImageAnswerView> {
  late final ImageAnswerFormat _imageAnswerFormat;
  late final DateTime _startDate;
  final ImagePicker _picker = ImagePicker();

  bool _isValid = false;
  bool _changed = false;
  String filePath = '';

  @override
  void initState() {
    super.initState();
    _retrieveLostData();
    _imageAnswerFormat = widget.questionStep.answerFormat as ImageAnswerFormat;

    final savedResult = _imageAnswerFormat.savedResult;
    if (savedResult != null && savedResult.result != null) {
      filePath = savedResult.result!;
      setState(() {
        _isValid = true;
      });
    }

    _startDate = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _retrieveLostData() async {
    final response = await _picker.retrieveLostData();

    if (response.isEmpty) {
      return;
    }

    if (response.file != null) {
      setState(() {
        if (response.file != null && response.file?.path != null) {
          filePath = response.file!.path;
        }

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
      resultFunction: () {
        if (!_changed && _imageAnswerFormat.savedResult != null) {
          return _imageAnswerFormat.savedResult!;
        }

        return ImageQuestionResult(
          id: widget.questionStep.stepIdentifier,
          startDate: _startDate,
          endDate: DateTime.now(),
          valueIdentifier: filePath,
          result: filePath,
        );
      },
      isValid: _isValid || widget.questionStep.isOptional,
      title:
          widget.questionStep.title.isNotEmpty
              ? Text(
                widget.questionStep.title,
                style:
                    widget.questionStep.title.length > 270
                        ? Theme.of(
                          context,
                        ).textTheme.displayMedium!.copyWith(fontSize: 21)
                        : Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              )
              : widget.questionStep.content,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _optionsDialogBox,
                      child: Text(_imageAnswerFormat.buttonText),
                    ),
                    if (filePath.isNotEmpty)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            filePath.split('/')[filePath.split('/').length - 1],
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                    else
                      const SizedBox(),
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
                        showDialog<void>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: Text(
                                  _imageAnswerFormat.hintTitle.toString(),
                                  style: const TextStyle(color: Colors.black),
                                ),
                                content: Image.network(
                                  _imageAnswerFormat.hintImage.toString(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      await _openCamera(context);
                                    },
                                    child: const Text('Abrir câmera'),
                                  ),
                                ],
                              ),
                        );
                      } else {
                        _openCamera(context);
                      }
                    },
                    icon: const Icon(Icons.photo_camera, size: 30),
                    label: const Text('Câmera', style: TextStyle(fontSize: 20)),
                  ),
                if (_imageAnswerFormat.useGallery &&
                    _imageAnswerFormat.useCamera)
                  const Padding(padding: EdgeInsets.all(8)),
                if (_imageAnswerFormat.useGallery)
                  TextButton.icon(
                    onPressed: _openGallery,
                    icon: const Icon(Icons.collections, size: 30),
                    label: const Text(
                      'Galeria',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCamera(BuildContext context) async {
    final crashlytics = FirebaseCrashlytics.instance;

    await crashlytics.setCustomKey('img_src', 'CAMERA');

    try {
      await crashlytics.log('Opening camera image picker');

      // Original Camera implementation
      //final picture = await _picker.pickImage(
      //  source: ImageSource.gallery,
      //);
      //
      //await picture?.readAsBytes().then((value) {
      //  setState(() {
      //    filePath = picture.path;
      //
      //    if (filePath.isNotEmpty) {
      //      _isValid = true;
      //    }
      //  });
      //
      //  Navigator.of(context).pop();
      //});

      var control = false;
      // New Camera implementation using cameraawesome
      // ignore: use_build_context_synchronously
      await showDialog<void>(
        context: context,
        useRootNavigator: false,
        builder:
            (BuildContext contextDialog) => CameraAwesomeBuilder.custom(
              enablePhysicalButton: true,
              builder: (state, preview) {
                state.captureState$.listen((event) {
                  if (event?.status == MediaCaptureStatus.capturing) {
                    control = false;
                  }
                  if (event?.status == MediaCaptureStatus.success &&
                      control == false) {
                    event?.captureRequest.when(
                      single: (single) async {
                        if (single.file?.path != null) {
                          final file = File(single.file!.path);
                          final result = await showDialog<bool>(
                            context: contextDialog,
                            useRootNavigator: false,
                            builder:
                                (BuildContext newContext) =>
                                    _picturePreview(file, newContext),
                          );

                          if (result == true) {
                            setState(() {
                              filePath = single.file!.path;
                              _isValid = true;
                              _changed = true;
                            });

                            Navigator.of(context).pop();
                            Navigator.of(context).pop();

                            if (!file.existsSync()) {
                              throw Exception('Erro ao bater foto');
                            }
                          } else {
                            control = true;
                          }
                        }
                      },
                    );
                  }
                });

                return AwesomeCameraLayout(
                  state: state,
                  topActions: const SizedBox.shrink(),
                  middleContent: const SizedBox.shrink(),
                  bottomActions: AwesomeBottomActions(
                    state: state,
                    left: AwesomeFlashButton(state: state),
                    right: const SizedBox.shrink(),
                  ),
                );
              },
              saveConfig: SaveConfig.photo(
                pathBuilder: (sensors) async {
                  final extDir = await getTemporaryDirectory();
                  final testDir = await Directory(
                    '${extDir.path}/camerawesome',
                  ).create(recursive: true);
                  final filePath =
                      '${testDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

                  await crashlytics.log(
                    'Camera image picker successfully opened',
                  );

                  return SingleCaptureRequest(filePath, sensors.first);
                },
              ),
              previewFit: CameraPreviewFit.contain,
              sensorConfig: SensorConfig.single(
                sensor: Sensor.position(SensorPosition.back),
                aspectRatio: CameraAspectRatios.ratio_16_9,
              ),
            ),
      );
    } catch (err, stacktrace) {
      final status = await Permission.camera.status;
      await crashlytics.setCustomKey('camera_permission', status.toString());
      // Logar exceção caso ocorra um erro ao abrir a câmera
      await crashlytics.recordError(
        err,
        stacktrace,
        reason: 'Awesome Camera error',
      );
    }
  }

  Scaffold _picturePreview(File file, BuildContext newContext) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image(
              height: MediaQuery.sizeOf(newContext).height * .8,
              width: MediaQuery.sizeOf(newContext).width * .9,
              image: FileImage(file),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(newContext).pop(false);
                    },
                    iconSize: 48,
                    icon: Icon(Icons.clear, color: Colors.white),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(newContext).pop(true);
                    },
                    iconSize: 48,
                    icon: Icon(Icons.check, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openGallery() async {
    final crashlytics = FirebaseCrashlytics.instance;

    await crashlytics.setCustomKey('img_src', 'GALLERY');

    try {
      await crashlytics.log('Opening gallery image picker');

      final picture = await _picker.pickImage(source: ImageSource.gallery);

      await picture?.readAsBytes().then((value) {
        setState(() {
          filePath = picture.path;

          if (filePath.isNotEmpty) {
            _isValid = true;
            _changed = true;
          }
        });

        Navigator.of(context).pop();
      });
      await crashlytics.log('Gallery image picker successfully opened');
    } catch (err, stacktrace) {
      final status = await Permission.photos.status;
      await crashlytics.setCustomKey('camera_permission', status.toString());
      // Logar exceção caso ocorra um erro ao abrir a câmera
      await crashlytics.recordError(
        err,
        stacktrace,
        reason: 'Image picker error',
      );
    }
  }
}
