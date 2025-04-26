class AppStrings {
  static const timedOutResponse =
      '{"errorCode":"CONNECTION_TIMED_OUT","values":{"param1":"Connection Timeout \\nPlease try again later"},"violations":null}';

  static const budgetItemLogs = 'budgetItemLogs';

  static const List<String> entryType = ['Expense', 'Income'];

  static const List<String> currencies = ['PHP', 'USD'];

  static const List<String> expenseCategories = [
    'Select an Expense Category',
    'Food',
    'Electricity',
    'Water Bill',
    'Internet',
    'Phone Bill',
    'Rent',
    'Transportation',
    'Insurance',
    'Medical',
    'Credit Card Payments',
    'Loan Repayments',
    'Entertainment',
    'Clothing',
    'Dining Out',
    'Education',
    'Childcare',
    'Pet Expenses',
    'Home Maintenance',
    'Personal Care',
    'Gifts'
  ];

  static const List<String> incomeCategories = [
    'Select an Income Category',
    'Salary',
    'Bonus',
    'Rebate',
    'Freelance Income',
    'Rental Income',
    'Interest from Bank',
    'Dividends',
    'Investments Returns',
    'Government Aid',
    'Pension',
    'Social Security',
    'Side Hustle',
    'Affiliate Earnings',
    'Business Profit',
    'Tips',
    'Royalties',
    'Sale of Items',
    'Refunds',
    'Inheritance',
    'Alimony'
  ];

  static const List<String> settingsThemes = ['light', 'dark'];

  static const String settingsTheme = 'settingsTheme';

  static const String settingsConversionRate = 'settingsConversionRate';
}
