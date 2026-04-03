import 'dart:async';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart' show window, Storage;
import '../value.dart';

class StorageImpl {
  StorageImpl(this.fileName, [this.path]);
  Storage get localStorage => window.localStorage;

  final String? path;
  final String fileName;

  ValueStorage<Map<String, dynamic>> subject =
      ValueStorage<Map<String, dynamic>>(<String, dynamic>{});

  void clear() {
    localStorage.removeItem(fileName);
    subject.value?.clear();

    subject
      ..value?.clear()
      ..changeValue("", null);
  }

  Future<void> flush() {
    return _writeToStorage(subject.value);
  }

  T? read<T>(String key) {
    return subject.value?[key] as T?;
  }

  T getKeys<T>() {
    return subject.value?.keys as T;
  }

  T getValues<T>() {
    return subject.value?.values as T;
  }

  Future<void> init([Map<String, dynamic>? initialData]) async {
    if (initialData != null) {
      subject.value = initialData;
      if (await _readFromStorage() == null) {
        await _writeToStorage(subject.value);
      }
    }
    return;
  }

  void remove(String key) {
    subject
      ..value?.remove(key)
      ..changeValue(key, null);
    //  return _writeToStorage(subject.value);
  }

  void write(String key, dynamic value) {
    subject
      ..value?[key] = value
      ..changeValue(key, value);
    //return _writeToStorage(subject.value);
  }

  // void writeInMemory(String key, dynamic value) {

  // }

  Future<void> _writeToStorage(Map<String, dynamic>? data) async {
    if (data == null) return;
    localStorage.setItem(fileName, json.encode(data));
  }

  Future<Map<String, dynamic>?> _readFromStorage() async {
    final dataFromLocal_ = localStorage.getItem(fileName);
    if (dataFromLocal_ != null) {
      subject.value = json.decode(dataFromLocal_) as Map<String, dynamic>;
      return subject.value;
    }
    return null;
  }
}
