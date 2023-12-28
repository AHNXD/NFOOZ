import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:nfooz_webapp/util/common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EList extends StatefulWidget {
  final Future<List> Function(String? urlExtra) onRequestList;
  final Widget Function(BuildContext context, dynamic item) getListCard;
  final Future<dynamic> Function(String? urlExtra, String id) onRequestDetail;
  final Widget Function(
      BuildContext context,
      dynamic item,
      void Function(BuildContext context,
              {required String title, String params})?
          bookingForm) getDetailCard;
  final PreferredSizeWidget? appBarList;
  final PreferredSizeWidget appBarDetails;
  final String? urlExtra;
  final Widget? noData;
  final void Function(BuildContext context,
      {required String title, String params})? bookingForm;
  final Widget? floatingActionButton;

  const EList({
    Key? key,
    required this.onRequestList,
    required this.onRequestDetail,
    required this.getListCard,
    required this.getDetailCard,
    this.appBarList,
    required this.appBarDetails,
    this.urlExtra,
    this.noData,
    this.bookingForm,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  EListState createState() => EListState();
}

class EListState extends State<EList> {
  // var pageNo = 0;
  // var maxRecord = 10;

  @override
  void initState() {
    super.initState();
    widget
        .onRequestList(widget.urlExtra ?? "")
        .then((value) => setState(() => items = value));
  }

  // ignore: avoid_init_to_null
  List<dynamic>? items = null;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void refresh() async {
    if (items == null || items!.isEmpty) {
      _loaditems();
    } else {
      _refreshController.requestRefresh();
    }
  }

  void _loaditems() async {
    var newitems = await widget.onRequestList(widget.urlExtra ?? "");
    setState(() {
      items = newitems;
    });
  }

  void _onRefresh() async {
    _loaditems();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _loaditems();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBarList,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/background.png"), fit: BoxFit.cover),
        ),
        child: items == null
            ? isLoading()
            : items!.isEmpty
                ? widget.noData
                : SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: const WaterDropHeader(),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus? mode) {
                        // Widget body = Text("");
                        // if (mode == LoadStatus.idle)
                        // //body = Text("pull up load");
                        // else if (mode == LoadStatus.loading)
                        // //body = CupertinoActivityIndicator();
                        // else if (mode == LoadStatus.failed)
                        // //body = Text("Load Failed!Click retry!");
                        // else if (mode == LoadStatus.canLoading)
                        // //body = Text("release to load more");
                        // else
                        //   //body = Text("No more Data");
                        return Container(
                          height: 55.0,
                          // child: Center(child: body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.builder(
                      controller: ScrollController(),
                      itemCount: items!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                    onTap: () => openDetails(
                                          widget,
                                          context,
                                          items![index]['id'].toString(),
                                        ),
                                    child: widget.getListCard(
                                      context,
                                      items![index],
                                    )),
                              ),
                            ));
                      },
                    ),
                  ),
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  static Future<dynamic> openDetails(
      EList widget, BuildContext context, String id) {
    return push(
        context,
        EDetail(
          id: id,
          onRequestDetail: widget.onRequestDetail,
          getDetailCard: widget.getDetailCard,
          appBarDetails: widget.appBarDetails,
          urlExtra: widget.urlExtra ?? "",
          bookingForm: widget.bookingForm,
        ));
  }
}

class EDetail extends StatefulWidget {
  final dynamic id;

  final String? urlExtra;
  final Future<dynamic> Function(String? urlExtra, String id) onRequestDetail;
  final void Function(BuildContext context,
      {required String title, String params})? bookingForm;
  final Widget Function(
      BuildContext context,
      dynamic item,
      void Function(BuildContext context,
              {required String title, String params})?
          bookingForm) getDetailCard;
  final PreferredSizeWidget appBarDetails;

  const EDetail({
    Key? key,
    required this.id,
    required this.onRequestDetail,
    required this.getDetailCard,
    required this.appBarDetails,
    required this.urlExtra,
    this.bookingForm,
  }) : super(key: key);

  @override
  EDetailState createState() => EDetailState();
}

class EDetailState extends State<EDetail> {
  // ignore: avoid_init_to_null
  late List<dynamic>? items = null;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() {
    widget
        .onRequestDetail(widget.urlExtra, widget.id)
        .then((value) => setState(() => items = value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBarDetails,
      body: items == null
          ? isLoading()
          : widget.getDetailCard(
              context,
              items![0],
              widget.bookingForm,
            ),
    );
  }
}
