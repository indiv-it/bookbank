// ─── App Localizations ────────────────────────────────────────────────────────
// Centralized translation strings for Thai, English, and Chinese

class AppLocalizations {
  final String languageCode;

  const AppLocalizations(this.languageCode);

  static const Map<String, Map<String, String>> _translations = {
    // English
    'en': {
      // Header / Menu
      'edit_group': 'Edit Group',
      'dark_theme': 'Dark Theme',
      'change_language': 'Change Language',
      'change_currency': 'Change Currency',
      'about': 'About',
      'app_version': 'Version',
      'app_description': '        An app for tracking your income and expenses that also shows spending trends, helping you plan your finances more effectively. Regarding security, your data is stored exclusively on your device.',
      'developer': 'Developer',

      // Language names
      'lang_thai': 'Thai',
      'lang_english': 'English',
      'lang_chinese': 'Chinese',

      // Currency names
      'currency_baht': 'Thai Baht (\u0e3f)',
      'currency_dollar': 'US Dollar (\$)',
      'currency_yuan': 'Chinese Yuan (¥)',

      // Dashboard
      'total_balance': 'Total Balance',
      'bank': 'Bank',
      'cash': 'Cash',
      'income': 'Income',
      'expense': 'Expense',
      'monthly_income': 'Monthly Income',
      'monthly_expense': 'Monthly Expense',
      'unallocated': 'Unallocated',
      'transactions': 'Transactions',
      'from': 'from',

      // Charts
      'dashboard': 'Dashboard',
      'view_stats': 'View your statistics in detail.',
      'data_for_day': 'Data for this day',
      'income_expense_by_category': 'Income and expenses by category',
      'monthly_data': 'Monthly data',
      'net': 'Net',
      'not_enough_data': 'Not enough data',

      // Record screen
      'record': 'Record',
      'transaction_history': 'Transaction History',
      'all': 'All',
      'search': 'Search',
      'no_records': 'No records found',
      'amount': 'Amount',
      'position': 'Position',
      'date': 'Date',
      'view': 'View',
      'edit': 'Edit',
      'delete': 'Delete',

      // Add transaction
      'add_list': 'Add List',
      'money_list': 'Money List',
      'money_position': 'Money Position',
      'category': 'Category',
      'save': 'Save',

      // Transfer
      'transfer': 'Transfer',
      'alternate': 'Alternate',
      'anonymous': 'Anonymous',

      // Record detail
      'money_list_label': 'Money List',
      'money_position_label': 'Money Position',
      'group': 'Group',
      'date_label': 'Date',

      // Notebook
      'notebook': 'NoteBook',
      'notes_subtitle': 'Personal notes and reminders',
      'add': 'Add',
      'items': 'Items',
      'recorded_on': 'Recorded on',
      'confirm_delete': 'Confirm Delete',
      'confirm_delete_note': 'Are you sure you want to delete the note',
      'note_deleted': 'Note deleted successfully',
      'noRecord': 'No Records.',
      'addNotePrompt':
          'Start recording memories or important notes easily by clicking the add note button below.',

      // Action feedback
      'added_success': 'Added successfully',
      'updated_success': 'Updated successfully',
      'deleted_success': 'Deleted successfully',
      'delete_confirm': 'Are you sure you want to delete this record?',

      // Popup
      'unallocated_funds': 'Unallocated Funds',
      'all_money_in_group': 'All money in the group',
      'this_is': 'This is ',
      'out_of_total': ' out of the total',
      'target': 'Target',

      // General
      'cancel': 'Cancel',
      'confirm': 'Confirm',

      // Please enter
      'please_enter_amount': '*Please enter an amount',

      // Group settings
      'icon': 'Icon',
      'color': 'Color',

      // Notebook actions
      'pin': 'Pin',
      'unpin': 'Unpin',

      // Transaction fields
      'title': 'Title',
      'content': 'Content',

      // Note editor
      'addNote': 'Add Note',
      'note_color': 'Select Color Tag',
      'enter_title': 'Please enter a title',
      'enter_note_title': 'Enter note title...',
      'enter_note_content': 'Enter note content...',
      'enter_content': 'Please enter note content',

      // Note categories
      'category_all': 'All',
      'category_general': 'General',
      'category_finance': 'Finance',
      'category_goals': 'Goals',

      // Category suggestions
      'category_food': 'Food',
      'category_transport': 'Transport',
      'category_shopping': 'Shopping',
      'category_entertainment': 'Entertainment',
      'category_bills': 'Bills',

      // Note editor
      'edit_note': 'Edit Note',
      'save_changes': 'Save Changes',
      'create_note': 'Create Note',

      // Group settings
      'enable_savings_goal': 'Enable Savings Goal',
      'savings_goal_amount': 'Savings Goal Amount',

      // Month abbreviations
      'month_jan': 'Jan',
      'month_feb': 'Feb',
      'month_mar': 'Mar',
      'month_apr': 'Apr',
      'month_may': 'May',
      'month_jun': 'Jun',
      'month_jul': 'Jul',
      'month_aug': 'Aug',
      'month_sep': 'Sep',
      'month_oct': 'Oct',
      'month_nov': 'Nov',
      'month_dec': 'Dec',
    },

    // Thai
    'th': {
      // Header / Menu
      'edit_group': 'แก้ไขกลุ่ม',
      'dark_theme': 'โหมดมืด',
      'change_language': 'เปลี่ยนภาษา',
      'change_currency': 'เปลี่ยนสกุลเงิน',
      'about': 'เกี่ยวกับ',
      'app_version': 'เวอร์ชั่น',
      'app_description': '        แอปพลิเคชันจัดการการประวัติรายรับ-รายจ่าย พร้อมบอกแนวโน้มการใช้จ่ายช้วยให้คุณสามารถวางแผนการเงินได้ดีขึ้น ในด้านความปลอดภัย เราได้จัดการข้อมูลโดยการเก็บไว้ในเครื่องของคุณเท่านั้น',
      'developer': 'ผู้พัฒนา',

      // Language names
      'lang_thai': 'ไทย',
      'lang_english': 'อังกฤษ',
      'lang_chinese': 'จีน',

      // Currency names
      'currency_baht': 'บาทไทย (\u0e3f)',
      'currency_dollar': 'ดอลลาร์สหรัฐ (\$)',
      'currency_yuan': 'หยวนจีน (¥)',

      // Dashboard
      'total_balance': 'ยอดรวมทั้งหมด',
      'bank': 'ธนาคาร',
      'cash': 'เงินสด',
      'income': 'รายรับ',
      'expense': 'รายจ่าย',
      'monthly_income': 'รายรับรายเดือน',
      'monthly_expense': 'รายจ่ายรายเดือน',
      'unallocated': 'ยังไม่จัดสรร',
      'transactions': 'รายการ',
      'from': 'จาก',

      // Charts
      'dashboard': 'แดชบอร์ด',
      'view_stats': 'ดูสถิติของคุณในรายละเอียด',
      'data_for_day': 'ข้อมูลวันนี้',
      'income_expense_by_category': 'รายรับและรายจ่ายตามหมวดหมู่',
      'monthly_data': 'ข้อมูลรายเดือน',
      'net': 'สุทธิ',
      'not_enough_data': 'ไม่มีข้อมูล',

      // Record screen
      'record': 'บันทึก',
      'transaction_history': 'ประวัติธุรกรรม',
      'all': 'ทั้งหมด',
      'search': 'ค้นหา',
      'no_records': 'ไม่พบรายการ',
      'amount': 'จำนวนเงิน',
      'position': 'ตำแหน่ง',
      'date': 'วันที่',
      'view': 'ดู',
      'edit': 'แก้ไข',
      'delete': 'ลบ',

      // Add transaction
      'add_list': 'เพิ่มรายการ',
      'money_list': 'ประเภทเงิน',
      'money_position': 'ตำแหน่งเงิน',
      'category': 'หมวดหมู่',
      'save': 'บันทึก',

      // Transfer
      'transfer': 'โอน',
      'alternate': 'สลับ',
      'anonymous': 'ไม่ระบุชื่อ',

      // Record detail
      'money_list_label': 'ประเภทเงิน',
      'money_position_label': 'ตำแหน่งเงิน',
      'group': 'กลุ่ม',
      'date_label': 'วันที่',

      // Notebook
      'notebook': 'สมุดโน้ต',
      'notes_subtitle': 'บันทึกและการแจ้งเตือนส่วนตัว',
      'add': 'เพิ่ม',
      'items': 'รายการ',
      'recorded_on': 'บันทึกเมื่อ',
      'confirm_delete': 'ยืนยันการลบ',
      'confirm_delete_note': 'คุณแน่ใจหรือไม่ว่าต้องการลบโน้ต',
      'note_deleted': 'ลบโน้ตสำเร็จ',
      'noRecord': 'ไม่พบรายการ',
      'addNotePrompt': 'เริ่มบันทึกความทรงจำหรือบันทึกสำคัญได้ง่ายๆ โดยการคลิกที่ปุ่มเพิ่มโน้ตด้านล่าง',

      // Action feedback
      'added_success': 'เพิ่มสำเร็จ',
      'updated_success': 'อัปเดตสำเร็จ',
      'deleted_success': 'ลบสำเร็จ',
      'delete_confirm': 'คุณแน่ใจหรือไม่ว่าต้องการลบรายการนี้?',

      // Popup
      'unallocated_funds': 'เงินที่ยังไม่จัดสรร',
      'all_money_in_group': 'เงินทั้งหมดในกลุ่ม',
      'this_is': 'นี่คือ ',
      'out_of_total': ' จากทั้งหมด',
      'target': 'เป้าหมาย',

      // General
      'cancel': 'ยกเลิก',
      'confirm': 'ยืนยัน',

      // Please enter
      'please_enter_amount': '*กรุณาใส่จำนวนเงิน',

      // Group settings
      'icon': 'ไอคอน',
      'color': 'สี',

      // Notebook actions
      'pin': 'ปักหมุด',
      'unpin': 'ยกเลิกปักหมุด',

      // Transaction fields
      'title': 'ชื่อเรื่อง',
      'content': 'เนื้อหา',

      // Note editor
      'addNote': 'เพิ่มโน้ต',
      'note_color': 'เลือกสีแท็ก',
      'enter_title': 'กรุณาใส่ชื่อเรื่อง',
      'enter_note_title': 'ใส่ชื่อโน้ต...',
      'enter_note_content': 'ใส่เนื้อหาโน้ต...',
      'enter_content': 'กรุณาใส่เนื้อหา',

      // Note categories
      'category_all': 'ทั้งหมด',
      'category_general': 'ทั่วไป',
      'category_finance': 'การเงิน',
      'category_goals': 'เป้าหมาย',

      // Category suggestions
      'category_food': 'อาหาร',
      'category_transport': 'การเดินทาง',
      'category_shopping': 'ช้อปปิ้ง',
      'category_entertainment': 'บันเทิง',
      'category_bills': 'บิล',

      // Note editor
      'edit_note': 'แก้ไขโน้ต',
      'save_changes': 'บันทึกการเปลี่ยนแปลง',
      'create_note': 'สร้างโน้ต',

      // Group settings
      'enable_savings_goal': 'เปิดใช้เป้าหมายการออม',
      'savings_goal_amount': 'จำนวนเงินเป้าหมายการออม',

      // Month abbreviations
      'month_jan': 'ม.ค.',
      'month_feb': 'ก.พ.',
      'month_mar': 'มี.ค.',
      'month_apr': 'เม.ย.',
      'month_may': 'พ.ค.',
      'month_jun': 'มิ.ย.',
      'month_jul': 'ก.ค.',
      'month_aug': 'ส.ค.',
      'month_sep': 'ก.ย.',
      'month_oct': 'ต.ค.',
      'month_nov': 'พ.ย.',
      'month_dec': 'ธ.ค.',
    },

    // Chinese (Simplified)
    'zh': {
      // Header / Menu
      'edit_group': '编辑分组',
      'dark_theme': '深色主题',
      'change_language': '更改语言',
      'change_currency': '更改货币',
      'about': '关于',
      'app_version': '版本',
      'app_description': '        款收支记账应用，可展示消费趋势，助您更高效地规划财务。在安全性方面，您的数据仅存储于您的设备中',
      'developer': '开发者',

      // Language names
      'lang_thai': '泰语',
      'lang_english': '英语',
      'lang_chinese': '中文',

      // Currency names
      'currency_baht': '泰铢 (\u0e3f)',
      'currency_dollar': '美元 (\$)',
      'currency_yuan': '人民币 (¥)',

      // Dashboard
      'total_balance': '总余额',
      'bank': '银行',
      'cash': '现金',
      'income': '收入',
      'expense': '支出',
      'monthly_income': '月收入',
      'monthly_expense': '月支出',
      'unallocated': '未分配',
      'transactions': '笔',
      'from': '来自',

      // Charts
      'dashboard': '仪表盘',
      'view_stats': '查看您的详细统计数据',
      'data_for_day': '今日数据',
      'income_expense_by_category': '按类别的收支情况',
      'monthly_data': '月度数据',
      'net': '净额',
      'not_enough_data': '没有足够数据',

      // Record screen
      'record': '记录',
      'transaction_history': '交易历史',
      'all': '全部',
      'search': '搜索',
      'no_records': '未找到记录',
      'amount': '金额',
      'position': '位置',
      'date': '日期',
      'view': '查看',
      'edit': '编辑',
      'delete': '删除',

      // Add transaction
      'add_list': '添加条目',
      'money_list': '资金类型',
      'money_position': '资金位置',
      'category': '分类',
      'save': '保存',

      // Transfer
      'transfer': '转账',
      'alternate': '切换',
      'anonymous': '匿名',

      // Record detail
      'money_list_label': '资金类型',
      'money_position_label': '资金位置',
      'group': '分组',
      'date_label': '日期',

      // Notebook
      'notebook': '笔记本',
      'notes_subtitle': '个人笔记和提醒',
      'add': '添加',
      'items': '条',
      'recorded_on': '记录于',
      'confirm_delete': '确认删除',
      'confirm_delete_note': '您确定要删除笔记吗',
      'note_deleted': '笔记删除成功',
      'noRecord': '未找到记录',
      'addNotePrompt': '开始记录回忆或重要笔记，只需点击下方的添加笔记按钮。',

      // Action feedback
      'added_success': '添加成功',
      'updated_success': '更新成功',
      'deleted_success': '删除成功',
      'delete_confirm': '您确定要删除此记录吗？',

      // Popup
      'unallocated_funds': '未分配资金',
      'all_money_in_group': '分组中的所有资金',
      'this_is': '占 ',
      'out_of_total': ' 的总额',
      'target': '目标',

      // General
      'cancel': '取消',
      'confirm': '确认',

      // Please enter
      'please_enter_amount': '*请输入金额',

      // Group settings
      'icon': '图标',
      'color': '颜色',

      // Notebook actions
      'pin': '置顶',
      'unpin': '取消置顶',

      // Transaction fields
      'title': '标题',
      'content': '内容',

      // Note editor
      'addNote': '添加笔记',
      'note_color': '选择颜色标签',
      'enter_title': '请输入标题',
      'enter_note_title': '输入笔记标题...',
      'enter_note_content': '输入笔记内容...',
      'enter_content': '请输入笔记内容',

      // Note categories
      'category_all': '全部',
      'category_general': '一般',
      'category_finance': '财务',
      'category_goals': '目标',

      // Category suggestions
      'category_food': '餐饮',
      'category_transport': '交通',
      'category_shopping': '购物',
      'category_entertainment': '娱乐',
      'category_bills': '账单',

      // Note editor
      'edit_note': '编辑笔记',
      'save_changes': '保存更改',
      'create_note': '创建笔记',

      // Group settings
      'enable_savings_goal': '启用储蓄目标',
      'savings_goal_amount': '储蓄目标金额',

      // Month abbreviations
      'month_jan': '1月',
      'month_feb': '2月',
      'month_mar': '3月',
      'month_apr': '4月',
      'month_may': '5月',
      'month_jun': '6月',
      'month_jul': '7月',
      'month_aug': '8月',
      'month_sep': '9月',
      'month_oct': '10月',
      'month_nov': '11月',
      'month_dec': '12月',
    },
  };

