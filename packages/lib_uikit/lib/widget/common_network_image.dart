import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

enum ImageShape { rectangle, circle, rrect }

class CommonNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final double radius;
  final ImageShape shape;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Border? border;

  const CommonNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.radius = 0,
    this.shape = ImageShape.rectangle,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.border,
  });

  /// Factory for Circle Image
  factory CommonNetworkImage.circle({
    required String url,
    double? size,
    Widget? placeholder,
    Widget? errorWidget,
    BoxFit fit = BoxFit.cover,
    Border? border,
  }) {
    return CommonNetworkImage(
      url: url,
      width: size,
      height: size,
      shape: ImageShape.circle,
      placeholder: placeholder,
      errorWidget: errorWidget,
      fit: fit,
      border: border,
    );
  }

  /// Factory for Rounded Rectangle Image
  factory CommonNetworkImage.rrect({
    required String url,
    double? width,
    double? height,
    required double radius,
    Widget? placeholder,
    Widget? errorWidget,
    BoxFit fit = BoxFit.cover,
    Border? border,
  }) {
    return CommonNetworkImage(
      url: url,
      width: width,
      height: height,
      radius: radius,
      shape: ImageShape.rrect,
      placeholder: placeholder,
      errorWidget: errorWidget,
      fit: fit,
      border: border,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Default Shimmer Placeholder
    final Widget defaultPlaceholder = Shimmer.fromColors(
      baseColor: Theme.of(context).disabledColor.withOpacity(0.1),
      highlightColor: Theme.of(context).disabledColor.withOpacity(0.3),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: _getBoxShape(),
          borderRadius: _getBorderRadius(),
        ),
      ),
    );

    // Default Error Widget
    final Widget defaultError = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).disabledColor.withOpacity(0.1),
        shape: _getBoxShape(),
        borderRadius: _getBorderRadius(),
        border: border,
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.broken_image_rounded,
        color: Theme.of(context).iconTheme.color?.withOpacity(0.3),
        size: (width != null && height != null)
            ? (width! < height! ? width! * 0.4 : height! * 0.4)
            : 24,
      ),
    );

    return ExtendedImage.network(
      url,
      width: width,
      height: height,
      fit: fit,
      cache: true,
      border: border,
      shape: _getBoxShape(),
      borderRadius: _getBorderRadius(),
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return placeholder ?? defaultPlaceholder;
          case LoadState.completed:
            return null; // Use extended image default rendering
          case LoadState.failed:
            return errorWidget ?? defaultError;
        }
      },
    );
  }

  BoxShape _getBoxShape() {
    return shape == ImageShape.circle ? BoxShape.circle : BoxShape.rectangle;
  }

  BorderRadius? _getBorderRadius() {
    if (shape == ImageShape.rrect) {
      return BorderRadius.circular(radius);
    }
    return null;
  }
}
