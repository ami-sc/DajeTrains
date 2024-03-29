import "package:flutter/material.dart";

class TrainsTopBar extends StatefulWidget implements PreferredSizeWidget {
  final Function(String) searchCallback;
  final GlobalKey<ScaffoldState> drawerId;

  const TrainsTopBar({
    required this.searchCallback,
    required this.drawerId,
    super.key,
  });

  @override
  State<TrainsTopBar> createState() => _TrainsTopBarState();

  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _TrainsTopBarState extends State<TrainsTopBar> {
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
          hintText: "Enter a train code",
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
