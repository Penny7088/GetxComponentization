import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageUtils {
  ImageUtils._();

  static const String _svgBasePath = 'assets/images/svg';
  static const String _svgCommonPath = 'assets/images/common';
  static const String _imageBasePath = 'assets/images';

  static const String _package = 'lib_uikit';

  /// 获取跟随主题变化的 SVG 图片
  /// 图片需分别存放在 assets/images/svg/light/ 和 assets/images/svg/dark/ 目录下
  /// [fileName] 图片名称，可以包含也可以不包含 .svg 后缀
  /// [package] 资源所在的包名，默认为 lib_uikit
  static Widget getThemeSvg(
    BuildContext context,
    String fileName, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    String? package = _package,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeFolder = isDark ? 'dark' : 'light';

    // 确保文件名包含 .svg 后缀
    final fullFileName = fileName.endsWith('.svg') ? fileName : '$fileName.svg';

    return SvgPicture.asset(
      '$_svgBasePath/$themeFolder/$fullFileName',
      package: package,
      width: width,
      height: height,
      fit: fit,
    );
  }

  /// 获取跟随主题变化的普通图片 (png, jpg, webp 等)
  /// 图片需分别存放在 assets/images/light/ 和 assets/images/dark/ 目录下
  /// [fileName] 图片名称，必须包含后缀，例如 'icon.png'
  /// [package] 资源所在的包名，默认为 lib_uikit
  static Widget getThemeImage(
    BuildContext context,
    String fileName, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    String? package = _package,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeFolder = isDark ? 'dark' : 'light';

    return Image.asset(
      '$_imageBasePath/$themeFolder/$fileName',
      package: package,
      width: width,
      height: height,
      fit: fit,
    );
  }

  /// 获取 onboarding 目录下的图片
  static Widget getOnboardingImage(
    String fileName, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    String? package = _package,
  }) {
    return Image.asset(
      '$_imageBasePath/onboarding/$fileName',
      package: package,
      width: width,
      height: height,
      fit: fit,
    );
  }

  static Widget getCommonSvg(
    String imageName, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    String? package = _package,
  }) {
    String path = '$_svgCommonPath/$imageName';
    return SvgPicture.asset(
      path,
      package: package,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }

  /// 获取普通 SVG 图片 (指定路径)
  static Widget getSvg(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    String? package = _package,
  }) {
    return SvgPicture.asset(
      path,
      package: package,
      width: width,
      height: height,
      fit: fit,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }
}
