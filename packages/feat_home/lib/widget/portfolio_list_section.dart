import 'package:flutter/material.dart';
import 'package:lib_base/utils/extensions/int_extension.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:lib_uikit/widget/crypto_list_tile.dart';

class PortfolioListSection extends StatelessWidget {
  final List<CryptoModel> data;
  final Stream<List<CryptoModel>> stream;
  final VoidCallback? onMoreTap;
  final ValueChanged<CryptoModel>? onItemTap;

  const PortfolioListSection({
    super.key,
    required this.data,
    required this.stream,
    this.onMoreTap,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        12.height,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.largeBold('Portfolio'),
              TextButton(
                onPressed: onMoreTap,
                child: AppText.medium('More', color: const Color(0xFF2F66F6)),
              ),
            ],
          ),
        ),
        if (data.isEmpty)
          const Center(child: CircularProgressIndicator())
        else
          ListView.separated(
            // padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: data.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = data[index];
              // Transform the list stream into a single item stream
              final itemStream = stream.map((list) {
                return list.firstWhere(
                  (element) => element.symbol == item.symbol,
                  orElse: () => item,
                );
              }).distinct();

              return CryptoListTile(
                initialData: item,
                dataStream: itemStream,
                onTap: () => onItemTap?.call(item),
              );
            },
          ),
      ],
    );
  }
}
