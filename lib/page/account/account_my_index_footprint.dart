import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wall/api/tweet_api.dart';
import 'package:wall/application.dart';
import 'package:wall/constant/color_constant.dart';
import 'package:wall/model/biz/common/page_param.dart';
import 'package:wall/model/biz/tweet/tweet.dart';
import 'package:wall/util/coll_util.dart';
import 'package:wall/widget/common/empty_view.dart';
import 'package:wall/widget/common/widget_sliver_future_builder.dart';
import 'package:wall/widget/tweet/tweet_self_item.dart';

class AccountFootPrintPage extends StatefulWidget {
  const AccountFootPrintPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountFootPrintPageState();
  }
}

class _AccountFootPrintPageState extends State<AccountFootPrintPage>
    with AutomaticKeepAliveClientMixin<AccountFootPrintPage>, SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(body: _buildBody(context));
  }

  _buildBody(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.only(bottom: 50),
        child: const Text('暂无更多足迹', style: TextStyle(color: Colours.secondaryFontColor, fontSize: 13.0)));
  }

  @override
  bool get wantKeepAlive => true;
}
