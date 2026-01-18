import 'package:flutter/material.dart';
import 'package:lib_base/enum/common_place_hold_type.dart';
import 'package:lib_base/utils/extensions/int_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonPlaceHoldPage extends StatefulWidget {
  const CommonPlaceHoldPage({
    super.key,
    required this.placeHoldType,
    this.ontap,
    this.btnMsg,
    this.msg,
  });
  final CommonPlaceHoldType placeHoldType;
  final String? msg;
  final String? btnMsg;
  final Function? ontap;
  @override
  State<StatefulWidget> createState() {
    return _CommonPlaceHoldPageState();
  }
}

class _CommonPlaceHoldPageState extends State<CommonPlaceHoldPage> {
  Widget createPlaceImageWidget() {
    return createNoDataWidget();
  }

  // 空数据动图
  Widget createNoDataWidget() {
    return Container(
      width: 200,
      height: 140,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Center(
        child: Image.asset('Assets.baseNoDataStatus', width: 140, height: 140),
      ),
    );
  }

  /// 创建暂位图标语
  Widget createPlaceTitleWidget() {
    String title = "";
    if (widget.placeHoldType == CommonPlaceHoldType.notNetwork) {
      title = "暂无网络,请稍后重试";
    } else if (widget.placeHoldType == CommonPlaceHoldType.nothing) {
      title = "暂无数据";
    }
    title = widget.msg ?? title;
    return Text(
      title,
      style: TextStyle(color: Colors.black, fontSize: 14.sp),
    );
  }

  /// 创建暂位图描述语
  Widget createPlaceMessageWidget() {
    return Container(child: Text("我是展位图"));
  }

  /// 创建暂位图 刷新按钮
  Widget createPlaceReloadBtnWidget() {
    return InkWell(
      onTap: () async {
        if (widget.ontap != null) {
          widget.ontap!();
        }
      },
      child: Container(
        alignment: Alignment.center,
        width: 100.w,
        height: 40.w,
        decoration: BoxDecoration(
          boxShadow: [configThemeShadow()],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
        ),
        child: Text(
          widget.btnMsg ?? "刷新",
          style: TextStyle(color: Colors.black, fontSize: 14.sp),
        ),
      ),
    );
  }

  BoxShadow configThemeShadow({double opacity = 0.8}) {
    return BoxShadow(
      color: Colors.white.withOpacity(opacity),
      offset: const Offset(0, 3),
      blurRadius: 10,
      spreadRadius: 0,
    );
  }

  /// 触发方法
  ///
  ///
  Widget placeWidget({int type = 1}) {
    Widget? child = Container();
    switch (type) {
      case 1:
        child = createPlaceImageWidget();
        break;
      case 2:
        child = createPlaceTitleWidget();
        break;
      case 3:
        child = createPlaceMessageWidget();
        break;
      case 4:
        child = createPlaceReloadBtnWidget();
        break;
      default:
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          placeWidget(type: 1),
          placeWidget(type: 2),
          12.height,
          placeWidget(type: 4),
        ],
      ),
    );
  }
}
