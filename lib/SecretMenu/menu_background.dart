import 'package:com/SecretMenu/zoom_scaffold.dart';
import 'package:flutter/material.dart';

final menuScreenKey = new GlobalKey(debugLabel: 'MenuScreen');

class MenuScreen extends StatefulWidget {
  final Menu menu;
  final String selectedItemId;
  final Function(String) onMenuItemSelected;

  MenuScreen({this.menu, this.onMenuItemSelected, this.selectedItemId})
      : super(key: menuScreenKey);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  AnimationController titleAnimationController;
  double selectorYTop, selectorYBottom;

  setSelectedRenderBox(RenderBox renderBox) async {
    final newYTop = renderBox.localToGlobal(const Offset(0.0, 0.0)).dy;
    final newYBottom = newYTop + renderBox.size.height;

    if (newYTop != selectorYTop) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => {selectorYTop = newYTop});
      WidgetsBinding.instance
          .addPostFrameCallback((_) => {selectorYBottom = newYBottom});
    }
  }

  @override
  void initState() {
    super.initState();

    titleAnimationController = new AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
  }

  @override
  void dispose() {
    titleAnimationController.dispose();
    super.dispose();
  }

  createMenuTitle(MenuController menuController) {
    switch (menuController.state) {
      case MenuState.opening:
        titleAnimationController.forward();
        break;
      case MenuState.closing:
        titleAnimationController.reverse();
        break;

      case MenuState.open:
      case MenuState.closed:
    }

    return new AnimatedBuilder(
      animation: titleAnimationController,
      builder: (BuildContext context, Widget child) {
        return new Transform(
          transform: Matrix4.translationValues(
              250.0 * (1.0 - titleAnimationController.value) - 100.0, 0.0, 0.0),
          child: child,
        );
      },
      child: OverflowBox(
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 30.0),
          child: Text(
            'Menu',
            style: TextStyle(
                color: Colors.white24, fontSize: 200.0, fontFamily: 'mermaid'),
            textAlign: TextAlign.left,
            softWrap: false,
          ),
        ),
      ),
    );
  }

  createMenuItems(MenuController menuController) {
    final List<Widget> listItems = [];

    final perListItemDelay =
        menuController.state != MenuState.closing ? 0.15 : 0.0;

    for (var i = 0; i < widget.menu.items.length; i++) {
      final animationIntervalStart = i * perListItemDelay;
      final animationIntervalEnd = 1.0;

      final isSelected = widget.menu.items[i].id == widget.selectedItemId;

      listItems.add(AnimatedMenuListItem(
        menuState: menuController.state,
        isSelected: isSelected,
        duration: Duration(milliseconds: 350),
        curve: Interval(animationIntervalStart, animationIntervalEnd,
            curve: Curves.easeOut),
        menuListItem: new _MenuListItem(
          title: widget.menu.items[i].title,
          isSelected: isSelected,
          onTap: widget.menu.items[i].title != ''
              ? () {
                  widget.onMenuItemSelected(widget.menu.items[i].id);
                  menuController.close();
                }
              : null,
        ),
      ));
    }

    return new Transform(
      transform: Matrix4.translationValues(0.0, 225.0, 0.0),
      child: Column(
        children: listItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ZoomScaffoldMenuController(
      builder: (BuildContext context, MenuController menuController) {
        var shouldRenderSelector = true;
        var actualSelectorYTop = selectorYTop;
        var actualSelectorYBot = selectorYBottom;
        var selectorOpacity = 1.0;

        if (menuController.state == MenuState.closed ||
            menuController.state == MenuState.closing ||
            selectorYTop == null) {
          final RenderBox menuScreenRenderBox =
              context.findRenderObject() as RenderBox;

          if (menuScreenRenderBox != null) {
            final menuScreenHeight = menuScreenRenderBox.size.height;
            actualSelectorYTop = menuScreenHeight - 50.0;
            actualSelectorYBot = menuScreenHeight;
            selectorOpacity = 0.0;
          } else {
            shouldRenderSelector = false;
          }
        }

        return new Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/npat.jpg'), fit: BoxFit.cover),
          ),
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                createMenuTitle(menuController),
                createMenuItems(menuController),
                shouldRenderSelector
                    ? new ItemSelector(
                        opacity: selectorOpacity,
                        bottomY: actualSelectorYBot,
                        topY: actualSelectorYTop,
                      )
                    : new Container()
              ],
              textDirection: TextDirection.ltr,
            ),
          ),
        );
      },
    );
  }
}

