import 'package:flutter/material.dart';

class BlazelyLoadingWidget extends StatefulWidget {
  final String loadingText;
  final Color primaryColor;
  final Color secondaryColor;

  const BlazelyLoadingWidget({
    super.key,
    this.loadingText = 'Loading your tasks...',
    this.primaryColor = Colors.blue,
    this.secondaryColor = Colors.teal,
  });

  @override
  State<BlazelyLoadingWidget> createState() => _BlazelyLoadingWidgetState();
}

class _BlazelyLoadingWidgetState extends State<BlazelyLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Alignment> _alignmentAnimation;
  bool _isForward = true;

  @override
  void initState() {
    super.initState();

    // Setup animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Create alignment animation for the loading bar
    _alignmentAnimation = Tween<Alignment>(
      begin: const Alignment(-1.2, 0.0),
      end: const Alignment(1.2, 0.0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animation and loop
    _animationController.forward();
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
        _isForward = false;
      } else if (status == AnimationStatus.dismissed) {
        _animationController.forward();
        _isForward = true;
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/blazely_logo.png",
            height: 250,
            width: 250,
            fit: BoxFit.cover,
          ),

          const SizedBox(height: 32),

          // Animated loading bar
          Container(
            width: 180,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Stack(
                  children: [
                    Align(
                      alignment: _alignmentAnimation.value,
                      child: Container(
                        width: 60,
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              widget.primaryColor.withValues(
                                alpha: _isForward ? 0.5 : 1.0,
                              ),
                              widget.primaryColor,
                              widget.secondaryColor,
                              widget.secondaryColor.withValues(
                                alpha: _isForward ? 1.0 : 0.5,
                              ),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: widget.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Loading text
          Text(
            widget.loadingText,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
