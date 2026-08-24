import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  final String btnText;
  final VoidCallback? onPressed;
  final Image? img;
  final Color? btnColor;
  final Color? btnTextColor;
  final Color? borderColor;
  final double? btnTextFontSize;
  const ButtonWidget({
    super.key,
    required this.btnText,
    this.onPressed,
    this.img,
    this.btnTextColor = Colors.white,
    this.btnColor = const Color(0xFF6055D8),
    this.btnTextFontSize = 20,
    this.borderColor,
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: widget.onPressed,
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: widget.btnColor,
            border: Border.all(color: widget.borderColor ?? Colors.transparent),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.img != null) ...[
                SizedBox(width: 20, height: 20, child: widget.img!),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  widget.btnText,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: widget.btnTextFontSize,
                    fontWeight: FontWeight.w400,
                    color: widget.btnTextColor,
                    fontFamily: "Roboto",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