class ItemSelector extends ImplicitlyAnimatedWidget {
  final double topY, bottomY, opacity;

  ItemSelector({this.opacity, this.bottomY, this.topY})
      : super(duration: const Duration(milliseconds: 350));

  @override
  _ItemSelectorState createState() => _ItemSelectorState();
}

class _ItemSelectorState extends AnimatedWidgetBaseState<ItemSelector> {
  Tween<double> _topY, _bottomY, _opacity;

  @override
  void forEachTween(visitor) {
    _topY = visitor(
      _topY,
      widget.topY,
      (dynamic value) => new Tween<double>(begin: value),
    );

    _bottomY = visitor(
      _bottomY,
      widget.bottomY,
      (dynamic value) => new Tween<double>(begin: value),
    );

    _opacity = visitor(
      _opacity,
      widget.opacity,
      (dynamic value) => new Tween<double>(begin: value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: _topY.evaluate(animation),
      child: Opacity(
        opacity: _opacity.evaluate(animation),
        child: Container(
          width: 5.0,
          height: _bottomY.evaluate(animation) - _topY.evaluate(animation),
          color: Colors.red,
        ),
      ),
    );
  }
}

class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {
  final _MenuListItem menuListItem;
  final MenuState menuState;
  final bool isSelected;
  final Duration duration;

  AnimatedMenuListItem({
    this.menuListItem,
    this.duration,
    this.isSelected,
    this.menuState,
    curve,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimatedMenuListItem createState() => new _AnimatedMenuListItem();
}

class _AnimatedMenuListItem
    extends AnimatedWidgetBaseState<AnimatedMenuListItem> {
  final double closedSlidePosition = 200.0;
  final double openSlidePosition = 0.0;
  Tween<double> _translation, _opacity;

  updateSelectedRenderBox() {
    final renderBox = context.findRenderObject() as RenderBox;

    if (renderBox != null && widget.isSelected) {
      (menuScreenKey.currentState as _MenuScreenState)
          .setSelectedRenderBox(renderBox);
    }
  }

  @override
  void forEachTween(visitor) {
    var slide, opacity;

    switch (widget.menuState) {
      case MenuState.closed:

      case MenuState.closing:
        slide = closedSlidePosition;
        opacity = 0.0;
        break;

      case MenuState.open:

      case MenuState.opening:
        slide = openSlidePosition;
        opacity = 1.0;
        break;
    }

    _translation = visitor(_translation, slide,
        (dynamic value) => new Tween<double>(begin: value));

    _opacity = visitor(
        _opacity, opacity, (dynamic value) => new Tween<double>(begin: value));
  }

  @override
  Widget build(BuildContext context) {
    updateSelectedRenderBox();
    return Opacity(
      opacity: _opacity.evaluate(animation),
      child: Transform(
        transform: Matrix4.translationValues(
            0.0, _translation.evaluate(animation), 0.0),
        child: widget.menuListItem,
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function() onTap;

  _MenuListItem({this.isSelected, this.onTap, this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: const Color(0x44000000),
      onTap: isSelected ? null : onTap,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.red : Colors.white,
              fontSize: 25.0,
              fontFamily: 'bebas-neue',
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

class Menu {
  final List<MenuItem> items;

  Menu({this.items});
}

class MenuItem {
  final String id, title;

  MenuItem({this.id, this.title});
}
