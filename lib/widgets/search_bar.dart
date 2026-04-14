import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onChanged;
  final Function(String) onSubmitted;
  final List<String> suggestions;
  final VoidCallback onClear;

  const SearchBarWidget({
    Key? key,
    required this.onChanged,
    required this.onSubmitted,
    this.suggestions = const [],
    required this.onClear,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          decoration: InputDecoration(
            hintText: 'Search departments, labs, facilities...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _controller.clear();
                      widget.onClear();
                    },
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
          ),
        ),
        if (widget.suggestions.isNotEmpty && _focusNode.hasFocus)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.suggestions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(widget.suggestions[index]),
                  onTap: () {
                    widget.onSubmitted(widget.suggestions[index]);
                    _focusNode.unfocus();
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
