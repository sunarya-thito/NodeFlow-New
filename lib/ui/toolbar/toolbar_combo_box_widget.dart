import 'package:flutter/material.dart';
import 'package:nodeflow/ui/compact_data.dart';
import 'package:nodeflow/ui/toolbar/toolbar.dart';
import 'package:nodeflow/ui/toolbar/toolbar_viewport.dart';
import 'package:nodeflow/ui/tooltip/tooltip_wrapper.dart';

class ToolbarComboBoxWidget extends StatefulWidget {
  final ToolbarComboBox comboBox;
  const ToolbarComboBoxWidget({Key? key, required this.comboBox})
      : super(key: key);

  @override
  _ToolbarComboBoxWidgetState createState() => _ToolbarComboBoxWidgetState();
}

class _ToolbarComboBoxWidgetState extends State<ToolbarComboBoxWidget> {
  @override
  Widget build(BuildContext context) {
    var currentValue = widget.comboBox.currentValue;
    Widget container = Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: () {
          if (widget.comboBox.items.isNotEmpty) {
            var globalOffset = Offset.zero;
            if (context.findRenderObject() is RenderBox) {
              globalOffset = (context.findRenderObject() as RenderBox)
                  .localToGlobal(Offset(
                      4, // 4 because of the padding
                      (context.findRenderObject() as RenderBox).size.height));
            }
            ToolbarData.of(context)
                .controller
                .open(widget.comboBox, globalOffset);
          }
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: app().dividerColor, width: 1)),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
              children: currentValue == null
                  ? [
                      DefaultTextStyle(
                        style: TextStyle(
                          color: app().secondaryTextColor,
                          fontSize: 12,
                        ),
                        child: widget.comboBox.placeholder.asTextWidget(),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down,
                        color: widget.comboBox.items.isEmpty
                            ? app().secondaryTextColor
                            : app().primaryTextColor,
                        size: 16,
                      ),
                    ]
                  : [
                      if (currentValue.icon != null)
                        IconTheme(
                          data: IconThemeData(
                            size: 14,
                            color: app().primaryTextColor,
                          ),
                          child: currentValue.icon!,
                        ),
                      const SizedBox(width: 4),
                      DefaultTextStyle(
                        style: TextStyle(
                          color: app().primaryTextColor,
                          fontSize: 12,
                        ),
                        child: currentValue.label.asTextWidget(),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down,
                        color: app().primaryTextColor,
                        size: 12,
                      ),
                    ]),
        ),
      ),
    );
    if (widget.comboBox.tooltip != null) {
      container = TooltipWrapper(
        tooltip: TooltipWrapper.actionTooltip(
            widget.comboBox.tooltip!,
            widget.comboBox.tooltipDescription,
            widget.comboBox.tooltipIcon,
            null),
        child: container,
      );
    }
    return container;
  }
}

class ToolbarComboBoxPopup extends StatefulWidget {
  final Offset globalPosition;
  final ToolbarComboBox comboBox;
  const ToolbarComboBoxPopup(
      {Key? key, required this.comboBox, required this.globalPosition})
      : super(key: key);

  @override
  _ToolbarComboBoxPopupState createState() => _ToolbarComboBoxPopupState();
}

class _ToolbarComboBoxPopupState extends State<ToolbarComboBoxPopup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: app().surfaceColor,
        border: Border.all(color: app().dividerColor, width: 1),
      ),
      child: IntrinsicWidth(
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (widget.comboBox.header != null) widget.comboBox.header!(context),
          for (int i = 0; i < widget.comboBox.items.length; i++)
            ToolbarComboBoxPopupItem(
                item: widget.comboBox.items[i],
                onTap: () {
                  widget.comboBox.onChangeSelected(i);
                  ToolbarData.of(context).controller.closeOverlay();
                }),
        ]),
      ),
    );
  }
}

class ToolbarComboBoxPopupItem extends StatefulWidget {
  final ToolbarComboBoxItem item;
  final void Function() onTap;
  const ToolbarComboBoxPopupItem(
      {Key? key, required this.item, required this.onTap})
      : super(key: key);

  @override
  _ToolbarComboBoxPopupItemState createState() =>
      _ToolbarComboBoxPopupItemState();
}

class _ToolbarComboBoxPopupItemState extends State<ToolbarComboBoxPopupItem> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _hovered ? app().focusedSurfaceColor : null,
          ),
          child: Row(
            children: [
              if (widget.item.icon != null)
                IconTheme(
                  data: IconThemeData(
                    size: 14,
                    color: app().primaryTextColor,
                  ),
                  child: widget.item.icon!,
                ),
              if (widget.item.icon == null) const SizedBox(width: 14),
              const SizedBox(width: 4),
              DefaultTextStyle(
                style: TextStyle(
                  color: app().primaryTextColor,
                  fontSize: 12,
                ),
                child: widget.item.label.asTextWidget(),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
