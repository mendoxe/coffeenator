import 'package:flutter/material.dart';

class FadingPageView extends StatefulWidget {
  const FadingPageView({
    required this.itemBuilder,
    this.itemCount,
    this.onPageChanged,
    super.key,
  });

  final IndexedWidgetBuilder itemBuilder;
  final ValueChanged<int>? onPageChanged;
  final int? itemCount;

  @override
  State<FadingPageView> createState() => _FadingPageViewState();
}

class _FadingPageViewState extends State<FadingPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page == _currentPage) {
      return;
    }
    setState(() {
      _currentPage = page;
    });
    widget.onPageChanged?.call(page);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                final page = _pageController.page ?? 0.0;
                final currentPageClamped = page.floor();
                final currentPageScroll = page - currentPageClamped;

                var scale = 1.0;
                if (index == currentPageClamped) {
                  scale = 1.0 - (currentPageScroll.abs() * 0.5);
                } else if (index == currentPageClamped + 1) {
                  scale = 0.5 + (currentPageScroll.abs() * 0.5);
                }

                return Opacity(
                  opacity: scale,
                  child: Transform.scale(
                    scale: scale,
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: widget.itemBuilder(context, index),
              ),
            );
          },
        ),
        for (final alignment in [Alignment.topCenter, Alignment.bottomCenter])
          Align(
            alignment: alignment,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: alignment,
                  end: alignment == Alignment.topCenter ? Alignment.bottomCenter : Alignment.topCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor.withValues(
                      alpha: 0,
                    ),
                  ],
                ),
              ),
              height: 24,
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_onPageChanged)
      ..dispose();
    super.dispose();
  }
}
