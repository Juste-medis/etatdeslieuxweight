part of flutter_mapbox_autocomplete;

class ApiSearchDebouncer {
  Timer? _debounce;

  void run(void Function() callback) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 500), callback); // Corrected
  }
}

class MapBoxAutoCompleteWidget extends StatefulWidget {
  final String? hint;
  final void Function(MapBoxPlace place)? onSelect;
  final bool closeOnSelect;
  final String language;
  final Location? location;
  final String? country;
  final String? city;
  final int? limit;

  const MapBoxAutoCompleteWidget({
    super.key,
    this.hint,
    this.onSelect,
    this.closeOnSelect = true,
    this.language = "en",
    this.location,
    this.city,
    this.limit,
    this.country,
  });

  @override
  _MapBoxAutoCompleteWidgetState createState() =>
      _MapBoxAutoCompleteWidgetState();
}

class _MapBoxAutoCompleteWidgetState extends State<MapBoxAutoCompleteWidget> {
  final _searchFieldTextController = TextEditingController();
  final _searchFieldTextFocus = FocusNode();
  final ApiSearchDebouncer _debouncer = ApiSearchDebouncer();

  Predections? _placePredictions = Predections.empty();

  @override
  void initState() {
    super.initState();
    _searchFieldTextFocus.requestFocus();
  }

  @override
  dispose() {
    _searchFieldTextController.dispose();
    _searchFieldTextFocus.dispose();
    super.dispose();
  }

  Future<void> _getPlaces(String input) async {
    if (input.isNotEmpty) {
      final user = {"q": input, "type": widget.city ?? "mapboxApi"};

      await getplaces(user).then((response) async {
        if (response.data == null) return;
        final predictions = Predections.fromJson(response.data);
        setState(() {
          _placePredictions = predictions; // Update the predictions state
        });
      }).catchError((e) {
        my_inspect(e);
      });
    } else {
      setState(() => _placePredictions = Predections.empty());
    }
  }

  void _onSearchTextChanged(String query) {
    _debouncer.run(() {
      _getPlaces(query);
    });
  }

  void _selectPlace(MapBoxPlace prediction) async {
    if (widget.onSelect != null) {
      widget.onSelect!(prediction);
    }
    if (widget.closeOnSelect) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primaryContainer,
        toolbarHeight: 120,
        leading: backbutton(() {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }).paddingOnly(left: 20, top: 5),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              hintText: widget.hint,
              textController: _searchFieldTextController,
              onChanged: (input) => _onSearchTextChanged(input),
              focusNode: _searchFieldTextFocus,
              onFieldSubmitted: (value) => _searchFieldTextFocus.unfocus(),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: theme.primaryColor,
                ),
                onPressed: () => _searchFieldTextController.clear(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _selectPlace(MapBoxPlace(
                        id: "0", placeName: _searchFieldTextController.text));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    textStyle: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Valider"),
                    ],
                  ),
                ).paddingRight(5)
              ],
            ).paddingTop(10)
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: theme.colorScheme.primaryContainer,
        child: ListView.separated(
          separatorBuilder: (cx, _) => const Divider(),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: _placePredictions!.features!.length,
          itemBuilder: (ctx, i) {
            MapBoxPlace _singlePlace = _placePredictions!.features![i];
            return ListTile(
              title: Text(_singlePlace.placeName!),
              onTap: () => _selectPlace(_singlePlace),
            );
          },
        ),
      ),
    );
  }
}
