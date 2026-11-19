import 'package:flutter/cupertino.dart';

import '../utils/app_colors.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CupertinoActivityIndicator(radius: 14),
          const SizedBox(height: 12),
          Text(
            'Memuat berita…',
            style: TextStyle(fontSize: 15, color: AppColors.secondaryLabel(context)),
          ),
        ],
      ),
    );
  }
}
