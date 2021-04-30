

import 'package:gaaliya/screens/comments/commentProvider.dart';
import 'package:gaaliya/screens/dashboard/dashBoardProvider.dart';
import 'package:gaaliya/screens/profile/profileProvider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderState {
List<SingleChildWidget> providerList =[
  ChangeNotifierProvider<DashBoardProvider>(create: (_) => DashBoardProvider()),
  ChangeNotifierProvider<CommentProvider>(create: (_) => CommentProvider()),
  ChangeNotifierProvider<ProfileProvider>(create: (_) => ProfileProvider()),
];
}