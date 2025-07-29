import 'package:bytesized_news/views/auth/sub_views/alert_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// Code taken from https://github.com/tommyxchow/frosty/ (originally written by ZeykaFX)
class KeywordsBottomSheet extends StatefulWidget {
  final List<String> Function() getKeywords;
  final String title;
  final Function(String) additionCallback;
  final Function(int) removalCallback;
  final bool removePadding;
  const KeywordsBottomSheet({
    super.key,
    required this.getKeywords,
    required this.title,
    required this.additionCallback,
    required this.removalCallback,
    this.removePadding = false,
  });

  @override
  State<KeywordsBottomSheet> createState() => _KeywordsBottomSheetState();
}

class _KeywordsBottomSheetState extends State<KeywordsBottomSheet> {
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void addKeyword(String text) {
    widget.additionCallback(text);

    textController.clear();
    textFieldFocusNode.unfocus();
  }

  void removeKeyword(int index) {
    widget.removalCallback(index);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: widget.removePadding ? EdgeInsets.zero : null,
      trailing: Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Icon(Icons.edit),
      ),
      title: Text(widget.title),
      onTap: () => showModalBottomSheet(
        showDragHandle: true,
        isScrollControlled: true,
        context: context,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Observer(
              builder: (context) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      child: TextField(
                        controller: textController,
                        focusNode: textFieldFocusNode,
                        onChanged: (value) {
                          textController.text = value;
                        },
                        onSubmitted: (value) {
                          addKeyword(value);
                        },
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Enter interest',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surfaceContainer,
                          suffixIcon: IconButton(
                            tooltip: textController.text.isEmpty ? 'Cancel' : 'Add interest',
                            onPressed: () {
                              if (textController.text.isEmpty) {
                                textFieldFocusNode.unfocus();
                              } else {
                                addKeyword(
                                  textController.text,
                                );
                              }
                            },
                            icon: const Icon(Icons.check),
                          ),
                        ),
                      ),
                    ),
                    if (widget.getKeywords().isEmpty)
                      const Expanded(
                        child: AlertMessage(
                          message: 'Nothing here...',
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: widget.getKeywords().length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(widget.getKeywords().elementAt(index)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // show confirmation dialog before deleting an entry
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete interest?'),
                                    content: const Text(
                                      'Are you sure you want to delete this interest?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          removeKeyword(index);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }
}
