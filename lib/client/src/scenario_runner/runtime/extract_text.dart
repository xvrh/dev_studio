import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart' show MatchFinder;
import '../../../../src/utils/color.dart';
import '../protocol/models.dart';

TextInfo textInfoFromElement(
  String translationKey,
  Element element, {
  required String rawTranslation,
  required double pixelRatio,
}) {
  var box = element.renderObject! as RenderBox;
  var topLeft = box.localToGlobal(Offset.zero);
  var bottomRight = box.localToGlobal(box.size.bottomRight(Offset.zero));

  var style = styleFromElement(element);

  var text = textFromElement(element)!;

  return TextInfo(
    text: text,
    translationKey: translationKey,
    rawTranslation: rawTranslation,
    globalRectangle: Rectangle.fromLTRB(
      topLeft.dx * pixelRatio,
      topLeft.dy * pixelRatio,
      bottomRight.dx * pixelRatio,
      bottomRight.dy * pixelRatio,
    ),
  ).rebuild(
    (b) => b
      ..color = style.color != null ? colorToInt(style.color!) : null
      ..fontSize = style.fontSize
      ..fontFamily = style.fontFamily
      ..fontWeight = style.fontWeight?.index,
  );
}

String? textFromElement(Element candidate) {
  final widget = candidate.widget;
  if (widget is Text) {
    var data = widget.data;
    if (data != null) {
      return data;
    } else {
      return widget.textSpan!.toPlainText();
    }
  } else if (widget is RichText) {
    return widget.text.toPlainText();
  } else if (widget is EditableText) {
    return widget.controller.text;
  } else if (widget is MarkdownBody) {
    return widget.data;
  } else if (widget is Markdown) {
    return widget.data;
  }

  return null;
}

TextStyle styleFromElement(Element candidate) {
  final widget = candidate.widget;
  TextStyle? style;

  if (widget is Text) {
    style = widget.style;
  } else if (widget is EditableText) {
    style = widget.style;
  } else if (widget is RichText) {
    style = widget.text.style;
  }
  var defaultStyle = DefaultTextStyle.of(candidate).style;
  if (style != null) {
    return defaultStyle.merge(style);
  }

  return defaultStyle;
}

class TextFinder extends MatchFinder {
  TextFinder(this.text, {super.skipOffstage});

  final String text;

  @override
  String get description => 'text "$text"';

  @override
  bool matches(Element candidate) {
    var found = textFromElement(candidate);
    return found == text;
  }
}
