import 'package:flutter/material.dart';

class HistoryTopBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) searchCallback;

  const HistoryTopBar({
    required this.searchCallback,
    super.key,
  });

  @override
  State<HistoryTopBar> createState() => _HistoryTopBarState();

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _HistoryTopBarState extends State<HistoryTopBar> {
  final TextEditingController _searchController = TextEditingController();

  /*
  void _onBackButtonTap() {
    // Notify that the back button was pressed.
    widget.backButtonCallback();
  }
  */

  void _doSearch() {
    // Send the query (in lower case) to the callback.
    widget.searchCallback(_searchController.text.toLowerCase());
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_doSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFA5E6FB),
      title: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search in history",
          prefixIcon: Icon(Icons.search),
        )
      ),
    );
  }
}
