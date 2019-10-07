import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_area_size/safe_area_size.dart';

class CollapsibleHeader extends StatefulWidget {
  final bool open;
  final Widget body;
  final Widget headerContent;
  final Color headerColor;
  final double borderRadius;

  const CollapsibleHeader(
      {Key key,
      this.body,
      this.headerColor = Colors.green,
      this.headerContent,
      this.borderRadius = 15,
      this.open
      })
      : super(key: key);

  @override
  _CollapsibleHeaderState createState() => _CollapsibleHeaderState();
}

class _CollapsibleHeaderState extends State<CollapsibleHeader>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  GlobalKey _startHeader = GlobalKey();
  GlobalKey _stopHeader = GlobalKey();

  //TODO: Fazer um operador para fechar e abrir o header
  //TODO:

  bool _isOpen;
  double _screenSize;
  double _rowHeaderPct = 0.1;
  double _stopHeaderPct = 0.1;
  int _safeAreaSize;

  @override
  void initState() {
    super.initState();

    _isOpen = widget.open ?? false;

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            setState(() {});
          });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _rowHeaderPct = _startHeader.currentContext.size.height / _screenSize;
      final RenderBox item = _stopHeader.currentContext.findRenderObject();
      var stopPosition = item.localToGlobal(Offset.zero);

      await initPlatformState();

      _stopHeaderPct =
          (stopPosition.dy + item.size.height - _safeAreaSize) / _screenSize;

      /// This animation is used to mask the channel call, smoothing the content
      /// jump between its first build and the new position
      _isOpen
      ? _animationController.animateTo(_rowHeaderPct,
          duration: Duration(milliseconds: 500), curve: Curves.decelerate)
      : _animationController.animateTo(_stopHeaderPct,
          duration: Duration(milliseconds: 500), curve: Curves.decelerate);
    });

    _animationController.value = 0.0;
  }

  Future<void> initPlatformState() async {
    int statusBarHeigth;

    try {
      statusBarHeigth = await SafeAreaSize.statusBarSize;
    } on PlatformException {
      statusBarHeigth = 0;
    }

    if (!mounted) return 0;

    setState(() {
      _safeAreaSize = statusBarHeigth;
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Positioned(
          child: Container(
              color: widget.headerColor,
              child: Column(
                children: <Widget>[
                  Row(
                    key: _startHeader,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            _isOpen = !_isOpen;
                            _animationController.animateTo(
                                !_isOpen ? _rowHeaderPct : _stopHeaderPct,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.fastOutSlowIn);
                          },
                          icon: !_isOpen ? Icon(Icons.menu) : Icon(Icons.close))
                    ],
                  ),
                  Container(
                    key: _stopHeader,
                    child: widget.headerContent,
                    padding: EdgeInsets.only(top: widget.borderRadius),
                  ),
                ],
              )),
        ),
        Transform(
          transform: Matrix4.translationValues(
              0.0,
              _animationController.value * MediaQuery.of(context).size.height,
              0.0),
          child: Material(
              elevation: 10,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(widget.borderRadius),
                  topRight: Radius.circular(widget.borderRadius)),
              child: widget.body),
        )
      ],
    );
  }
}
