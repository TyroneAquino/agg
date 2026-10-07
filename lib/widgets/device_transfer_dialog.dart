import 'package:flutter/material.dart';

import 'package:agg/repositories/device_transfer_repository.dart';

class DeviceTransferDialog extends StatefulWidget {
  const DeviceTransferDialog({
    super.key,
  });

  @override
  State<DeviceTransferDialog> createState() =>
      _DeviceTransferDialogState();
}

class _DeviceTransferDialogState
    extends State<DeviceTransferDialog> {

  bool generating = false;
  bool transferring = false;

  final TextEditingController codeController =
      TextEditingController();

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
      final code =
          await DeviceTransferRepository
              .generateCode();

      if (!mounted) return;

      setState(() {
        generatedCode = code;
        generating = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        generating = false;
        errorMessage =
            e.toString().replaceFirst(
              'Exception: ',
              '',
            );
      });
    }
  }

  Future<void> transfer() async {
    final code =
        codeController.text.trim();

    if (code.isEmpty) {
      setState(() {
        errorMessage =
            'Please enter a transfer code.';
      });

      return;
    }

    setState(() {
      transferring = true;
      errorMessage = null;
    });

    try {
      await DeviceTransferRepository
          .transferProgress(code);

      if (!mounted) return;

      setState(() {
        transferring = false;
      });

      Navigator.pop(
        context,
        true,
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Progress transferred successfully!',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        transferring = false;
        errorMessage =
            e.toString().replaceFirst(
              'Exception: ',
              '',
            );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Switch Device',
      ),

      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            const Text(
              'Move your A.GG progress to another device.',
            ),

            const SizedBox(height: 20),

            // ------------------------------------------
            // GENERATE
            // ------------------------------------------

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'On your old device',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Generate a code and enter it on your new device.',
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    generating
                        ? null
                        : generateCode,
                child: generating
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Generate Transfer Code',
                      ),
              ),
            ),

            if (generatedCode != null) ...[
              const SizedBox(height: 16),

              const Text(
                'Your transfer code:',
              ),

              const SizedBox(height: 8),

              SelectableText(
                generatedCode!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'This code expires in 10 minutes.',
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 28),

            const Divider(),

            const SizedBox(height: 20),

            // ------------------------------------------
            // ENTER
            // ------------------------------------------

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'On your new device',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Enter the code shown on your old device.',
            ),

            const SizedBox(height: 12),

            TextField(
              controller: codeController,
              textCapitalization:
                  TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Transfer Code',
                hintText: 'XXXX-XXXX',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    transferring
                        ? null
                        : transfer,
                child: transferring
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Transfer Progress',
                      ),
              ),
            ),

            if (errorMessage != null) ...[
              const SizedBox(height: 12),

              Text(
                errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}