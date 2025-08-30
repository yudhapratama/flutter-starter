import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A custom button widget that supports various styles,
/// loading states, and icon alignments.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.label,
    this.onPressed,
    this.color,
    this.textColor,
    this.width,
    this.icon,
    this.iconAlignment = MainAxisAlignment.center,
    this.elevation,
    this.isOutlined = false,
    this.loading = false,
    this.isDisabled = false,
    this.expanded = false,
    this.rounded = false,
  });

  /// The text label for the button.
  final String? label;

  /// The callback to be executed when the button is pressed.
  final VoidCallback? onPressed;

  /// The background color of the button.
  /// Defaults to `Theme.of(context).colorScheme.primary`.
  final Color? color;

  /// The text and icon color of the button.
  final Color? textColor;

  /// The width of the button. Defaults to full width.
  final double? width;

  /// An optional icon to display in the button.
  final Widget? icon;

  /// The alignment of the icon relative to the label.
  final MainAxisAlignment iconAlignment;

  /// The elevation of the button. Ignored if `isOutlined` is true.
  final double? elevation;

  /// If true, the button will have an outlined style.
  final bool isOutlined;

  /// If true, a loading indicator is shown and the button is disabled.
  final bool loading;

  /// If true, the button is disabled.
  final bool isDisabled;

  /// If true, the button will expand to fill the available horizontal space.
  final bool expanded;

  /// If true, the button will have a rounded pill shape.
  /// If false, it will have a rectangular shape.
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final effectiveOnPressed = (isDisabled || loading) ? null : onPressed;
    final defaultColor = colorScheme.primary;

    final buttonContent = loading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              color: isOutlined ? defaultColor : Colors.white,
            ),
          )
        : Row(
            mainAxisAlignment: iconAlignment,
            mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
            children: [
              if (icon != null && iconAlignment == MainAxisAlignment.start) ...[
                icon!,
                const SizedBox(width: AppTheme.spacingS),
              ],
              if (label != null)
                Text(
                  label!,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: textColor ?? (isOutlined ? defaultColor : colorScheme.onPrimary),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (icon != null && iconAlignment == MainAxisAlignment.end) ...[
                const SizedBox(width: AppTheme.spacingS),
                icon!,
              ],
            ],
          );

    if (isOutlined) {
      return SizedBox(
        width: width,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? defaultColor,
            side: BorderSide(
              color: textColor ?? defaultColor,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                rounded ? AppTheme.radiusXL : AppTheme.radiusM,
              ),
            ),
            elevation: 0,
            minimumSize: Size(
              width ?? (expanded ? double.infinity : 0),
              52.0,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingL,
              vertical: AppTheme.spacingM,
            ),
          ),
          onPressed: effectiveOnPressed,
          child: buttonContent,
        ),
      );
    }

    // Primary button with gradient and shadow
    return SizedBox(
      width: width,
      child: Container(
        height: 52.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color ?? defaultColor,
              (color ?? defaultColor).withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(
            rounded ? AppTheme.radiusXL : AppTheme.radiusM,
          ),
          boxShadow: [
            BoxShadow(
              color: (color ?? defaultColor).withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: effectiveOnPressed,
            borderRadius: BorderRadius.circular(
              rounded ? AppTheme.radiusXL : AppTheme.radiusM,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingL,
                vertical: AppTheme.spacingM,
              ),
              child: Center(child: buttonContent),
            ),
          ),
        ),
      ),
    );
  }
}
