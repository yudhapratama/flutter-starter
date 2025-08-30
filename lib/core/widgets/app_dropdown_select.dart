// lib/core/widgets/forms/app_dropdown_select.dart
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../models/select_model.dart';
import '../theme/app_theme.dart';

class AppDropdownSelect extends StatelessWidget {
  const AppDropdownSelect({
    super.key,
    this.label,
    required this.items,
    this.isDisabled = false,
    this.isLoading = false,
    this.onChanged,
    this.selectedItem,
    this.mode,
    this.showSearchBox = true,
    this.maxHeight = 600,
  });

  final String? label;
  final List<SelectModel> items;
  final bool isDisabled;
  final bool isLoading;
  final ValueChanged<SelectModel?>? onChanged;
  final SelectModel? selectedItem;
  final Mode? mode;
  final bool showSearchBox;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDisabledOrLoading = isDisabled || isLoading || items.isEmpty;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownSearch<SelectModel>(
        items: (f, i) => items,
        compareFn: (item, selected) => item.id == selected.id,
        itemAsString: (item) => item.title.toString(),
        selectedItem: isDisabledOrLoading ? null : selectedItem,
        onChanged: isDisabledOrLoading ? null : onChanged,
        enabled: !isDisabledOrLoading,
        validator: (v) => v == null ? "Please select $label" : null,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingL,
              vertical: AppTheme.spacingM,
            ),
          ),
        ),
        popupProps: PopupProps.modalBottomSheet(
          title: Container(
            padding: const EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppTheme.radiusL),
                topRight: Radius.circular(AppTheme.radiusL),
              ),
            ),
            child: Text(
              label ?? '',
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          showSearchBox: showSearchBox,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: colorScheme.onSurface,
              ),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingL,
                vertical: AppTheme.spacingM,
              ),
            ),
          ),
          constraints: BoxConstraints(maxHeight: maxHeight),
          fit: FlexFit.loose,
        ),
      ),
    );
  }
}
