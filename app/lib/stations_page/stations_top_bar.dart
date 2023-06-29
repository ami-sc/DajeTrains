import 'package:flutter/material.dart';

class StationsTopBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) searchCallback;
  final GlobalKey<ScaffoldState> drawerId;

  const StationsTopBar({
    required this.searchCallback,
    required this.drawerId,
    super.key,
  });

  @override
  State<StationsTopBar> createState() => _StationsTopBarState();

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _StationsTopBarState extends State<StationsTopBar> {
  final TextEditingController _searchController = TextEditingController();


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

      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          widget.drawerId.currentState?.openDrawer();
      }),

      title: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Enter a station name",
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: _searchController.clear,
          )
        )
      ),
    );
  }
}
