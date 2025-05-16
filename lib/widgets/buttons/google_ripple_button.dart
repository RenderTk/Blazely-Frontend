import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GoogleRippleButton extends StatefulWidget {
  final Function() onPressed;
  final String label;
  final bool fullWidth;
  final Duration cooldown;

  const GoogleRippleButton({
    super.key,
    required this.onPressed,
    this.label = 'Continue With Google',
    this.fullWidth = true,
    this.cooldown = const Duration(
      milliseconds: 600,
    ), // Default cooldown period
  });

  @override
  State<GoogleRippleButton> createState() => _GoogleRippleButtonState();
}

class _GoogleRippleButtonState extends State<GoogleRippleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handlePress() async {
    if (_isProcessing) return; // Prevent multiple clicks

    setState(() {
      _isProcessing = true;
    });

    _animationController.forward();
    await widget.onPressed();

    // Delay before allowing another click
    await Future.delayed(widget.cooldown);

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // The actual button
        ElevatedButton.icon(
          icon:
              _isProcessing
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  )
                  : FaIcon(
                    FontAwesomeIcons.google,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            minimumSize: Size(widget.fullWidth ? double.infinity : 200, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: _isProcessing ? null : _handlePress,
          label: Text(
            _isProcessing ? 'Processing...' : widget.label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),

        // Ripple animation overlay (only shown when not processing)
        if (!_isProcessing)
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned.fill(
                child: IgnorePointer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).colorScheme.primary.withValues(
                          alpha: 0.2 * (1 - _animation.value),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width:
                              MediaQuery.of(context).size.width *
                              _animation.value,
                          height:
                              MediaQuery.of(context).size.width *
                              _animation.value,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(
                              alpha: 0.2 * (1 - _animation.value),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
