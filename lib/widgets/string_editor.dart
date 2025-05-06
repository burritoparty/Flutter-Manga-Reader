import 'package:flutter/material.dart';

// widget for editing entries for given
class StringEditor extends StatefulWidget {
  final String name;
  // text controller
  final TextEditingController controller;
  // submit callback
  final ValueChanged<String> onSubmitted;

  const StringEditor({
    Key? key,
    required this.name,
    required this.controller,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  State<StringEditor> createState() => _StringEditorsState();
}

class _StringEditorsState extends State<StringEditor> {
  // was last action a submit
  bool _submitted = false;
  // is text changed
  bool _dirty = false;
  // last saved text
  late String _lastSubmittedText;
  // focus node for field
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _lastSubmittedText = widget.controller.text;
    // watch text changes
    widget.controller.addListener(_onTextChanged);
    _focusNode = FocusNode();
    // update on focus change
    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // stop watching text
    widget.controller.removeListener(_onTextChanged);
    _focusNode.dispose();
    super.dispose();
  }

  // handle text update
  void _onTextChanged() {
    final current = widget.controller.text;
    final bool isDirty = current != _lastSubmittedText;
    if (isDirty != _dirty || _submitted) {
      setState(() {
        _dirty = isDirty;
        _submitted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;
    // choose border color
    final Color borderColor = _dirty
        ? Colors.redAccent
        : (_submitted ? Colors.greenAccent : Colors.grey);
    // choose focus color
    final Color focusColor = _dirty
        ? Colors.redAccent
        : (_submitted
            ? Colors.greenAccent
            : Theme.of(context).colorScheme.primary);

    return TextField(
      focusNode: _focusNode,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.name,
        labelStyle: TextStyle(
          color: isFocused ? focusColor : Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: focusColor),
        ),
      ),
      // update dirty state on change
      onChanged: (value) => _onTextChanged(),
      onSubmitted: (value) {
        // mark as submitted
        setState(() {
          _submitted = true;
          _lastSubmittedText = value;
          _dirty = false;
        });
        widget.onSubmitted(value);
        _focusNode.unfocus();
      },
    );
  }
}

