// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

class MsgProvider extends ChangeNotifier {
  var sysCnt = 0;
  var tweetInterCnt = 0;
  var cirInterCnt = 0;
  var cirSysCnt = 0;

  // 总数
  var totalCnt = 0;

  // 不包含在total中
  var tweetNewCnt = 0;

  int get total {
    return getNonNullValue(sysCnt) +
        getNonNullValue(tweetInterCnt) +
        getNonNullValue(cirInterCnt) +
        getNonNullValue(cirSysCnt);
  }

  int get circleTotal {
    return getNonNullValue(cirInterCnt) + getNonNullValue(cirSysCnt);
  }

  int getNonNullValue(int? val) {
    return val ?? 0;
  }

  void refresh() {
    notifyListeners();
  }

  void updateSysCnt(int val) {
    this.sysCnt = getNonNullValue(val);
    this.updateTotal(total);
  }

  void updateTweetInterCnt(int val) {
    this.tweetInterCnt = getNonNullValue(val);
    this.updateTotal(total);
  }

  void updateCirInterCnt(int val) {
    this.cirInterCnt = getNonNullValue(val);
    this.updateTotal(total);
  }

  void updateCirSysCnt(int val) {
    this.cirSysCnt = getNonNullValue(val);
    this.updateTotal(total);
  }

  void updateTweetNewCnt(int val) {
    this.tweetNewCnt = getNonNullValue(val);
    this.refresh();
  }

  void updateTotal(int val) {
    this.totalCnt = val;
    this.refresh();
  }

  void clear() {
    this.tweetNewCnt = 0;
    this.tweetInterCnt = 0;
    this.sysCnt = 0;
    this.cirSysCnt = 0;
    this.cirInterCnt = 0;
    this.totalCnt = 0;
    this.refresh();
  }
}
