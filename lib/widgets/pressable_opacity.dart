import 'package:flutter/cupertino.dart';

/// Umpan balik sentuh ala iOS: konten meredup sebentar saat ditekan.
class PressableOpacity extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const PressableOpacity({super.key, required this.onTap, required this.child});

  @override
  State<PressableOpacity> createState() => _PressableOpacityState();
}

class _PressableOpacityState extends State<PressableOpacity> {
  bool _ditekan = false;

  void _setDitekan(bool nilai) {
    if (_ditekan != nilai) setState(() => _ditekan = nilai);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setDitekan(true),
        onTapUp: (_) => _setDitekan(false),
        onTapCancel: () => _setDitekan(false),
        onTap: widget.onTap,
        child: AnimatedOpacity(
          opacity: _ditekan ? 0.6 : 1,
          duration: const Duration(milliseconds: 100),
          child: widget.child,
        ),
      ),
    );
  }
}