  String translate(String key) {
    return _translations[languageCode]?[key] ??
        _translations['en']?[key] ??
        key;
  }

  // Header / Menu
  String get editGroup => translate('edit_group');
  String get darkTheme => translate('dark_theme');
  String get changeLanguage => translate('change_language');
  String get changeCurrency => translate('change_currency');
  String get about => translate('about');
  String get appVersion => translate('app_version');
  String get appDescription => translate('app_description');
  String get developer => translate('developer');
  // Language names
  String get langThai => translate('lang_thai');
  String get langEnglish => translate('lang_english');
  String get langChinese => translate('lang_chinese');
  // Currency names
  String get currencyBaht => translate('currency_baht');
  String get currencyDollar => translate('currency_dollar');
  String get currencyYuan => translate('currency_yuan');
  // Dashboard
  String get totalBalance => translate('total_balance');
  String get bank => translate('bank');
  String get cash => translate('cash');
  String get income => translate('income');
  String get expense => translate('expense');
  String get monthlyIncome => translate('monthly_income');
  String get monthlyExpense => translate('monthly_expense');
  String get unallocated => translate('unallocated');
  String get transactions => translate('transactions');
  String get from => translate('from');
  // Charts
  String get dashboard => translate('dashboard');
  String get viewStats => translate('view_stats');
  String get dataForDay => translate('data_for_day');
  String get incomeExpenseByCategory => translate('income_expense_by_category');
  String get monthlyData => translate('monthly_data');
  String get net => translate('net');
  String get notEnoughData => translate('not_enough_data');
  // Record screen
  String get record => translate('record');
  String get transactionHistory => translate('transaction_history');
  String get all => translate('all');
  String get search => translate('search');
  String get noRecords => translate('no_records');
  String get amount => translate('amount');
  String get position => translate('position');
  String get date => translate('date');
  String get view => translate('view');
  String get edit => translate('edit');
  String get delete => translate('delete');
  // Add transaction
  String get addList => translate('add_list');
  String get moneyList => translate('money_list');
  String get moneyPosition => translate('money_position');
  String get category => translate('category');
  String get save => translate('save');
  // Transfer
  String get transfer => translate('transfer');
  String get alternate => translate('alternate');
  String get anonymous => translate('anonymous');
  // Record detail
  String get moneyListLabel => translate('money_list_label');
  String get moneyPositionLabel => translate('money_position_label');
  String get group => translate('group');
  String get dateLabel => translate('date_label');
  // Notebook
  String get notebook => translate('notebook');
  String get notesSubtitle => translate('notes_subtitle');
  String get add => translate('add');
  String get items => translate('items');
  String get recordedOn => translate('recorded_on');
  String get confirmDelete => translate('confirm_delete');
  String get confirmDeleteNote => translate('confirm_delete_note');
  String get noteDeleted => translate('note_deleted');
  String get noRecord => translate('noRecord');
  String get addNotePrompt => translate('addNotePrompt');
  // Action feedback
  String get addedSuccess => translate('added_success');
  String get updatedSuccess => translate('updated_success');
  String get deletedSuccess => translate('deleted_success');
  String get deleteConfirm => translate('delete_confirm');
  // Popup
  String get unallocatedFunds => translate('unallocated_funds');
  String get allMoneyInGroup => translate('all_money_in_group');
  String get thisIs => translate('this_is');
  String get outOfTotal => translate('out_of_total');
  String get target => translate('target');
  // General
  String get cancel => translate('cancel');
  String get confirm => translate('confirm');
  String get pleaseEnterAmount => translate('please_enter_amount');
  // Group settings
  String get icon => translate('icon');
  String get color => translate('color');
  // Notebook actions
  String get pin => translate('pin');
  String get unpin => translate('unpin');
  // Transaction fields
  String get title => translate('title');
  String get content => translate('content');
  // Note editor
  String get addNote => translate('addNote');
  String get noteColor => translate('note_color');
  String get enterTitle => translate('enter_title');
  String get enterNoteTitle => translate('enter_note_title');
  String get enterNoteContent => translate('enter_note_content');
  String get enterContent => translate('enter_content');
  // Note categories
  String get categoryAll => translate('category_all');
  String get categoryGeneral => translate('category_general');
  String get categoryFinance => translate('category_finance');
  String get categoryGoals => translate('category_goals');
  // Category suggestions
  String get categoryFood => translate('category_food');
  String get categoryTransport => translate('category_transport');
  String get categoryShopping => translate('category_shopping');
  String get categoryEntertainment => translate('category_entertainment');
  String get categoryBills => translate('category_bills');
  // Note editor
  String get editNote => translate('edit_note');
  String get saveChanges => translate('save_changes');
  String get createNote => translate('create_note');
  // Group settings
  String get enableSavingsGoal => translate('enable_savings_goal');
  String get savingsGoalAmount => translate('savings_goal_amount');
  // Month abbreviations
  String get monthJan => translate('month_jan');
  String get monthFeb => translate('month_feb');
  String get monthMar => translate('month_mar');
  String get monthApr => translate('month_apr');
  String get monthMay => translate('month_may');
  String get monthJun => translate('month_jun');
  String get monthJul => translate('month_jul');
  String get monthAug => translate('month_aug');
  String get monthSep => translate('month_sep');
  String get monthOct => translate('month_oct');
  String get monthNov => translate('month_nov');
  String get monthDec => translate('month_dec');
}
