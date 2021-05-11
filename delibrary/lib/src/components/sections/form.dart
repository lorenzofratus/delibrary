import 'package:delibrary/src/components/sections/container.dart';
import 'package:delibrary/src/model/utils/field-data.dart';
import 'package:flutter/material.dart';

import '../utils/button.dart';
import '../form-fields/editable-field.dart';

class FormSectionContainer extends SectionContainer {
  FormSectionContainer({
    String title = "",
    @required Key formKey,
    bool editing = false,
    void Function() startEditing,
    void Function() saveEditing,
    void Function() cancelEditing,
    @required List<FieldData> fields,
  })  : assert((startEditing != null) ^ (saveEditing == null)),
        super(
          title: title,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  if (fields != null)
                    for (FieldData data in fields)
                      EditableFormField(
                        text: data.text,
                        label: data.label,
                        validator: data.validator,
                        editing: data.validator != null ? editing : false,
                        obscurable: data.obscurable,
                      ),
                  if (startEditing != null)
                    editing
                        ? DelibraryButton(text: "Salva", onPressed: saveEditing)
                        : DelibraryButton(
                            text: "Modifica", onPressed: startEditing),
                  if (cancelEditing != null)
                    AnimatedContainer(
                      height: editing ? 80.0 : 0.0,
                      child: DelibraryButton(
                        text: "Annulla",
                        onPressed: editing ? cancelEditing : null,
                        primary: false,
                      ),
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn,
                    ),
                ],
              ),
            ),
          ],
        );
}
