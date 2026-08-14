part of shared_features;

class CodeValidationInput extends StatefulWidget {
  final int digits;
  final CodeValidationStore store;

  CodeValidationInput({
    Key? key,
    required this.digits,
    required this.store,
  }) : super(key: key);

  @override
  CodeValidationInputState createState() => CodeValidationInputState();
}

class CodeValidationInputState extends State<CodeValidationInput> {
  final _formKey = GlobalKey<FormState>();
  var _focused = false;

  late int _digits;
  late List<FocusNode> _nodes;

  late List<TextEditingController> _controllers;

  String? autoFillCode;
  String? previousValue = "";
  String? appSignature;

  @override
  void initState() {
    super.initState();
    _digits = widget.digits;
    _nodes = List<FocusNode>.generate(_digits, (_) => FocusNode());
    _controllers = List<TextEditingController>.generate(
      _digits,
      (index) {
        return TextEditingController(
          text: widget.store.code != null && 
                widget.store.code!.length > index
              ? widget.store.code![index]
              : "",
        );
      },
    );
    _nodes.forEach((element) {
      element.addListener(_onFocusChange);
    });
    SmsAutoFill().getAppSignature.then((signature) {
      appSignature = signature;
    });
  }

  void _onFocusChange() {
    var index = _nodes.indexWhere((element) => element.hasFocus);
    if (index >= 0 && _controllers.length > index)
      _controllers[index].selection = TextSelection(
          baseOffset: 0, extentOffset: _controllers[index].value.text.length);
  }

  @override
  Widget build(BuildContext context) {
    if (!_focused) {
      FocusScope.of(context).requestFocus(_nodes.first);
      _focused = true;
    }

    return Form(key: _formKey, child: _buildTokenAutoFill());
  }

  Widget _buildTokenAutoFill() {
    return Container(
      width: 200,
      height: 200,
      child: PinFieldAutoFill(
        decoration: BoxLooseDecoration(
          textStyle: TextStyle(fontSize: 20, color: Colors.black),
          strokeColorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
        ),
        currentCode: autoFillCode, // prefill with a code
        autoFocus: true,
        onCodeChanged: (value) async {
          //Verify if value came from autoFill
          _validateToken(value);
        }, //code changed callback
        codeLength: _digits, //code length, default 6
      ),
    );
  }

  var x = 0;
  void _validateToken(String? value) {
    if (value?.length == widget.digits) {
      autoFillCode = value;
      next();
    } else {
      previousValue = value;
      autoFillCode = value;
      if (autoFillCode?.length == widget.digits) {
        next();
      }
    }
  }

  void next() async {
    FocusScope.of(context).unfocus();
    String code = autoFillCode ?? "";
    if (code.length == widget.digits) {
      widget.store.code = code;
      await widget.store.validate();
    }
  }
}
