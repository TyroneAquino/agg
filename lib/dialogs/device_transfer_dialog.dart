import 'package:flutter/material.dart';
import 'package:agg/repositories/device_transfer_repository.dart';
import 'package:agg/constants/app_themes.dart';

class DeviceTransferDialog extends StatefulWidget {
  const DeviceTransferDialog({
    super.key,
  });

  @override
  State<DeviceTransferDialog> createState() => _DeviceTransferDialogState();
}

class _DeviceTransferDialogState extends State<DeviceTransferDialog> {

  bool generating = false;
  bool transferring = false;

  final TextEditingController codeController = TextEditingController();

  String? generatedCode;
  String? errorMessage;

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  Future<void> generateCode() async {
    setState(() {
      generating = true;
      errorMessage = null;
      generatedCode = null;
    });

    try {
      final code =await DeviceTransferRepository.generateCode();

      if (!mounted) return;

      setState(() {
        generatedCode = code;
        generating = false;
      });

    } catch (e) {
      if (!mounted) return;

      setState(() {
        generating = false;
        errorMessage =e.toString().replaceFirst('Exception: ','',);
      });
    }
  }

  Future<void> transfer() async {
    final code = codeController.text.trim();

    if (code.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a transfer code.';
      });

      return;
    }

    setState(() {
      transferring = true;
      errorMessage = null;
    });

    try {
      await DeviceTransferRepository.transferProgress(code);

      if (!mounted) return;

      setState(() {
        transferring = false;
      });

      Navigator.pop(context,true,);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Progress transferred successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        transferring = false;
        errorMessage = e.toString().replaceFirst('Exception: ','',);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.subBackground,
      title:  Text('Switch Device', style: AppTextTheme.headingSmall),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text('Move your A.GG progress to another device.', style: AppTextTheme.bodyText),

            const SizedBox(height: AppSpacing.lg),


            // -------------------GENERATE-----------------------

            Align(
              alignment: Alignment.centerLeft,
              child: Text('On your old device',style: AppTextTheme.bodyBold),
            ),

            const SizedBox(height: AppSpacing.bs),

            Text('Generate a code and enter it on your new device.', style: AppTextTheme.bodyText),

            const SizedBox(height: AppSpacing.md),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.subBorder ),
                onPressed: generating? null : generateCode,
                child: generating
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child:
                        CircularProgressIndicator(strokeWidth: 2,),
                    )
                  : Text('Generate Transfer Code', style: AppTextTheme.bodyText),
              ),
            ),

            if (generatedCode != null) ...[
              const SizedBox(height: AppSpacing.md),

              Text('Your transfer code:', style: AppTextTheme.bodyText),

              const SizedBox(height: AppSpacing.bs),

              SelectableText(generatedCode!,style: AppTextTheme.codeText),

              const SizedBox(height: AppSpacing.md),

              Text('This code expires in 10 minutes.',style: AppTextTheme.bodyText,),
            ],

            const SizedBox(height: AppSpacing.lg),

            const Divider(),

            const SizedBox(height: AppSpacing.lg),


            // ----------------- ENTER-------------------------

            Align(
              alignment: Alignment.centerLeft,
              child: Text('On your new device',style: AppTextTheme.bodyBold),
            ),

            const SizedBox(height: AppSpacing.bs),

            Text( 'Enter the code shown on your old device.', style: AppTextTheme.bodyText),

            const SizedBox(height: AppSpacing.md),

            TextField(
              controller: codeController,
              style: AppTextTheme.bodyText,
              textCapitalization:TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: 'Transfer Code', 
                labelStyle: AppTextTheme.labelText,
                hintText: 'XXXX-XXXX',
                hintStyle: AppTextTheme.hintText,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.border, width: 4)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.subBorder, width: 4)),
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.subBorder ),
                onPressed: transferring? null : transfer,
                child: transferring
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child:
                          CircularProgressIndicator(strokeWidth: 2,),
                    )
                  : Text('Transfer Progress', style: AppTextTheme.bodyText),
              ),
            ),

            if (errorMessage != null) ...[
              const SizedBox(height: AppSpacing.md),

              Text(errorMessage!, style: AppTextTheme.captionTextIncorrect,textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}