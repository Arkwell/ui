//Copyright (C) 2012 Potix Corporation. All Rights Reserved.
//History: Sat, Oct 27, 2012 11:14:11 AM
// Author: tomyeh
part of rikulo_view;

/**
 * A radio button. The radio buttons are grouped by [name].
 * If one of the radio buttons is checked, all others in the same group will
 * be unchecked.
 */
class RadioButton extends CheckBox {
  /** Instantaites with a plain text.
   * The text will be encoded to make sure it is valid HTML text.
   */
  RadioButton([String text, bool value]): super(text, value);
  /** Instantiates with a HTML fragment.
   *
   * + [html] specifies a HTML fragment.
   * Notie it must be a valid HTML fragment. Otherwise, the result is
   * unpreditable.
   */
  RadioButton.fromHTML(String html, [bool value]): super.fromHTML(html, value);

  //@override
  String get type => "radio";
}