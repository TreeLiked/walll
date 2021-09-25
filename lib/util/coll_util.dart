class CollUtil {
  static bool isListEmpty(List? list) {
    return list == null || list.isEmpty;
  }

  static bool isListNotEmpty(List? list) {
    return !isListEmpty(list);
  }

  static bool isMapEmpty(Map? map) {
    return map == null || map.isEmpty;
  }
}
