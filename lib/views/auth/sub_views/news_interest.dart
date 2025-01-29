import 'package:bytesized_news/views/auth/sub_views/alert_message.dart';
import 'package:bytesized_news/views/settings/settings_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

// Code taken from https://github.com/tommyxchow/frosty/ (originally written by ZeykaFX)
class SettingUserInterest extends StatefulWidget {
  final SettingsStore settingsStore;
  const SettingUserInterest({super.key, required this.settingsStore});

  @override
  State<SettingUserInterest> createState() => _SettingUserInterestState();
}

class _SettingUserInterestState extends State<SettingUserInterest> {
  late final SettingsStore settingsStore;
  final TextEditingController textController = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  @override
  void initState() {
    settingsStore = widget.settingsStore;
    super.initState();
  }

  void addUserInterest(String text) {
    settingsStore.userInterests = [
      ...settingsStore.userInterests,
      text,
    ];

    textController.clear();
    textFieldFocusNode.unfocus();
  }

  void removeUserInterest(int index) {
    settingsStore.userInterests = [
      ...settingsStore.userInterests..removeAt(index),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 6.0),
      trailing: const Icon(Icons.edit),
      title: const Text('News Interests for Suggestions'),
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
                          addUserInterest(value);
                        },
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Enter keywords',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                          suffixIcon: IconButton(
                            tooltip: textController.text.isEmpty
                                ? 'Cancel'
                                : 'Add keyword',
                            onPressed: () {
                              if (textController.text.isEmpty) {
                                textFieldFocusNode.unfocus();
                              } else {
                                addUserInterest(
                                  textController.text,
                                );
                              }
                            },
                            icon: const Icon(Icons.check),
                          ),
                        ),
                      ),
                    ),
                    if (settingsStore.userInterests.isEmpty)
                      const Expanded(
                        child: AlertMessage(
                          message: 'No muted keywords',
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: settingsStore.userInterests.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                                settingsStore.userInterests.elementAt(index)),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                // show confirmation dialog before deleting a keyword
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete keyword'),
                                    content: const Text(
                                      'Are you sure you want to delete this keyword?',
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
                                          removeUserInterest(index);
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
