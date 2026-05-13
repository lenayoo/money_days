import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class SwipeActionTransactionCard extends StatefulWidget {
  const SwipeActionTransactionCard({
    super.key,
    required this.child,
    required this.actionKeyPrefix,
    required this.editLabel,
    required this.deleteLabel,
    required this.onEdit,
    required this.onDelete,
  });

  final Widget child;
  final String actionKeyPrefix;
  final String editLabel;
  final String deleteLabel;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  State<SwipeActionTransactionCard> createState() =>
      _SwipeActionTransactionCardState();
}

class _SwipeActionTransactionCardState
    extends State<SwipeActionTransactionCard> {
  static const _actionWidth = 82.0;
  static const _maxOffset = _actionWidth * 2;

  double _offset = 0;
  bool _isDragging = false;

  void _close() {
    setState(() {
      _offset = 0;
      _isDragging = false;
    });
  }

  void _handleHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _isDragging = true;
      _offset = (_offset + details.delta.dx).clamp(-_maxOffset, 0.0);
    });
  }

  void _handleHorizontalDragEnd(DragEndDetails details) {
    final shouldOpen =
        details.primaryVelocity != null
            ? details.primaryVelocity! < -120
            : _offset.abs() > _maxOffset * 0.42;

    setState(() {
      _isDragging = false;
      _offset = shouldOpen ? -_maxOffset : 0;
    });
  }

  void _handleEdit() {
    _close();
    widget.onEdit();
  }

  void _handleDelete() {
    _close();
    widget.onDelete();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              ignoring: _offset == 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: _actionWidth,
                      child: _SwipeActionButton(
                        key: ValueKey('${widget.actionKeyPrefix}-edit-action'),
                        label: widget.editLabel,
                        icon: Icons.edit_outlined,
                        color: AppColors.accentStrong,
                        backgroundColor: AppColors.surfaceAccent,
                        onTap: _handleEdit,
                      ),
                    ),
                    SizedBox(
                      width: _actionWidth,
                      child: _SwipeActionButton(
                        key: ValueKey(
                          '${widget.actionKeyPrefix}-delete-action',
                        ),
                        label: widget.deleteLabel,
                        icon: Icons.delete_outline_rounded,
                        color: AppColors.expense,
                        backgroundColor: AppColors.expenseSoft,
                        onTap: _handleDelete,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(end: _offset),
            duration:
                _isDragging ? Duration.zero : const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(value, 0),
                child: child,
              );
            },
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _offset == 0 ? null : _close,
              onHorizontalDragUpdate: _handleHorizontalDragUpdate,
              onHorizontalDragEnd: _handleHorizontalDragEnd,
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeActionButton extends StatelessWidget {
  const _SwipeActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
