part of test_utils;

class RichTextFinder {
  Finder matching(String text) {
    return find.byWidgetPredicate((Widget widget) =>
        widget is RichText && widget.text.toPlainText() == text);
  }

  Finder ending(String text) {
    return find.byWidgetPredicate((Widget widget) =>
        widget is RichText && widget.text.toPlainText().endsWith(text));
  }
}
