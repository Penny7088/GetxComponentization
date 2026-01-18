import 'dart:math';

import 'package:lib_uikit/widget/k_line/k_line_entity.dart';

class DataUtil {
  static List<KLineEntity> generateRandomData({int count = 60}) {
    List<KLineEntity> data = [];
    double basePrice = 30000.0;
    int baseTime = DateTime.now().millisecondsSinceEpoch;
    Random random = Random();

    for (int i = 0; i < count; i++) {
      double open = basePrice + (random.nextDouble() - 0.5) * 500;
      double close = open + (random.nextDouble() - 0.5) * 500;
      double high = max(open, close) + random.nextDouble() * 100;
      double low = min(open, close) - random.nextDouble() * 100;
      double volume = random.nextDouble() * 1000 + 100;

      data.add(
        KLineEntity(
          time: baseTime - (count - i) * 60000,
          open: open,
          high: high,
          low: low,
          close: close,
          volume: volume,
        ),
      );

      basePrice = close;
    }

    calculateMA(data);
    calculateMACD(data);
    return data;
  }

  static void calculateMA(List<KLineEntity> data) {
    double ma5 = 0;
    double ma10 = 0;
    double ma30 = 0;

    for (int i = 0; i < data.length; i++) {
      KLineEntity entity = data[i];
      ma5 += entity.close;
      ma10 += entity.close;
      ma30 += entity.close;

      if (i >= 5) {
        ma5 -= data[i - 5].close;
        entity.ma5 = ma5 / 5;
      } else {
        entity.ma5 = ma5 / (i + 1);
      }

      if (i >= 10) {
        ma10 -= data[i - 10].close;
        entity.ma10 = ma10 / 10;
      } else {
        entity.ma10 = ma10 / (i + 1);
      }

      if (i >= 30) {
        ma30 -= data[i - 30].close;
        entity.ma30 = ma30 / 30;
      } else {
        entity.ma30 = ma30 / (i + 1);
      }
    }
  }

  static void calculateMACD(List<KLineEntity> data) {
    // 简单的 MACD 计算模拟，仅用于演示
    double ema12 = 0;
    double ema26 = 0;
    double dif = 0;
    double dea = 0;
    double macd = 0;

    for (int i = 0; i < data.length; i++) {
      KLineEntity entity = data[i];
      if (i == 0) {
        ema12 = entity.close;
        ema26 = entity.close;
      } else {
        ema12 = ema12 * 11 / 13 + entity.close * 2 / 13;
        ema26 = ema26 * 25 / 27 + entity.close * 2 / 27;
      }
      dif = ema12 - ema26;
      dea = dea * 8 / 10 + dif * 2 / 10;
      macd = (dif - dea) * 2;
      entity.dif = dif;
      entity.dea = dea;
      entity.macd = macd;
    }
  }
}
