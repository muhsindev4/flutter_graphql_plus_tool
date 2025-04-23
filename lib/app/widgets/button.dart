
import 'package:flutter/material.dart';
import 'package:get/get.dart';


enum ButtonState { idle, loading }

class Button extends StatefulWidget {
  final String text;
  final double? elevation;
  final TextStyle? style;
  final Color? color;
  final Color fontColor;
  final bool disabled;
  final Widget? icon;
  final Widget? startIcon;
  final BorderSide? border;
  final EdgeInsetsGeometry? padding;
  final Function(
    Function startLoading,
    Function stopLoading,
    ButtonState btnState,
  )? onTap;

  const Button({
    super.key,
    required this.text,
    this.padding,
    this.elevation,
    this.style,
    this.color,
    this.startIcon,
    this.fontColor = Colors.white,
    this.disabled = false,
    this.icon,
    this.onTap,
    this.border,
  });

  @override
  _AnimatedLoadingButtonState createState() => _AnimatedLoadingButtonState();
}

class _AnimatedLoadingButtonState extends State<Button>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  ButtonState _currentState = ButtonState.idle;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);
  }

  void startLoading() {
    setState(() => _currentState = ButtonState.loading);
    _animationController.forward();
  }

  void stopLoading() {
    _animationController.reverse().then((_) {
      setState(() => _currentState = ButtonState.idle);
    });
  }

  void _handleTap() {
    if (widget.onTap != null && !widget.disabled) {
      widget.onTap!(startLoading, stopLoading, _currentState);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.red,
        overlayColor: Colors.green,
        surfaceTintColor: context.theme.primaryColor,
        elevation: widget.elevation ?? 5,
        backgroundColor: widget.disabled
            ? Colors.grey
            : widget.color ?? context.theme.primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: widget.border ?? BorderSide.none),
      ),
      onPressed: widget.disabled || _currentState == ButtonState.loading
          ? null
          : _handleTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return _currentState == ButtonState.loading
              ? Padding(
                  padding: widget.padding ??
                      const EdgeInsets.symmetric(vertical: 15),
                  child: const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : child!;
        },
        child: Padding(
          padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.startIcon != null) ...[
                widget.startIcon!,
                if (widget.text.isNotEmpty) const SizedBox(width: 8),
              ],
              if (widget.text.isNotEmpty)
                Text(
                  widget.text,
                  style: widget.style ??
                      context.textTheme.bodyMedium!.copyWith(
                          color: widget.fontColor, fontWeight: FontWeight.w600),
                ),
              if (widget.icon != null) ...[
                const SizedBox(width: 8),
                widget.icon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
