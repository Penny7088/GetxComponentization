import 'package:flutter/material.dart';
import 'package:lib_uikit/lib_uikit.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:lib_uikit/widget/crypto_grid_card.dart';

class MarketMoversSection extends StatelessWidget {
  final List<CryptoModel> data;
  final Stream<List<CryptoModel>> stream;
  final VoidCallback? onMoreTap;
  final ValueChanged<CryptoModel>? onCardTap;

  const MarketMoversSection({
    super.key,
    required this.data,
    required this.stream,
    this.onMoreTap,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.largeBold('Market Movers'),
              TextButton(
                onPressed: onMoreTap,
                child: AppText.medium('More', color: const Color(0xFF2F66F6)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: data.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    // Transform the list stream into a single item stream
                    final itemStream = stream.map((list) {
                      return list.firstWhere(
                        (element) => element.symbol == item.symbol,
                        orElse: () => item,
                      );
                    }).distinct();

                    return CryptoGridCard(
                      initialData: item,
                      dataStream: itemStream,
                      onTap: () => onCardTap?.call(item),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
