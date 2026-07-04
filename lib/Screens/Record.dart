import 'package:flutter/material.dart';

// Database / Style
import 'package:bookbank/Server/database.dart';
import 'package:bookbank/Server/db_helper.dart';
import 'package:bookbank/Theme/app_style.dart';

// Functions
import '../Functions/record/record_actions.dart';
import '../Functions/record/record_date_filter.dart';
import '../Functions/record/record_filter.dart';
import '../Functions/record/record_utils.dart';
import '../Widgets/record_widgets.dart';

class Record extends StatefulWidget {
  const Record({super.key});

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  List<MyData> _allTransactions = [];
  RecordFilter _filter = RecordFilter.all;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final data = await DatabaseHelper.instance.getAllData();
    if (!mounted) return;
    setState(() {
      _allTransactions = data;
      _isLoading = false;
    });
  }

  List<MyData> get _filteredTransactions {
    final query = _searchController.text.trim().toLowerCase();

    var filtered = _allTransactions.where((item) {
      if (_filter == RecordFilter.income && item.moneyType != 'income') {
        return false;
      }
      if (_filter == RecordFilter.expense && item.moneyType != 'expense') {
        return false;
      }
      return true;
    }).toList();

    filtered = filterByDateRange(
      filtered,
      _startDate,
      _endDate,
      (item) => item.date ?? '',
    );

    if (query.isNotEmpty) {
      filtered = filtered.where((item) {
        final name = getItemName(item).toLowerCase();
        return name.contains(query);
      }).toList();
    }

    return filtered;
  }

  bool get _hasDateRange => hasDateRange(_startDate, _endDate);

  String get _dateRangeLabel => getDateRangeLabel(_startDate, _endDate);

  Future<void> _selectDateRange() async {
    final picked = await selectDateRange(context, _startDate, _endDate);
    if (picked != null && mounted) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _clearDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
  }

  Future<void> _viewRecord(MyData item) async {
    await viewRecord(context, item);
  }

  Future<void> _editRecord(MyData item) async {
    await editRecord(context, item, _loadData);
  }

  Future<void> _deleteRecord(MyData item) async {
    await deleteRecord(context, item, _loadData);
  }

  void _handleMenuAction(String action, MyData item) {
    if (action == 'view') {
      _viewRecord(item);
    } else if (action == 'edit') {
      _editRecord(item);
    } else if (action == 'delete') {
      _deleteRecord(item);
    }
  }

  Widget _buildFilterTab({
    required RecordFilter value,
    required IconData icon,
    required String label,
  }) {
    return buildFilterTab(
      value: value,
      selectedFilter: _filter,
      icon: icon,
      label: label,
      onTap: () => setState(() => _filter = value),
    );
  }

  Widget _buildRecordRow(MyData item) {
    return buildRecordRow(item, (action) => _handleMenuAction(action, item));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredTransactions;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 45, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.list_alt, size: 28),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Record'),
                    Text(
                      'Transaction History',
                      style: TextStyle(
                        fontSize: AppSize.s.fontSize,
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 18, bottom: 12),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(50),
                color: AppColors.card,
              ),
              child: Row(
                children: [
                  _buildFilterTab(
                    value: RecordFilter.all,
                    icon: Icons.filter_list,
                    label: 'All',
                  ),
                  _buildFilterTab(
                    value: RecordFilter.income,
                    icon: Icons.trending_up,
                    label: 'Income',
                  ),
                  _buildFilterTab(
                    value: RecordFilter.expense,
                    icon: Icons.trending_down,
                    label: 'Expense',
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.card,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, size: AppSize.l.fontSize),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: AppSize.s.fontSize,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                color: AppColors.grey,
                                fontSize: AppSize.s.fontSize,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        if (_searchController.text.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: AppColors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Container(
                    height: 48,
                    width: 150,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _hasDateRange
                            ? AppColors.black
                            : AppColors.border,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      color: AppColors.card,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: _selectDateRange,
                            borderRadius: BorderRadius.circular(50),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                _dateRangeLabel,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: AppSize.s.fontSize,
                                  color: _hasDateRange
                                      ? Colors.black
                                      : AppColors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: _hasDateRange
                              ? _clearDateFilter
                              : _selectDateRange,
                          borderRadius: BorderRadius.circular(20),
                          child: Icon(
                            _hasDateRange ? Icons.close : Icons.calendar_today,
                            size: 18,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  color: AppColors.card,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: AppSize.s.fontSize,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Position',
                            style: TextStyle(
                              fontSize: AppSize.s.fontSize,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Date',
                            style: TextStyle(
                              fontSize: AppSize.s.fontSize,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(color: AppColors.border, height: 1),
                    Expanded(
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : filtered.isEmpty
                          ? Center(
                              child: Text(
                                'No records found',
                                style: TextStyle(
                                  fontSize: AppSize.s.fontSize,
                                  color: AppColors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                return _buildRecordRow(filtered[index]);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
