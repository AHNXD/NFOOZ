import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
  final List<ImageProvider> imageProviders;
  final double height;
  final TargetPlatform? platform;
  final Duration? interval;
  final TabController? tabController;
  final BoxFit fit;

  // Images will shrink according to the value of [height]
  // If you prefer to use the Material or Cupertino style activity indicator set the [platform] parameter
  // Set [interval] to let the carousel loop through each photo automatically
  // Pinch to zoom will be turned on by default
  const ImageCarousel(this.imageProviders,
      {super.key, this.height = 250.0, this.platform, this.interval, this.tabController, this.fit = BoxFit.cover});

  @override
  State createState() => _ImageCarouselState();
}

TabController? _tabController;

class _ImageCarouselState extends State<ImageCarousel> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    _tabController = widget.tabController ?? TabController(vsync: this, length: widget.imageProviders.length);

    if (widget.interval != null) {
      Timer.periodic(widget.interval!, (_) {
        _tabController!.animateTo(_tabController!.index == _tabController!.length - 1 ? 0 : ++_tabController!.index);
      });
    }
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: TabBarView(
        controller: _tabController,
        children: widget.imageProviders.map((ImageProvider provider) {
          return CarouselImageWidget(widget, provider, widget.fit, widget.height);
        }).toList(),
      ),
    );
  }
}

class CarouselImageWidget extends StatefulWidget {
  final ImageCarousel carousel;
  final ImageProvider imageProvider;
  final BoxFit fit;
  final double height;

  const CarouselImageWidget(this.carousel, this.imageProvider, this.fit, this.height, {super.key});

  @override
  State createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImageWidget> {
  bool _loading = true;

  Widget _getIndicator(TargetPlatform? platform) {
    if (platform == TargetPlatform.iOS) {
      return const CupertinoActivityIndicator();
    } else {
      return const SizedBox(
        height: 40.0,
        width: 40.0,
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    //widget.imageProvider.resolve(ImageConfiguration()).addListener();

    if (mounted) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: _loading
          ? _getIndicator(widget.carousel.platform ?? defaultTargetPlatform)
          : GestureDetector(
        child: Image(
          image: widget.imageProvider,
          fit: widget.fit,
        ),
        onTap: () {
          int index = int.parse(_tabController!.index.toString());
          switch(index){
          //Implement you case here
            case 0:
            case 1:
            case 2:
            default:
          }
        },
      ),
    );
  }
}