// lib/core/widgets/forms/app_text_field.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../theme/app_theme.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? controller;
  final bool? enabled;
  final String? labelText;
  final String? label;
  final String? initialValue;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? prefixText;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Function(String)? onChanged;
  final Function()? onTap;
  final TextStyle? style;
  final bool obscureText;
  final bool isEmail;
  final bool isNumber;
  final bool isDatePicker;
  final bool filled;
  final Function(String)? onFieldSubmitted;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool rounded;

  const AppTextField({
    super.key,
    this.controller,
    this.enabled,
    this.labelText,
    this.label,
    this.initialValue,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.prefixText,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.onTap,
    this.style,
    this.obscureText = false,
    this.isEmail = false,
    this.isNumber = false,
    this.isDatePicker = false,
    this.filled = false,
    this.onFieldSubmitted,
    this.minLines,
    this.maxLines,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.rounded = false,
  });

  @override
  State<StatefulWidget> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final borderRadius = BorderRadius.circular(
      widget.rounded ? AppTheme.radiusXL : AppTheme.radiusM,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: _controller,
        enabled: widget.enabled ?? true,
        style: widget.style ?? theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: widget.filled 
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
              : colorScheme.surface,
          labelText: widget.labelText ?? widget.label,
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
          hintText: widget.hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          helperText: widget.helperText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon != null
              ? Container(
                  margin: const EdgeInsets.only(
                    left: AppTheme.spacingM,
                    right: AppTheme.spacingS,
                  ),
                  child: Icon(
                    widget.prefixIcon,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    size: 20,
                  ),
                )
              : widget.prefixText,
          suffixIcon: widget.obscureText
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: AppTheme.spacingM,
                    ),
                    child: Icon(
                      _obscureText
                          ? Iconsax.eye_slash_copy
                          : Iconsax.eye_copy,
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: colorScheme.primary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: colorScheme.error,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
             horizontal: AppTheme.spacingL,
             vertical: AppTheme.spacingM,
           ),
         ),
         obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
      keyboardType:
          widget.keyboardType ??
          (widget.isEmail
              ? TextInputType.emailAddress
              : widget.isNumber
              ? TextInputType.number
              : TextInputType.text),
      enableInteractiveSelection: !widget.isDatePicker,
      onTap: widget.isDatePicker
          ? () async {
              // Ensure the keyboard is dismissed
              FocusScope.of(context).requestFocus(FocusNode());

              DateTime? date = await showDatePicker(
                context: context,
                initialDate: _controller.text.isNotEmpty
                    ? DateFormat(dateFormat).parse(_controller.text)
                    : DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );

              if (date != null) {
                _controller.text = DateFormat(dateFormat).format(date);
              }
            }
          : widget.onTap,
      onFieldSubmitted: widget.onFieldSubmitted,
      textInputAction: widget.textInputAction,
      minLines: widget.minLines,
      maxLines: widget.maxLines ?? 1,
      ),
    );
  }
}

String dateFormat = "dd/MM/yyyy";

bool isValidEmail(String email) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(email.replaceAll(' ', ''));
}

bool isValidPassword(String password) {
  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(password);
}
