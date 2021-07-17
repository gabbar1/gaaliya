

import 'package:gaaliya/helper/helper.dart';
import 'package:gaaliya/screens/comments/commentProvider.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';

import 'package:gaaliya/screens/galiImages/galiImageProvider.dart';
import 'package:gaaliya/screens/galiLib/galiLibProvider.dart';

import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderState {
List<SingleChildWidget> providerList =[

  ChangeNotifierProvider<CommentProvider>(create: (_) => CommentProvider()),

  ChangeNotifierProvider<ImageFile>(create: (_) => ImageFile()),
  ChangeNotifierProvider<GaliImageProvider>(create: (_) => GaliImageProvider()),

  ChangeNotifierProvider<GaliLibProvider>(create: (_) => GaliLibProvider()),
  ChangeNotifierProvider<DashBoardProvider>(create: (_) => DashBoardProvider()),

];
}