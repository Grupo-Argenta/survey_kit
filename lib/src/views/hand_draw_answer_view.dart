import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hand_signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:survey_kit/survey_kit.dart';

class HandDrawAnswerView extends StatefulWidget {
  final QuestionStep questionStep;
  final HandDrawQuestionResult? result;

  const HandDrawAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  _HandDrawAnswerViewState createState() => _HandDrawAnswerViewState();
}

class _HandDrawAnswerViewState extends State<HandDrawAnswerView> {
  late final HandDrawAnswerFormat _handDrawAnswerFormat;
  late final DateTime _startDate;

  bool _changed = false;
  bool _isValid = false;
  bool _canSign = false;
  FocusNode inputFocus = FocusNode();
  File? _resultFile;

  final _controller = HandSignatureControl(
    threshold: 3.0,
    smoothRatio: 0.65,
    velocityRange: 2.0,
  );
  final TextEditingController _nameController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _handDrawAnswerFormat =
        widget.questionStep.answerFormat as HandDrawAnswerFormat;

    if (widget.result != null && widget.result!.result != null) {
      _nameController.text = widget.result!.result!.name;
    }

    final savedResult = _handDrawAnswerFormat.savedResult;
    if (savedResult != null && savedResult.result != null) {
      File file = File(savedResult.result!.signatureImageUrl!);

      if (file.existsSync()) {
        this._resultFile = file;
      } else {
        throw StateError('Provided file does not exists');
      }

      _nameController.text = savedResult.result!.name;
    }

    _checkValidation();

    _startDate = DateTime.now();

    Future.delayed(Duration(seconds: 0), () {
      inputFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _checkValidation() async {
    RegExp nameRegex =
        new RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ]{2,}(?:[-' ][A-Za-zÀ-ÖØ-öø-ÿ]+)*$");
    bool nameHasMatch = nameRegex.hasMatch(_nameController.text);
    bool signFileExists = false;

    final file = _resultFile;
    if (file != null) {
      if (await file.exists()) {
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
        if (!_changed && _handDrawAnswerFormat.savedResult != null) {
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
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: Container(
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
                          Duration(milliseconds: 200),
                          () async => await showDialog(
                            context: context,
                            useRootNavigator: false,
                            builder: (modalContext) => _signingModal(context),
                          ),
                        );
                      }
                    : null,
                label: Text(
                    'Clique aqui para ${_resultFile != null ? 'refazer a assinatura' : 'assinar na tela'}'),
                icon: Icon(Icons.draw),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _signingModal(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double height = 50;

    return Material(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            color: Color(0x99D2D5DA),
            height: height,
            child: Row(
              children: [
                SizedBox(
                  height: height,
                  child: TextButton.icon(
                    onPressed: () {
                      _closeModal(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                    label: Text(
                      'Voltar',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                SizedBox(
                  height: height,
                  child: TextButton.icon(
                    onPressed: _controller.clear,
                    icon: Icon(Icons.close),
                    label: Text(
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
                    icon: Icon(
                      Icons.check,
                    ),
                    label: Text(
                      'Validar',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  _nameController.text,
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: size.width > size.height ? size.width : size.height,
              child: HandSignature(
                control: _controller,
                color: Colors.black,
                width: 2.0,
                maxWidth: 8.0,
                type: SignatureDrawType.shape,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _validateSigning(BuildContext context) async {
    if (_controller.paths.isNotEmpty) {
      final stream2 = await _controller.toImage(
        background: Colors.white,
      );

      if (stream2 != null) {
        final directory = await getTemporaryDirectory();

        // Create a unique file name
        final imagePath =
            '${directory.path}/saved_image_${DateTime.now().millisecondsSinceEpoch}.png';

        // Write the image data to the file
        final file = File(imagePath);
        await file.writeAsBytes(stream2.buffer.asUint8List());

        setState(() {
          _resultFile = file;
        });

        await _checkValidation();

        if (_isValid) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("A assinatura é válida."),
            ),
          );
          _closeModal(context);
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, faça a sua assinatura antes de enviar."),
        ),
      );
    }
  }

  Future<void> _closeModal(BuildContext context) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    Navigator.pop(context);
  }
}
