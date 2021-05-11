import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final int maxLines;

  ExpandableText(this.text, {this.style, this.textAlign, this.maxLines = 1});

  @override
  State<StatefulWidget> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool expanded = false;

  void _toggleExpanded() {
    setState(() {
      expanded = !expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleExpanded,
      child: Text(
        widget.text ?? "",
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: expanded ? null : widget.maxLines,
        overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
      ),
    );
  }
}
