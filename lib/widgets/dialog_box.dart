import 'package:flutter/material.dart';
import 'package:agg/constants/app_themes.dart';
import 'package:agg/enums/dialog_type.dart';
import 'package:agg/models/dialog.dart';

class DialogBox extends StatelessWidget {
  final DialogType title;

  const DialogBox({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.subBackground,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title.name[0].toUpperCase()+title.name.substring(1), style: AppTextTheme.headingMedium),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(appIcons['close'], color: AppColors.body)
                )
              ],
            ),
            SizedBox(height: AppSpacing.bs),
            AppDialog(title: title)
          ],
        ),
      ),
    );
  }
}
