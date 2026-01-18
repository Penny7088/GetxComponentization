import 'package:flutter/material.dart';
import 'package:lib_uikit/models/i_crypto_card_data.dart';

/// A wrapper widget that handles Stream updates and repainting optimization
/// for CryptoModel data.
class CryptoSmartBuilder<T extends ICryptoCardData> extends StatelessWidget {
  final Stream<T>? dataStream;
  final T? initialData;
  final Widget Function(BuildContext context, T data) builder;

  const CryptoSmartBuilder({
    super.key,
    this.dataStream,
    this.initialData,
    required this.builder,
  }) : assert(
         dataStream != null || initialData != null,
         'Either dataStream or initialData must be provided',
       );

  @override
  Widget build(BuildContext context) {
    if (dataStream != null) {
      return StreamBuilder<T>(
        stream: dataStream!.distinct(), // Efficiently filter duplicate data
        initialData: initialData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          // Isolate repaints for performance
          return RepaintBoundary(child: builder(context, snapshot.data!));
        },
      );
    }
    return builder(context, initialData!);
  }
}
