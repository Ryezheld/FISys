import 'dart:math' as math;
import 'package:flutter/material.dart';

@immutable
class ExampleExpandableFab extends StatelessWidget {
  final IconData parentButtonIcon;
  final double distance;
  final List<String> actionTitles;
  final bool isVertical;
  final List<Widget> children;

  const ExampleExpandableFab({
    super.key,
    required this.parentButtonIcon,
    required this.distance,
    required this.actionTitles,
    this.isVertical = false,
    required this.children,
  });

  void showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      parentButtonIcon: parentButtonIcon,
      distance: distance,
      isVertical: isVertical,
      children: children,
    );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.parentButtonIcon,
    required this.distance,
    required this.isVertical,
    required this.children,
    this.alignment = Alignment.bottomRight,
  });

  final bool? initialOpen;
  final IconData parentButtonIcon;
  final double distance;
  final bool isVertical;
  final List<Widget> children;
  final Alignment alignment;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = widget.isVertical ? 90.0 / (count - 1) : 90.0;
    for (var i = 0, angleInDegrees = 0.0; i < count; i++) {
      final angle = widget.isVertical ? 0.0 : angleInDegrees;
      final horizontalPosition = widget.isVertical ? 0.0 : widget.distance * i;
      final verticalPosition = widget.isVertical ? widget.distance * i : 0.0;

      children.add(
        _ExpandingActionButton(
          isVertical: widget.isVertical,
          angle: angle,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          horizontalPosition: horizontalPosition,
          verticalPosition: verticalPosition,
          alignment: widget.alignment,
          index: i + 1,
          child: widget.children[i],
        ),
      );

      if (widget.isVertical) {
        angleInDegrees += step;
      }
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: Icon(widget.parentButtonIcon),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.angle,
    required this.maxDistance,
    required this.progress,
    required this.horizontalPosition,
    required this.verticalPosition,
    required this.alignment,
    required this.child,
    required this.index,
    required this.isVertical,
  });

  final double angle;
  final double maxDistance;
  final Animation<double> progress;
  final double horizontalPosition;
  final double verticalPosition;
  final Alignment alignment;
  final Widget child;
  final int index;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final position = maxDistance * progress.value * index;
        final offset =
            isVertical ? Offset(0.0, position) : Offset(position, 0.0);

        return Positioned(
          right: isVertical ? 4.0 : 4.0 + offset.dx,
          bottom: isVertical ? 4.0 + offset.dy : 4.0,
          child: Transform.rotate(
            angle: isVertical
                ? (1.0 - progress.value) * math.pi / 2
                : (1.0 - progress.value) * angle,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    super.key,
    required this.isBig,
  });

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      height: isBig ? 128 : 36,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
