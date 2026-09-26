import 'package:flutter/material.dart';
import 'package:agg/enums/minigame_type.dart';
import 'package:agg/constants/app_themes.dart';

class Textbox extends StatefulWidget{
  final MinigameType minigame;
  final List<String> names;
  final ValueChanged<String> onSubmit;

  const Textbox({
    super.key,
    required this.minigame,
    required this.names,
    required this.onSubmit
  });

  @override
  State<Textbox> createState() => _TextboxState();
}

class _TextboxState extends State<Textbox>{
  TextEditingController? _controller; 
  FocusNode? _focusNode;

  String? _errorText;

  void submitGuess() {
    final controller = _controller;

    if(controller == null){
      return;
    }

    final guess = controller.text.trim();

    //no guess
    if (guess.isEmpty) {
      setState(() {
        _errorText = 'Please enter an answer'; 
      });
      return;
    }

    //invalid guess
    final exists = widget.names.any((name) => name.trim().toLowerCase() == guess.toLowerCase());

    if(!exists){
      setState(() {
        _errorText = 'Answer not found'; 
      });
      return;
    }

    //valid guess
    setState(() {
      _errorText = null;
    });
     
    //send asnwer to parent and clear textbox
    widget.onSubmit(guess);

    controller.clear();
    _focusNode?.unfocus();
  }

  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width:256,
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue){
              final input = textEditingValue.text.trim().toLowerCase();

              if (input.isEmpty){
                return const Iterable<String>.empty();
              }

              return widget.names.where((name) => name.toLowerCase().contains(input)).take(5);
            },

            //selects an option
            onSelected: (String selection){
                
              setState(() {
                _errorText = null;
              });
            },

            fieldViewBuilder: (context, controller,focusNode,onFieldSubmitted,){ 
              _controller = controller;
              _focusNode = focusNode;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style: AppTextTheme.bodyText,
                    decoration: InputDecoration(
                      labelText: widget.minigame.name.toUpperCase(),
                      labelStyle: AppTextTheme.bodyText,
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.subBorder, width: 4)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.subBorder, width: 4)),
                      errorText: _errorText,
                    ),
                    onChanged: (_){
                      if (_errorText != null){
                        setState(() {
                          _errorText = null;
                        });
                      }
                    },
                    onSubmitted: (_) => submitGuess(),
                  ),
                ],
              );
            },

            optionsViewBuilder: (context, onSelected, options){
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  child: SizedBox(
                    width: 256,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options.elementAt(index);

                         return ListTile(
                          title: Text(option, style: AppTextTheme.bodyText),
                          onTap: () { onSelected(option);},
                          tileColor: AppColors.subBorder,
                          selectedTileColor: AppColors.border,
                        );
                      },
                    ),
                  ),
                )
              );
            }
          ),
        ),

        SizedBox(width: AppSpacing.bs),

        IconButton(
          onPressed: submitGuess,
          icon: Icon(appIcons['enter'] ?? Icons.help_outline, size: 48, color: AppColors.subBorder),
        ),
      ],
    );
  }
}



