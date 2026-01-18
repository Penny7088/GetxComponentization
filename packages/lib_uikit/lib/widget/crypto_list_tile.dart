import 'package:flutter/material.dart';
import 'package:lib_uikit/models/i_crypto_card_data.dart';
import 'package:lib_base/theme/app_colors.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:lib_uikit/widget/crypto_smart_builder.dart';
import 'package:lib_uikit/widget/shadow_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CryptoListTile<T extends ICryptoCardData> extends StatelessWidget {
  final Stream<T>? dataStream;
  final T? initialData;
  final VoidCallback? onTap;

  const CryptoListTile({
    super.key,
    this.dataStream,
    this.initialData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CryptoSmartBuilder<T>(
      dataStream: dataStream,
      initialData: initialData,
      builder: (context, data) {
        final appColors = Theme.of(context).extension<AppColorExtension>()!;
        final primaryColor = Theme.of(context).primaryColor;
        final isPositive = data.changePercent >= 0;
        final changeColor = isPositive
            ? const Color(0xFF098C26)
            : const Color(0xFFCD0000);

        return ShadowCard(
          onTap: onTap,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          shadowColor: primaryColor.withOpacity(0.15),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFB119).withOpacity(0.2),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFB119), // Bitcoin Orange
                  ),
                  alignment: Alignment.center,
                  child: AppText.mediumBold(
                    data.symbol.substring(0, 1),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Name & Symbol
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.largeBold(
                      data.name.isNotEmpty ? data.name : data.symbol,
                      color: appColors.mainTextColor,
                    ),
                    SizedBox(height: 4.h),
                    AppText.small(
                      data.symbol,
                      color: appColors.secondTextColor,
                    ),
                  ],
                ),
              ),

              // Price & Change
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText.largeBold(
                    '\$${data.currentPrice.toStringAsFixed(2)}',
                    color: appColors.mainTextColor,
                  ),
                  SizedBox(height: 4.h),
                  AppText.smallBold(
                    '${isPositive ? '+' : ''}${data.changePercent.toStringAsFixed(2)}%',
                    color: changeColor,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
