import 'package:flutter/widgets.dart';

class Toolbar extends StatelessWidget with PreferredSizeWidget {
  final Image? leftIcon;
  final Image? rightIcon;
  final VoidCallback? onLeftIconTapped;
  final VoidCallback? onRightIconTapped;

  Toolbar(
      {this.leftIcon,
      this.rightIcon,
      this.onLeftIconTapped,
      this.onRightIconTapped});

  @override
  Size get preferredSize => Size.fromHeight(56);

  bool _hasLeftIcon() => leftIcon != null;

  bool _hasRightIcon() => rightIcon != null;

  Widget _getLeftIcon() {
    if (!_hasLeftIcon()) return Container();
    return GestureDetector(
      child: leftIcon!,
      onTap: onLeftIconTapped!,
    );
  }

  Widget _getRightIcon() {
    if (!_hasRightIcon()) return Container();
    return GestureDetector(
      child: rightIcon!,
      onTap: onRightIconTapped!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: _hasLeftIcon(),
                child: Container(
                  child: _getLeftIcon(),
                  width: 24,
                  height: 24,
                )),
            Image.asset(
              "assets/images/ic_logo.png",
              height: 32,
            ),
            Visibility(
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                visible: _hasRightIcon(),
                child: Container(
                  child: _getRightIcon(),
                  width: 24,
                  height: 24,
                )),
          ],
        ),
      ),
    );
  }
}
