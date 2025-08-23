import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.title, required this.sections, required this.isMainView});
  final String title;
  final bool isMainView;
  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 700),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 110.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(title),
                centerTitle: false,
                titlePadding: EdgeInsets.only(
                  left:  55,
                  bottom: 14,
                ),
                expandedTitleScale: isMainView ? 1.5 : 1.1,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed(
                <Widget>[
                  ListView(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: sections,
                  ),
                  const SizedBox(height: 30),
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
