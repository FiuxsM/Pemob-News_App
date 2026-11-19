import 'package:flutter/cupertino.dart';

import '../models/article_model.dart';
import '../views/detail_view.dart';
import '../views/home_view.dart';
import '../views/search_results_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.detail:
        {
          final args = settings.arguments;
          if (args is ArticleModel) return _page(settings, DetailView(article: args));
        }
      case AppRoutes.search:
        {
          final args = settings.arguments;
          if (args is String) return _page(settings, SearchResultsView(keyword: args));
        }
    }
    return _page(settings, const HomeView());
  }

  static CupertinoPageRoute<void> _page(RouteSettings settings, Widget page) {
    return CupertinoPageRoute<void>(settings: settings, builder: (_) => page);
  }
}
