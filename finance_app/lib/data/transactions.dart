final List<Map<String, dynamic>> septTransactions = [
  // ===== Housing & Utilities (₪3,970) =====
  {"id": "2025-09-01-RENT", "date": "2025-09-01", "category": "Housing & Utilities", "description": "Rent - 3BR apartment", "amount": 3200, "paymentMethod": "bank_transfer"},
  {"id": "2025-09-15-UTILS", "date": "2025-09-15", "category": "Housing & Utilities", "description": "Electricity & Water (bi-monthly)", "amount": 650, "paymentMethod": "credit_card"},
  {"id": "2025-09-18-INET", "date": "2025-09-18", "category": "Housing & Utilities", "description": "Internet (fiber) monthly", "amount": 120, "paymentMethod": "credit_card"},

  // ===== Food & Groceries (₪1,764) =====
  {"id": "2025-09-07-SUP1", "date": "2025-09-07", "category": "Food & Groceries", "description": "Supermarket (weekly shop)", "amount": 600, "paymentMethod": "credit_card"},
  {"id": "2025-09-14-SUP2", "date": "2025-09-14", "category": "Food & Groceries", "description": "Supermarket (weekly shop)", "amount": 700, "paymentMethod": "credit_card"},
  {"id": "2025-09-08-MINI", "date": "2025-09-08", "category": "Food & Groceries", "description": "Minimarket top-up", "amount": 82, "paymentMethod": "cash"},
  {"id": "2025-09-09-BAK1", "date": "2025-09-09", "category": "Food & Groceries", "description": "Bakery & milk", "amount": 83, "paymentMethod": "cash"},
  {"id": "2025-09-10-PROD", "date": "2025-09-10", "category": "Food & Groceries", "description": "Produce stand", "amount": 70, "paymentMethod": "cash"},
  {"id": "2025-09-11-DAIR", "date": "2025-09-11", "category": "Food & Groceries", "description": "Dairy top-up", "amount": 46, "paymentMethod": "cash"},
  {"id": "2025-09-12-FRUT", "date": "2025-09-12", "category": "Food & Groceries", "description": "Fruit & veg", "amount": 58, "paymentMethod": "cash"},
  {"id": "2025-09-13-BRED", "date": "2025-09-13", "category": "Food & Groceries", "description": "Bread & basics", "amount": 61, "paymentMethod": "cash"},
  {"id": "2025-09-16-EGGS", "date": "2025-09-16", "category": "Food & Groceries", "description": "Eggs & staples", "amount": 64, "paymentMethod": "cash"},

  // ===== Transport (₪1,430) =====
  {"id": "2025-09-02-FUEL1", "date": "2025-09-02", "category": "Transport", "description": "Fuel fill-up", "amount": 240, "paymentMethod": "credit_card"},
  {"id": "2025-09-04-PASS", "date": "2025-09-04", "category": "Transport", "description": "Bus pass (monthly)", "amount": 300, "paymentMethod": "credit_card"},
  {"id": "2025-09-07-TAXI", "date": "2025-09-07", "category": "Transport", "description": "Taxi (errand)", "amount": 65, "paymentMethod": "cash"},
  {"id": "2025-09-08-FUEL2", "date": "2025-09-08", "category": "Transport", "description": "Fuel top-up", "amount": 200, "paymentMethod": "credit_card"},
  {"id": "2025-09-11-PARK1", "date": "2025-09-11", "category": "Transport", "description": "Parking", "amount": 20, "paymentMethod": "cash"},
  {"id": "2025-09-13-BUS1", "date": "2025-09-13", "category": "Transport", "description": "Bus fares", "amount": 40, "paymentMethod": "debit"},
  {"id": "2025-09-14-FUEL3", "date": "2025-09-14", "category": "Transport", "description": "Fuel fill-up", "amount": 250, "paymentMethod": "credit_card"},
  {"id": "2025-09-16-TAX2", "date": "2025-09-16", "category": "Transport", "description": "Taxi (late pickup)", "amount": 55, "paymentMethod": "cash"},
  {"id": "2025-09-18-FUEL4", "date": "2025-09-18", "category": "Transport", "description": "Fuel fill-up", "amount": 220, "paymentMethod": "credit_card"},
  {"id": "2025-09-20-BUS2", "date": "2025-09-20", "category": "Transport", "description": "Bus fares", "amount": 40, "paymentMethod": "debit"},

  // ===== Education & Childcare (₪1,800) =====
  {"id": "2025-09-05-KG", "date": "2025-09-05", "category": "Education & Childcare", "description": "Kindergarten fee", "amount": 800, "paymentMethod": "bank_transfer"},
  {"id": "2025-09-10-SUPPL", "date": "2025-09-10", "category": "Education & Childcare", "description": "School supplies & books", "amount": 600, "paymentMethod": "credit_card"},
  {"id": "2025-09-20-AFTER", "date": "2025-09-20", "category": "Education & Childcare", "description": "After-school program", "amount": 400, "paymentMethod": "debit"},

  // ===== Health (₪520) =====
  {"id": "2025-09-03-CLIN1", "date": "2025-09-03", "category": "Health", "description": "Clinic copay", "amount": 180, "paymentMethod": "debit"},
  {"id": "2025-09-12-PHARM", "date": "2025-09-12", "category": "Health", "description": "Pharmacy medication", "amount": 120, "paymentMethod": "credit_card"},
  {"id": "2025-09-18-DENT", "date": "2025-09-18", "category": "Health", "description": "Dental cleaning", "amount": 220, "paymentMethod": "credit_card"},

  // ===== Other (₪730) =====
  {"id": "2025-09-02-HH", "date": "2025-09-02", "category": "Other", "description": "Household items", "amount": 220, "paymentMethod": "credit_card"},
  {"id": "2025-09-14-CLOTH", "date": "2025-09-14", "category": "Other", "description": "Clothing", "amount": 160, "paymentMethod": "credit_card"},
  {"id": "2025-09-17-GIFT", "date": "2025-09-17", "category": "Other", "description": "Family gift", "amount": 210, "paymentMethod": "cash"},
  {"id": "2025-09-09-MOB", "date": "2025-09-09", "category": "Other", "description": "Mobile top-up", "amount": 140, "paymentMethod": "debit"},
];
