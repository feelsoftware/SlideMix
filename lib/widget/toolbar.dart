import 'package:flutter/material.dart';

class Toolbar extends StatelessWidget implements PreferredSizeWidget {
  final Image? leftIcon;
  final Image? rightIcon;
  final VoidCallback? onLeftIconTapped;
  final VoidCallback? onRightIconTapped;

  const Toolbar({
    super.key,
    this.leftIcon,
    this.rightIcon,
    this.onLeftIconTapped,
    this.onRightIconTapped,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (leftIcon != null)
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: onLeftIconTapped!,
                  icon: leftIcon!,
                  constraints: const BoxConstraints(maxHeight: 48),
                ),
              ),
            Image.asset(
              "assets/images/ic_logo.png",
              height: 32,
            ),
            if (rightIcon != null)
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: onRightIconTapped!,
                  icon: rightIcon!,
                  constraints: const BoxConstraints(maxHeight: 48),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
