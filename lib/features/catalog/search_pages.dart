import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../data/app_state.dart';
import '../../data/catalog.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key, required this.state});
  final AppState state;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final query = TextEditingController();
  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.state,
    builder: (context, _) {
      final results = widget.state.search(query.text);
      final searching = query.text.isNotEmpty || widget.state.filtered;
      return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const SafeArea(
          top: false,
          child: MainNavigation(1),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const ValueKey('search-input'),
                        controller: query,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: const Icon(
                            CupertinoIcons.search,
                            size: 18,
                            color: muted,
                          ),
                          suffixIcon: query.text.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: 'Clear search',
                                  onPressed: () {
                                    query.clear();
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.close, size: 18),
                                ),
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Filter books',
                      onPressed: () => go(context, '/filter'),
                      icon: const Icon(
                        CupertinoIcons.line_horizontal_3_decrease,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              if (widget.state.filtered)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text('${results.length} results'),
                      const Spacer(),
                      TextButton(
                        onPressed: widget.state.setFilters,
                        child: const Text('Clear filters'),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: searching
                    ? results.isEmpty
                          ? const EmptyState(
                              'No books found',
                              'Try another title, author, or price range.',
                            )
                          : ListView(
                              children: results
                                  .map((b) => BookTile(b))
                                  .toList(),
                            )
                    : ListView(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Top Hot Keyword'),
                          ),
                          const SizedBox(height: 20),
                          for (final keyword in [
                            'A Wrinkle in Time',
                            'The President Is Missing',
                            'James W. Loewen',
                            'The Guernsey Literary',
                            'Bob Woodward',
                          ])
                            ListTile(
                              dense: true,
                              title: Text(
                                keyword,
                                style: const TextStyle(fontSize: 14),
                              ),
                              onTap: () {
                                query.text = keyword;
                                setState(() {});
                              },
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class FilterPage extends StatefulWidget {
  const FilterPage({super.key, required this.state});
  final AppState state;
  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? author, category;
  String language = 'English', year = '2018';
  RangeValues price = const RangeValues(0, 70);
  @override
  void initState() {
    super.initState();
    author = widget.state.authorFilter;
    category = widget.state.categoryFilter;
    price = RangeValues(widget.state.minPrice, widget.state.maxPrice);
  }

  @override
  Widget build(BuildContext context) {
    final count = books
        .where(
          (b) =>
              (author == null || b.author == author) &&
              (category == null || b.category == category) &&
              b.price >= price.start * 100 &&
              b.price <= price.end * 100,
        )
        .length;
    return PageFrame(
      title: 'Filter',
      back: false,
      actions: [
        IconButton(
          tooltip: 'Close',
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: muted),
        ),
      ],
      bottom: PrimaryButton(
        'Filter ($count)',
        onPressed: () {
          widget.state.setFilters(
            author: author,
            category: category,
            min: price.start,
            max: price.end,
          );
          Navigator.pop(context);
          go(context, '/search');
        },
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        children: [
          _dropdown(
            'Author',
            author ?? 'All authors',
            ['All authors', ...books.map((b) => b.author)],
            (v) => setState(() => author = v == 'All authors' ? null : v),
          ),
          _dropdown(
            'Category',
            category ?? 'All categories',
            ['All categories', ...categories],
            (v) => setState(() => category = v == 'All categories' ? null : v),
          ),
          _dropdown('Language', language, [
            'English',
          ], (v) => setState(() => language = v!)),
          _dropdown('Publish Year', year, [
            '2018',
          ], (v) => setState(() => year = v!)),
          const Text('Price'),
          RangeSlider(
            values: price,
            min: 0,
            max: 70,
            divisions: 70,
            labels: RangeLabels(
              money((price.start * 100).round()),
              money((price.end * 100).round()),
            ),
            onChanged: (value) => setState(() => price = value),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                money((price.start * 100).round()),
                style: const TextStyle(color: green),
              ),
              Text(
                money((price.end * 100).round()),
                style: const TextStyle(color: green),
              ),
            ],
          ),
          TextButton(
            onPressed: () => setState(() {
              author = null;
              category = null;
              price = const RangeValues(0, 70);
            }),
            child: const Text('Reset filters'),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> changed,
  ) => FormFieldLabel(
    label,
    DropdownButtonFormField<String>(
      initialValue: value,
      key: ValueKey('$label-$value'),
      isExpanded: true,
      icon: const Icon(Icons.arrow_drop_down, color: muted),
      items: options
          .map(
            (v) => DropdownMenuItem(
              value: v,
              child: Text(v, style: const TextStyle(fontSize: 14)),
            ),
          )
          .toList(),
      onChanged: changed,
    ),
  );
}
