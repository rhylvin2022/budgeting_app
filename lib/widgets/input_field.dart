import 'package:budgeting_app/blocs/localization/app_localization.dart';
import 'package:budgeting_app/global/app_colors.dart';
import 'package:budgeting_app/global/enums.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

///Updated and developed by: Rhylvin March 2023
class InputField extends StatefulWidget {
  final String inputTitle;
  final TextEditingController controller;
  final ValidationType validationType;
  final Widget? suffix;
  final Widget? prefix;
  final String? suffixText;
  final String? prefixText;
  final bool obscureText;
  final Function(String a) onSubmitComplete;
  final KeyBoardType inputType;
  final int minLines;
  final int maxLines;
  final bool editable;
  final Function(String) onChanged;
  int maxLength;
  int minLength;
  bool readOnly;
  final FocusNode? focusNode;
  bool onEditing;
  double horizontalPadding;
  final TextAlign align;
  final Function() onEditingComplete;
  final bool? dontValidate;
  final double? maxAmount;
  final double? minAmount;
  final bool? optional;
  final bool removeValidatorEntirely;
  final Color textColor;

  InputField({
    Key? key,
    required this.inputTitle,
    required this.controller,
    this.suffix,
    this.prefix,
    this.suffixText,
    this.prefixText,
    this.obscureText = false,
    this.editable = true,
    required this.onSubmitComplete,
    this.inputType = KeyBoardType.normal,
    this.minLines = 1,
    this.maxLines = 1,
    this.validationType = ValidationType.normal,
    required this.onChanged,
    this.maxLength = 50,
    this.minLength = 2,
    this.focusNode,
    this.onEditing = false,
    this.readOnly = false,
    this.horizontalPadding = 20,
    this.align = TextAlign.start,
    required this.onEditingComplete,
    this.dontValidate = false,
    this.maxAmount,
    this.minAmount = 1,
    this.optional = false,
    this.removeValidatorEntirely = false,
    this.textColor = AppColors.black,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  var errorText = '';

  var maskFormatter = MaskTextInputFormatter(
      mask: '####-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var dateFormatter = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPadding, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  widget.inputTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Satoshi-Medium',
                    color: AppColors.colorThemeText,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              textAlign: widget.align,
              focusNode: widget.focusNode,
              controller: widget.controller,
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: getKeyBoardType(widget.inputType),
              obscureText: widget.obscureText,
              enabled: widget.editable,
              style: TextStyle(
                color: widget.editable ? widget.textColor : Colors.grey,
                fontSize: 16,
                fontFamily: 'Satoshi-Regular',
              ),
              cursorColor: AppColors.primaryColor,
              onTap: () {},
              onEditingComplete: () {
                widget.focusNode?.unfocus();
                FocusScope.of(context).requestFocus(FocusNode());
                if (widget.onEditingComplete != null) {
                  widget.onEditingComplete();
                }
              },
              onChanged: (newValue) {
                if (widget.onChanged != null) {
                  widget.onChanged!(newValue);
                }
              },
              decoration: InputDecoration(
                suffixText: widget.suffixText,
                prefixText: widget.prefixText,
                suffixIcon: widget.suffix,
                prefixIcon: widget.prefix,
                prefixStyle: TextStyle(
                  color: AppColors.colorThemeText,
                  fontSize: 16,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: errorText.isEmpty
                        ? AppColors.primaryColor
                        : AppColors.red,
                  ),
                  borderRadius: BorderRadius.circular(13.0),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: errorText.isEmpty
                        ? AppColors.primaryColor
                        : AppColors.red,
                  ),
                  borderRadius: BorderRadius.circular(13.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: errorText.isEmpty
                        ? AppColors.primaryColor
                        : AppColors.red,
                  ),
                  borderRadius: BorderRadius.circular(13.0),
                ),
              ),
              inputFormatters: getFormatter(),
              validator: widget.removeValidatorEntirely
                  ? null
                  : widget.optional ?? false
                      ? (text) {
                          String _text = text ?? '';
                          if (_text.isNotEmpty) {
                            if (_text.trim().isEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!mounted) return;
                                setState(() {
                                  errorText = AppLocalizations.of(context)!
                                          .translate("incorrect_input") ??
                                      '';
                                });
                              });
                              return errorText;
                            }
                            if (widget.validationType == ValidationType.email) {
                              if (text == null || text.isEmpty) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (!mounted) return;
                                  setState(() {
                                    errorText = " ";
                                  });
                                });
                                return errorText;
                              } else if (validateEmail(text)) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (!mounted) return;
                                  setState(() {
                                    errorText = '';
                                  });
                                });
                                return null;
                              } else {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (!mounted) return;
                                  setState(() {
                                    errorText = AppLocalizations.of(context)!
                                            .translate(
                                                "incorrect_email_address") ??
                                        '';
                                  });
                                });
                                return errorText;
                              }
                            } else if (_text.length < widget.minLength ||
                                _text.length > widget.maxLength) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!mounted) return;
                                setState(() {
                                  errorText = AppLocalizations.of(context)!
                                          .translate("incorrect_input") ??
                                      '';
                                });
                              });

                              return errorText;
                            } else if (widget.validationType ==
                                ValidationType.number) {
                              if (text == null || text.isEmpty) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (!mounted) return;
                                  setState(() {
                                    errorText = " ";
                                  });
                                });
                                return errorText;
                              } else {
                                if (validateOnlyNumbers(text!)) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = '';
                                    });
                                  });
                                  return null;
                                } else {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = AppLocalizations.of(context)!
                                              .translate("incorrect_input") ??
                                          '';
                                    });
                                  });
                                  return errorText;
                                }
                              }
                            } else if (widget.validationType ==
                                ValidationType.normal) {
                              if (text == null || text.isEmpty) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (!mounted) return;
                                  setState(() {
                                    errorText = " ";
                                  });
                                });
                                return errorText;
                              } else {
                                if (validateAlphaNumeric(text!)) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = '';
                                    });
                                  });
                                  return null;
                                } else {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = AppLocalizations.of(context)!
                                              .translate("incorrect_input") ??
                                          '';
                                    });
                                  });
                                  return errorText;
                                }
                              }
                            } else {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!mounted) return;
                                setState(() {
                                  errorText = '';
                                });
                              });
                              return null;
                            }
                          } else {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!mounted) return;
                              setState(() {
                                errorText = '';
                              });
                            });
                            return null;
                          }
                          return null;
                        }
                      : widget.dontValidate ?? false
                          ? (text) {
                              String _text = text ?? '';
                              if (_text.length < widget.minLength ||
                                  _text.length > widget.maxLength) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (!mounted) return;
                                  setState(() {
                                    errorText = AppLocalizations.of(context)!
                                            .translate("incorrect_input") ??
                                        '';
                                  });
                                });
                                return errorText;
                              } else {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (!mounted) return;
                                  setState(() {
                                    errorText = '';
                                  });
                                });
                                return null;
                              }
                            }
                          : (text) {
                              if (widget.validationType ==
                                  ValidationType.email) {
                                if (text == null || text.isEmpty) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = " ";
                                    });
                                  });
                                  return errorText;
                                } else if (validateEmail(text)) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = '';
                                    });
                                  });
                                  return null;
                                } else {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = AppLocalizations.of(context)!
                                              .translate(
                                                  "incorrect_email_address") ??
                                          '';
                                    });
                                  });
                                  return errorText;
                                }
                              } else if (widget.validationType ==
                                  ValidationType.normal) {
                                if (text == null || text.isEmpty) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = " ";
                                    });
                                  });
                                  return errorText;
                                } else if (validateNormal(text)) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = '';
                                    });
                                  });
                                  return null;
                                } else {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = AppLocalizations.of(context)!
                                              .translate("incorrect_input") ??
                                          '';
                                    });
                                  });
                                  return errorText;
                                }
                              } else if (widget.validationType ==
                                  ValidationType.alphaNumeric) {
                                if (text == null || text.isEmpty) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = " ";
                                    });
                                  });
                                  return errorText;
                                } else {
                                  if (validateAlphaNumeric(text!)) {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (!mounted) return;
                                      setState(() {
                                        errorText = '';
                                      });
                                    });
                                    return null;
                                  } else {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) {
                                      if (!mounted) return;
                                      setState(() {
                                        errorText = AppLocalizations.of(
                                                    context)!
                                                .translate("incorrect_input") ??
                                            '';
                                      });
                                    });
                                    return errorText;
                                  }
                                }
                              } else if (widget.validationType ==
                                  ValidationType.number) {
                                if (text == null || text.isEmpty) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = " ";
                                    });
                                  });
                                  return errorText;
                                } else if (validateOnlyNumbers(text)) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = '';
                                    });
                                  });
                                  return null;
                                } else {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = AppLocalizations.of(context)!
                                              .translate("incorrect_input") ??
                                          '';
                                    });
                                  });
                                  return errorText;
                                }
                              } else if (widget.validationType ==
                                  ValidationType.amount) {
                                if (text == null || text.isEmpty) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = AppLocalizations.of(context)!
                                              .translate(
                                                  "amount_cannot_be_empty") ??
                                          '';
                                    });
                                  });
                                  return errorText;
                                } else if (validateAmount(text)) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = '';
                                    });
                                  });
                                  return null;
                                } else {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    if (!mounted) return;
                                    setState(() {
                                      errorText = AppLocalizations.of(context)!
                                              .translate("incorrect_amount") ??
                                          '';
                                    });
                                  });
                                  return errorText;
                                }
                              }
                              if (text == null ||
                                  text.isEmpty ||
                                  (text.length < 2)) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (!mounted) return;
                                  setState(() {
                                    errorText = AppLocalizations.of(context)!
                                            .translate("text_is_empty") ??
                                        '';
                                  });
                                });
                                return errorText;
                              }
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!mounted) {
                                  return;
                                }
                                setState(() {
                                  errorText = '';
                                });
                              });
                              return null;
                            },
            ),
          ],
        ),
      );

  bool validateOnlyNumbers(String value) {
    if (value.trim().isEmpty) return false;
    if (value.length < widget.minLength || value.length > widget.maxLength) {
      return false;
    }
    RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(value);
  }

  bool validateEmail(String value) {
    if (value.trim().isEmpty) return false;
    if (value.length < widget.minLength || value.length > widget.maxLength) {
      return false;
    }
    RegExp regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
    return (!regex.hasMatch(value)) ? false : true;
  }

  bool validateNormal(String text) {
    // RegExp regex = RegExp(r"^[0-9a-zA-ZÑñ].*");
    RegExp regex = RegExp(r".*");

    if (text.trim().isEmpty) return false;
    if (text.length < widget.minLength || text.length > widget.maxLength) {
      return false;
    }
    return (!regex.hasMatch(text)) ? false : true;
  }

  bool validateAlphaNumeric(String text) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9Ññ ]+$');

    if (text.trim().isEmpty) return false;
    if (text.length < widget.minLength || text.length > widget.maxLength) {
      return false;
    }
    return (!regex.hasMatch(text)) ? false : true;
  }

  bool validateAmount(String text) {
    double minAmount = widget.minAmount ?? 1;
    if (text.length < widget.minLength || text.length > widget.maxLength) {
      return false;
    }
    try {
      if (!(minAmount <= double.parse(text.replaceAll(',', '')))) {
        return false;
      }
      RegExp regex = RegExp(r'^\$?(\d{1,3}(,\d{3})*|(\d+))(\.\d{2})?$');

      return (!regex.hasMatch(text)) ? false : true;
    } catch (e) {
      return false;
    }
  }

  getKeyBoardType(KeyBoardType keyboardType) {
    TextInputType textInputType = TextInputType.text;
    switch (keyboardType) {
      case KeyBoardType.number:
        textInputType =
            const TextInputType.numberWithOptions(signed: true, decimal: true);
        break;
      case KeyBoardType.normal:
        textInputType = TextInputType.text;
        break;
      case KeyBoardType.email:
        textInputType = TextInputType.emailAddress;
        break;
    }
    return textInputType;
  }

  getFormatter() {
    if (widget.validationType == ValidationType.amount) {
      return [
        BacktickBlockerFormatter(),
        CurrencyTextInputFormatter.currency(
          decimalDigits: 2,
          symbol: " ",
        )
      ];
    }
  }
}

class BacktickBlockerFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Block the backtick (`) character
    if (newValue.text.contains('`')) {
      // Do not allow the backtick character, keep the old value
      return oldValue;
    }
    // Allow other characters
    return newValue;
  }
}
