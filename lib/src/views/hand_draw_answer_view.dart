import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hand_signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:survey_kit/survey_kit.dart';
import 'package:uuid/uuid.dart';

class HandDrawAnswerView extends StatefulWidget {
  const HandDrawAnswerView({
    super.key,
    required this.questionStep,
    required this.result,
  });
  final QuestionStep questionStep;
  final HandDrawQuestionResult? result;

  @override
  State<HandDrawAnswerView> createState() => _HandDrawAnswerViewState();
}

class _HandDrawAnswerViewState extends State<HandDrawAnswerView> {
  late final HandDrawAnswerFormat _handDrawAnswerFormat;
  late final DateTime _startDate;

  bool _changed = false;
  bool _isValid = false;
  bool _canSign = false;
  FocusNode inputFocus = FocusNode();
  File? _resultFile;

  final _controller = HandSignatureControl();
  final TextEditingController _nameController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _handDrawAnswerFormat =
        widget.questionStep.answerFormat as HandDrawAnswerFormat;

    final savedResult = _handDrawAnswerFormat.savedResult;

    // Uses locally saved result if it exists
    if (widget.result != null && widget.result!.result != null) {
      _nameController.text = widget.result!.result!.name;

      _checkIfFileExists(widget.result!.result!.signatureImageUrl);
    }
    // Else, uses saved result if it exists
    else if (savedResult != null && savedResult.result != null) {
      _nameController.text = savedResult.result!.name;
      _checkIfFileExists(savedResult.result!.signatureImageUrl);
    }

    _checkValidation();

    _startDate = DateTime.now();

    Future.delayed(Duration.zero, () {
      inputFocus.requestFocus();
    });
  }

  void _checkIfFileExists(String path) {
    final File file = File(path);

    if (file.existsSync()) {
      _resultFile = file;
    } else {
      throw StateError('Provided file does not exists');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _checkValidation() {
    final RegExp nameRegex =
        RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ]{2,}(?:[-' ][A-Za-zÀ-ÖØ-öø-ÿ]+)*$");
    final bool nameHasMatch = nameRegex.hasMatch(_nameController.text);
    bool signFileExists = false;

    final file = _resultFile;
    if (file != null) {
      if (file.existsSync()) {
        signFileExists = true;
      }
    }

    setState(() {
      _changed = true;
      _canSign = nameHasMatch;
      _isValid = nameHasMatch && signFileExists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      resultFunction: () {
        // Uses saved result only if there is not a local result
        if (!_changed &&
            _handDrawAnswerFormat.savedResult != null &&
            widget.result == null) {
          return _handDrawAnswerFormat.savedResult!;
        }

        return HandDrawQuestionResult(
          id: widget.questionStep.stepIdentifier,
          startDate: _startDate,
          endDate: DateTime.now(),
          valueIdentifier: _nameController.text,
          result: HandDrawQuestionSignatureResult(
            name: _nameController.text,
            signatureImageUrl: _resultFile?.path ?? '',
          ),
        );
      },
      isValid: _isValid || widget.questionStep.isOptional,
      title: widget.questionStep.title.isNotEmpty
          ? Text(
              widget.questionStep.title,
              style: widget.questionStep.title.length > 270
                  ? Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 21)
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
              TextField(
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                focusNode: inputFocus,
                decoration: textFieldInputDecoration(
                  hint: 'Digite o seu nome.',
                ),
                controller: _nameController,
                textAlign: TextAlign.center,
                onChanged: (String text) {
                  _checkValidation();
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton.icon(
                onPressed: _canSign
                    ? () async {
                        await SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeRight,
                          DeviceOrientation.landscapeLeft,
                        ]);

                        Timer(
                          const Duration(milliseconds: 200),
                          () => showDialog<void>(
                            context: context,
                            useRootNavigator: false,
                            builder: (modalContext) => _signingModal(context),
                          ),
                        );
                      }
                    : null,
                label: Text(
                  'Clique aqui para ${_resultFile != null ? 'refazer a assinatura' : 'assinar na tela'}',
                ),
                icon: const Icon(Icons.draw),
              ),
              if (_resultFile != null)
                GestureDetector(
                  onTap: _previewImage,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.file(
                          File(_resultFile!.path),
                          width: 200,
                          height: 70,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Positioned(
                        top: -10,
                        right: 5,
                        child: IconButton(
                          onPressed: () {
                            _confirmDeleteImage(
                              context,
                              popAll: false,
                            );
                          },
                          icon: const DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signingModal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const double height = 50;

    return Material(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: const Color(0x99D2D5DA),
            height: height,
            child: Row(
              children: [
                SizedBox(
                  height: height,
                  child: TextButton.icon(
                    onPressed: () {
                      _closeModal(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    label: const Text(
                      'Voltar',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(
                  height: height,
                  child: TextButton.icon(
                    onPressed: _controller.clear,
                    icon: const Icon(Icons.close),
                    label: const Text(
                      'Limpar',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(
                  height: height,
                  child: TextButton.icon(
                    onPressed: () {
                      _validateSigning(context);
                    },
                    icon: const Icon(
                      Icons.check,
                    ),
                    label: const Text(
                      'Validar',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _nameController.text,
                ),
                const SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              width: size.width > size.height ? size.width : size.height,
              child: HandSignature(
                control: _controller,
                width: 2,
                maxWidth: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _validateSigning(BuildContext context) async {
    if (_controller.paths.isNotEmpty) {
      final stream = await _controller.toImage(
        background: Colors.white,
      );

      if (stream != null) {
        final appDir = await getApplicationDocumentsDirectory();

        final newDir = await Directory(
          '${appDir.path}/survey-kit',
        ).create(recursive: true);

        final filePath = '${newDir.path}/${const Uuid().v4()}.jpg';

        // Write the image data to the file
        final file = File(filePath);
        await file.writeAsBytes(stream.buffer.asUint8List());

        setState(() {
          _resultFile = file;
        });

        _checkValidation();

        if (_isValid) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('A assinatura é válida.'),
              ),
            );
            await _closeModal(context);
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, faça a sua assinatura antes de enviar.'),
        ),
      );
    }
  }

  Future<void> _closeModal(BuildContext context) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void _previewImage() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(backgroundColor: Colors.black),
          body: Stack(
            children: [
              Center(
                child: PhotoView(
                  imageProvider: FileImage(File(_resultFile!.path)),
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 32,
                  ),
                  onPressed: () => _confirmDeleteImage(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteImage(
    BuildContext context, {
    bool popAll = true,
  }) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Tem certeza que deseja excluir esta imagem?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _changed = true;
                  _resultFile = null;
                  _isValid = false;
                });
                Navigator.of(dialogContext).pop();
                if (popAll) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Deletar', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
