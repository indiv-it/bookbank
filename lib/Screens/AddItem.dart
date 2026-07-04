import 'package:bookbank/Theme/app_style.dart';
import 'package:bookbank/Widgets/ListButton.dart';
import 'package:flutter/material.dart';
import 'package:bookbank/Server/database.dart';
import 'package:bookbank/Server/db_helper.dart';
import 'package:intl/intl.dart';

// ----- AddItem Widget -----

class AddItem extends StatefulWidget {
  final MyData? existingItem;

  const AddItem({super.key, this.existingItem});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  // ----- State Variables -----
  num _number = 0;
  DateTime? selectedDate;
  String? selectedOption = 'Expense';
  String? selectedType = 'Bank';
  String? selectedGroup;
  String? _amountError;
  bool _isTransferMode = false;
  String _transferFrom = 'Bank';
  String _transferTo = 'Cash';

  // ----- Init State -----
  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    if (widget.existingItem != null) {
      _number = widget.existingItem!.amount;
      selectedOption = widget.existingItem!.moneyType == 'income'
          ? 'Income'
          : 'Expense';
      selectedType = widget.existingItem!.moneyList == 'bank' ? 'Bank' : 'Cash';
      selectedGroup = widget.existingItem!.moneyGroup.isEmpty
          ? null
          : widget.existingItem!.moneyGroup;
      _amountController.text = _number.toString();
      _titleController.text = widget.existingItem!.title ?? '';
    }
  }

  // ----- Date Selection -----
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.black,
              onPrimary: Colors.white,
              surface: AppColors.card,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: AppColors.card,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // ----- Date Formatting -----
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // ----- Dispose -----
  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 16),
            const SizedBox(width: 4),
            Text(
              'Add List',
              style: TextStyle(
                fontSize: AppSize.m.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Form
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Input
              Text(
                'Amount',
                style: TextStyle(
                  fontSize: AppSize.s.fontSize,
                  color: AppColors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                  color: AppColors.card,
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    Text(
                      '฿',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: AppSize.m.fontSize,
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _amountController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: AppSize.s.fontSize,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '00.00',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelStyle: TextStyle(
                            color: AppColors.grey,
                            fontSize: AppSize.s.fontSize,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value.isEmpty) {
                              _amountError = '*Please enter a amount';
                            } else {
                              _amountError = null;
                            }
                          });
                        },
                        onSaved: (value) {
                          _number = num.parse(value!);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.autorenew_rounded,
                        size: AppSize.xl.fontSize,
                      ),
                      onPressed: () {
                        setState(() {
                          _isTransferMode = !_isTransferMode;
                          if (_isTransferMode) {
                            _transferFrom = selectedType ?? 'Bank';
                            _transferTo = _transferFrom == 'Bank'
                                ? 'Cash'
                                : 'Bank';
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (_amountError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _amountError!,
                    style: TextStyle(
                      color: AppColors.red,
                      fontSize: AppSize.xs.fontSize,
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              // Transfer Mode Overlay or Normal Form
              if (_isTransferMode) ...[
                // Transfer UI
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.card,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_transferFrom',
                            style: TextStyle(
                              fontSize: AppSize.m.fontSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(
                              Icons.arrow_forward,
                              color: AppColors.grey,
                            ),
                          ),
                          Text(
                            '$_transferTo',
                            style: TextStyle(
                              fontSize: AppSize.m.fontSize,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _transferFrom = 'Bank';
                                _transferTo = 'Cash';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _transferFrom == 'Bank'
                                  ? AppColors.black
                                  : AppColors.card,
                              foregroundColor: _transferFrom == 'Bank'
                                  ? Colors.white
                                  : AppColors.black,
                              minimumSize: Size(120, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Bank'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _transferFrom = 'Cash';
                                _transferTo = 'Bank';
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _transferFrom == 'Cash'
                                  ? AppColors.black
                                  : AppColors.card,
                              foregroundColor: _transferFrom == 'Cash'
                                  ? Colors.white
                                  : AppColors.black,
                              minimumSize: Size(120, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text('Cash'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Titel / Date
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title',
                            style: TextStyle(
                              fontSize: AppSize.s.fontSize,
                              color: AppColors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                              color: AppColors.card,
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.text_fields,
                                  size: 16,
                                  color: AppColors.grey,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _titleController,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: AppSize.s.fontSize,
                                    ),
                                    decoration: InputDecoration(
                                      labelText: 'Title',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      labelStyle: TextStyle(
                                        color: AppColors.grey,
                                        fontSize: AppSize.s.fontSize,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.arrow_drop_down),
                                  offset: Offset(70, 50),
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onSelected: (String value) {
                                    setState(() {
                                      _titleController.text = value;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem<String>(
                                        value: 'Food',
                                        child: Text('Food'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Transport',
                                        child: Text('Transport'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Shopping',
                                        child: Text('Shopping'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Bills',
                                        child: Text('Bills'),
                                      ),
                                      PopupMenuItem<String>(
                                        value: 'Entertainment',
                                        child: Text('Entertainment'),
                                      ),
                                    ];
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(
                            fontSize: AppSize.s.fontSize,
                            color: AppColors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectDate(context),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 48,
                            width: 140,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.border),
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.card,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedDate != null
                                      ? _formatDate(selectedDate!)
                                      : 'Select',
                                  style: TextStyle(
                                    fontSize: AppSize.s.fontSize,
                                    color: selectedDate != null
                                        ? Colors.black
                                        : AppColors.grey,
                                  ),
                                ),
                                Icon(
                                  Icons.calendar_today,
                                  size: 18,
                                  color: AppColors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Money List
                Text(
                  'Money List',
                  style: TextStyle(
                    fontSize: AppSize.s.fontSize,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 48,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.card,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ListButton(
                        titel: "Income",
                        icon: Icons.trending_up,
                        onKey: selectedOption,
                        function: () {
                          setState(() {
                            selectedOption = 'Income';
                          });
                        },
                      ),
                      ListButton(
                        titel: "Expense",
                        icon: Icons.trending_down,
                        onKey: selectedOption,
                        function: () {
                          setState(() {
                            selectedOption = 'Expense';
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Money Position
                Text(
                  'Money Position',
                  style: TextStyle(
                    fontSize: AppSize.s.fontSize,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 48,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.card,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ListButton(
                        titel: 'Bank',
                        icon: Icons.account_balance_rounded,
                        onKey: selectedType,
                        function: () {
                          setState(() {
                            selectedType = 'Bank';
                          });
                        },
                      ),
                      ListButton(
                        titel: 'Cash',
                        icon: Icons.account_balance_wallet,
                        onKey: selectedType,
                        function: () {
                          setState(() {
                            selectedType = 'Cash';
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Group 1
                Text(
                  'Category',
                  style: TextStyle(
                    fontSize: AppSize.s.fontSize,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.card,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ListButton(
                            titel: 'Group1',
                            onKey: selectedGroup,
                            function: () {
                              setState(() {
                                if (selectedGroup == 'Group1') {
                                  selectedGroup = null;
                                } else {
                                  selectedGroup = 'Group1';
                                }
                              });
                            },
                          ),
                          ListButton(
                            titel: 'Group2',
                            onKey: selectedGroup,
                            function: () {
                              setState(() {
                                if (selectedGroup == 'Group2') {
                                  selectedGroup = null;
                                } else {
                                  selectedGroup = 'Group2';
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Group 2
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ListButton(
                            titel: 'Group3',
                            onKey: selectedGroup,
                            function: () {
                              setState(() {
                                if (selectedGroup == 'Group3') {
                                  selectedGroup = null;
                                } else {
                                  selectedGroup = 'Group3';
                                }
                              });
                            },
                          ),
                          ListButton(
                            titel: 'Group4',
                            onKey: selectedGroup,
                            function: () {
                              setState(() {
                                if (selectedGroup == 'Group4') {
                                  selectedGroup = null;
                                } else {
                                  selectedGroup = 'Group4';
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 30),

        // Save Button
        FilledButton(
          onPressed: () async {
            // Check form validation
            if (!_formKey.currentState!.validate()) return;

            // Validate amount
            if (_amountController.text.isEmpty) {
              setState(() {
                _amountError = '*Please enter a amount';
              });
              return;
            }

            // Save form data
            _formKey.currentState!.save();

            if (_isTransferMode) {
              // Handle transfer mode - create two records with 'transfer' type
              final expenseItem = MyData(
                amount: _number,
                moneyType: 'transfer',
                moneyList: _transferFrom == 'Bank' ? 'bank' : 'cash',
                moneyGroup: 'Transfer',
                date: DateFormat(
                  'yyyy-MM-dd',
                ).format(selectedDate ?? DateTime.now()),
                title: 'Transfer to $_transferTo',
              );

              final incomeItem = MyData(
                amount: _number,
                moneyType: 'transfer',
                moneyList: _transferTo == 'Bank' ? 'bank' : 'cash',
                moneyGroup: 'Transfer',
                date: DateFormat(
                  'yyyy-MM-dd',
                ).format(selectedDate ?? DateTime.now()),
                title: 'Transfer from $_transferFrom',
              );

              await DatabaseHelper.instance.insertData(expenseItem);
              await DatabaseHelper.instance.insertData(incomeItem);
            } else {
              // Normal mode - create single record
              final newItem = MyData(
                id: widget.existingItem?.id,
                amount: _number,
                moneyType: selectedOption == 'Income' ? 'income' : 'expense',
                moneyList: selectedType == 'Bank' ? 'bank' : 'cash',
                moneyGroup: selectedGroup ?? '',
                date: DateFormat(
                  'yyyy-MM-dd',
                ).format(selectedDate ?? DateTime.now()),
                title: _titleController.text.isNotEmpty
                    ? _titleController.text
                    : 'Anonymous',
              );

              // Insert or update data
              if (widget.existingItem == null) {
                await DatabaseHelper.instance.insertData(newItem);
              } else {
                await DatabaseHelper.instance.updateData(newItem);
              }
            }

            // Show success message
            if (!mounted) return;

            // Show snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width * 1.4,
                  left: MediaQuery.of(context).size.width * 0.5,
                  right: 16,
                ),
                backgroundColor: AppColors.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: AppColors.green, width: 3),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.green),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          widget.existingItem == null
                              ? 'Added successfully'
                              : 'Updated successfully',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: AppSize.s.fontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                duration: Duration(seconds: 2),
              ),
            );

            // Navigate back or reset form
            if (Navigator.canPop(context)) {
              Navigator.pop(context, true);
            } else {
              _formKey.currentState!.reset();
              setState(() {
                selectedOption = null;
                selectedType = null;
                selectedGroup = null;
                _number = 0;
              });
            }
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(400, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add),
              const SizedBox(width: 10),
              Text('Save'),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Function to show the bottom sheet
Future<void> showAddItemBottomSheet(
  BuildContext context, {
  MyData? existingItem,
  VoidCallback? onSaved,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.90,
              ),
              margin: const EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Draggable handle area
                  GestureDetector(
                    onVerticalDragEnd: (details) {
                      if (details.primaryVelocity! > 0) {
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: AddItem(existingItem: existingItem),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  if (result == true && onSaved != null) {
    onSaved();
  }
}
