import 'dart:convert';

import 'package:lib_base/utils/extensions/list_extensions.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

final lightKV = _LightModel();

class _LightModel {
  Box<dynamic>? _box;
  bool _isInitialized = false;
  Future<void>? _initFuture;
  Future config() async {
    await init();
  }

  Future<void> init() async {
    if (_isInitialized && _box != null) {
      return;
    }
    _initFuture ??= _doInitialize();
    await _initFuture;
  }

  Future<void> _doInitialize() async {
    if (!kIsWeb) {
      final dir = await getApplicationDocumentsDirectory();
      Hive.init(dir.path);
    }
    _box ??= await Hive.openBox<dynamic>('app_box');
    _isInitialized = true;
  }

  void remove(String key) async {
    await init();
    await _box?.delete(key);
  }

  Future<String?> getString({required String key}) async {
    await init();
    var newKey = key;
    final v = _box?.get(newKey);
    return v is String ? v : null;
  }

  Future<bool?> setString(
    String key,
    String? value, [
    bool genNewKey = true,
  ]) async {
    await init();
    if (key.isEmpty) return false;
    var newKey = key;
    await _box?.put(newKey, value);
    return true;
  }

  Future<int?> getInt(String? key) async {
    await init();
    if (key?.isEmpty == true) return null;
    var newKey = key!;
    final v = _box?.get(newKey);
    return v is int ? v : null;
  }

  Future<bool?> setInt(String key, int value) async {
    await init();
    if (key.isEmpty) return false;
    var newKey = key;
    await _box?.put(newKey, value);
    return true;
  }

  Future<bool?> getBool(String? key) async {
    await init();
    if (key?.isEmpty == true) return null;
    var newKey = key!;
    final v = _box?.get(newKey);
    return v is bool ? v : null;
  }

  Future<bool?> setBool(String key, bool value) async {
    await init();
    if (key.isEmpty) return false;
    var newKey = key;
    await _box?.put(newKey, value);
    return true;
  }

  Future<List<String>?> getStringList(
    String key, [
    bool genNewKey = true,
  ]) async {
    await init();
    if (key.isEmpty) return null;
    var newKey = key;
    final v = _box?.get(newKey);
    if (v is List) {
      return v.cast<String>();
    }
    if (v is String && v.isNotEmpty) {
      return json.decode(v).cast<String>();
    }
    return <String>[];
  }

  ///
  Future<bool?> setStringList(
    String key,
    List<String> list, [
    bool genNewKey = true,
  ]) async {
    await init();
    if (key.isEmpty) return false;
    var newKey = key;
    if (list.isEmpty) {
      await _box?.delete(newKey);
      return true;
    } else {
      await _box?.put(newKey, list);
      return true;
    }
  }

  Future<bool> putModels<M>({required M model, required String key}) async {
    List<String>? cache = await lightKV.getStringList(key);
    if (model == null) {
      return false;
    }
    cache ??= <String>[];
    String m = json.encode(model);
    cache.add(m);
    return await lightKV.setStringList(key, cache.removeDuplicates()) ?? false;
  }

  Future<List<String>?> getModels({required String key}) async {
    List<String>? cache = await lightKV.getStringList(key);
    if (cache == null || cache.isEmpty == true) {
      return null;
    }
    return cache;
  }
}
