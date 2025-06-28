import 'package:flutter/material.dart';
import 'package:navy_admin/components/main_layout.dart';

class GenericListPage<T> extends StatefulWidget {
  final String title;
  final Future<List<T>> Function() fetchAll;
  final Future<List<T>> Function(String filterField, String filterValue) fetchByFilter;
  final Future<void> Function(T item) onDelete;
  final void Function(T item) onEdit;
  final VoidCallback onAdd;
  final String Function(T item) getName;
  final String Function(T item) getEmail;
  final String Function(T item)? getImageUrl;
  final List<String> filterFields;
  final String Function(String field)? getFilterLabel;
  final String defaultFilterField;

  const GenericListPage({
    Key? key,
    required this.title,
    required this.fetchAll,
    required this.fetchByFilter,
    required this.onDelete,
    required this.onEdit,
    required this.onAdd,
    required this.getName,
    required this.getEmail,
    this.getImageUrl,
    required this.filterFields,
    this.getFilterLabel,
    required this.defaultFilterField,
  }) : super(key: key);

  @override
  State<GenericListPage<T>> createState() => _GenericListPageState<T>();
}

class _GenericListPageState<T> extends State<GenericListPage<T>> {
  List<T> items = [];
  bool isLoadingList = true;
  final TextEditingController _searchController = TextEditingController();
  late String selectedFilterField = widget.defaultFilterField; // Inicialização direta

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
    setState(() {
      isLoadingList = true;
    });
    try {
      final lista = await widget.fetchAll();
      setState(() {
        items = lista;
        isLoadingList = false;
      });
    } catch (e) {
      setState(() {
        isLoadingList = false;
      });
    }
  }

  Future<void> fetchItemsByFilter(String field, String value) async {
    setState(() {
      isLoadingList = true;
    });
    try {
      final lista = await widget.fetchByFilter(field, value);
      setState(() {
        items = lista;
        isLoadingList = false;
      });
    } catch (e) {
      setState(() {
        isLoadingList = false;
      });
    }
  }

  void _onSearchChanged() {
    final search = _searchController.text.trim();
    if (search.isEmpty) {
      fetchItems();
    } else {
      fetchItemsByFilter(selectedFilterField, search);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(child:
    Column(
      children: [
        // Campo de pesquisa, filtro e Nº de Itens
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              // Dropdown com mesmo design dos forms
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromRGBO(0, 0, 0, 0.25),
                      offset: const Offset(1, 1),
                      blurRadius: 4.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedFilterField,
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF3535B5)),
                    dropdownColor: Colors.white,
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 14.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Domine',
                    ),
                    items: widget.filterFields
                        .map((field) => DropdownMenuItem<String>(
                              value: field,
                              child: Text(widget.getFilterLabel?.call(field) ?? field),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedFilterField = value;
                        });
                        _onSearchChanged();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => _onSearchChanged(),
                  decoration: InputDecoration(
                    hintText: 'Pesquisar...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade200,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Nº de Itens :",
                      style: TextStyle(fontSize: 10, color: Colors.redAccent),
                    ),
                    Text(
                      "${items.length}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: isLoadingList
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.red.shade50,
                        child: (widget.getImageUrl?.call(items[index]) != null &&
                                (widget.getImageUrl?.call(items[index]) as String).isNotEmpty)
                            ? ClipOval(
                          child: Image.network(
                            widget.getImageUrl!(items[index]),
                            fit: BoxFit.cover,
                            width: 48,
                            height: 48,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.directions_car, color: Colors.red.shade300, size: 32);
                            },
                          ),
                        )
                            : Icon(Icons.directions_car, color: Colors.red.shade300, size: 32),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.getName(items[index]),
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.getEmail(items[index]),
                              style: const TextStyle(
                                color: Color(0xFFB3B3B3),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Color(0xFF3535B5)),
                        tooltip: 'Editar',
                        onPressed: () => widget.onEdit(items[index]),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        tooltip: 'Excluir',
                        onPressed: () => widget.onDelete(items[index]),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: FloatingActionButton(
              onPressed: widget.onAdd,
              child: const Icon(Icons.add),
            ),
          ),
        )
      ],
    ));
  }
}