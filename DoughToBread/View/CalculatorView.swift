//import SwiftUI
//
//// Represents a budget item with a unique ID, name, and amount
//struct BudgetItem: Identifiable, Codable {
//    var id = UUID() // Unique identifier for each item
//    var name: String // Name of the budget category
//    var amount: Double // Amount spent on the category
//}
//
//// ViewModel to manage budget-related operations
//class BudgetViewModel: ObservableObject {
//    @Published var budgetItems: [BudgetItem] = [] // List of budget items
//    @Published var income: Double = 0 // User's monthly income
//    @Published var totalExpenses: Double = 0 // Total calculated expenses
//    
//    // Predefined categories for the budget
//    let predefinedCategories = [
//        "Housing", "Utilities", "Food", "Transportation", "Clothing",
//        "Medical", "Savings", "Charity", "Other"
//    ]
//    
//    private let storageKey = "budgetItems" // Key for saving data in UserDefaults
//    
//    init() {
//        loadBudgetItems() // Load previously saved budget items on initialization
//    }
//    
//    // Adds a new budget item to the list
//    func addItem(name: String, amount: Double) {
//        let newItem = BudgetItem(name: name, amount: amount)
//        budgetItems.append(newItem)
//        saveBudgetItems() // Save the updated list to storage
//        calculateTotalExpenses() // Update total expenses
//    }
//    
//    // Deletes a budget item from the list
//    func deleteItem(at offsets: IndexSet) {
//        budgetItems.remove(atOffsets: offsets)
//        saveBudgetItems() // Save the updated list to storage
//        calculateTotalExpenses() // Update total expenses
//    }
//    
//    // Calculates the total expenses from all budget items
//    func calculateTotalExpenses() {
//        totalExpenses = budgetItems.reduce(0) { $0 + $1.amount }
//    }
//    
//    // Saves the budget items to persistent storage
//    func saveBudgetItems() {
//        if let encoded = try? JSONEncoder().encode(budgetItems) {
//            UserDefaults.standard.set(encoded, forKey: storageKey)
//        }
//    }
//    
//    // Loads the budget items from persistent storage
//    func loadBudgetItems() {
//        if let savedItems = UserDefaults.standard.object(forKey: storageKey) as? Data {
//            if let decodedItems = try? JSONDecoder().decode([BudgetItem].self, from: savedItems) {
//                budgetItems = decodedItems
//                calculateTotalExpenses() // Update total expenses after loading
//            }
//        }
//    }
//}
//
//// The main view for managing the budget calculator
//struct CalculatorView: View {
//    @StateObject private var budgetViewModel = BudgetViewModel() // ViewModel for managing budget data
//    @StateObject private var calculatorViewModel = CalculatorViewModel() // ViewModel for managing calculator usage (assumed)
//    @State private var selectedCategory: String = "Housing" // Default selected category
//    @State private var itemAmount: String = "" // Input field for the amount
//
//    var body: some View {
//        VStack {
//            // Input for user's monthly income
//            Text("Enter your Monthly Income")
//                .font(.headline)
//                .padding(.top)
//            
//            TextField("Monthly Income", value: $budgetViewModel.income, formatter: NumberFormatter())
//                .keyboardType(.decimalPad)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//            
//            // Section for selecting a budget category and adding expenses
//            Text("Budget Categories")
//                .font(.headline)
//                .padding()
//            
//            Picker("Select Category", selection: $selectedCategory) {
//                ForEach(budgetViewModel.predefinedCategories, id: \.self) { category in
//                    Text(category).tag(category)
//                }
//            }
//            .pickerStyle(MenuPickerStyle())
//            
//            TextField("Amount", text: $itemAmount)
//                .keyboardType(.decimalPad)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//            
//            // Button to add a new budget item
//            Button(action: {
//                if let amount = Double(itemAmount) {
//                    budgetViewModel.addItem(name: selectedCategory, amount: amount)
//                    itemAmount = "" // Clear the input field
//                }
//                calculatorViewModel.incrementCalculatorUse() // Track usage
//            }) {
//                Text("Add Item")
//                    .padding()
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(5)
//            }
//            .padding()
//            
//            // List of all budget items with delete functionality
//            List {
//                ForEach(budgetViewModel.budgetItems) { item in
//                    HStack {
//                        Text(item.name)
//                        Spacer()
//                        Text("$\(item.amount, specifier: "%.2f")")
//                        Button(action: {
//                            if let index = budgetViewModel.budgetItems.firstIndex(where: { $0.id == item.id }) {
//                                budgetViewModel.deleteItem(at: IndexSet(integer: index))
//                            }
//                        }) {
//                            Text("X")
//                                .foregroundColor(.red)
//                                .padding(.leading)
//                        }
//                    }
//                }
//            }
//            
//            // Display total expenses and potential savings
//            Text("Total Expenses: $\(budgetViewModel.totalExpenses, specifier: "%.2f")")
//                .font(.headline)
//                .padding()
//            
//            if budgetViewModel.income > 0 {
//                Text("Income: $\(budgetViewModel.income, specifier: "%.2f")")
//                    .font(.headline)
//                    .padding()
//                
//                let savings = budgetViewModel.income - budgetViewModel.totalExpenses
//                Text("Potential Savings: $\(savings, specifier: "%.2f")")
//                    .foregroundColor(savings >= 0 ? .green : .red)
//                    .padding()
//                
//                // Display percentage breakdown of expenses by category
//                ForEach(budgetViewModel.budgetItems) { item in
//                    let percentage = (item.amount / budgetViewModel.income) * 100
//                    Text("\(item.name): \(percentage, specifier: "%.2f")% of Income")
//                }
//            }
//            
//            Spacer() // Push content to the top
//        }
//        .padding()
//    }
//}


import SwiftUI
 
import Charts
 
struct BudgetExpense: Identifiable {
    let id = UUID()
    var category: String
    var amount: Double
}
 
class ExpenseViewModel: ObservableObject {
 
    @Published var income: String = ""
 
    @Published var predefinedExpenses: [BudgetExpense] = [
 
        BudgetExpense(category: "Housing", amount: 0),
 
        BudgetExpense(category: "Utilities", amount: 0),
 
        BudgetExpense(category: "Food", amount: 0),
 
        BudgetExpense(category: "Transportation", amount: 0),
 
        BudgetExpense(category: "Clothing", amount: 0),
 
        BudgetExpense(category: "Medical", amount: 0),
 
        BudgetExpense(category: "Charity", amount: 0)
 
    ]
 
    @Published var additionalExpenses: [BudgetExpense] = []
 
    @Published var totalExpenses: Double = 0
 
    @Published var expenseBreakdown: [String: Double] = [:]
 
    // Add a new custom expense
    func addCustomExpense() {
        additionalExpenses.append(BudgetExpense(category: "New Expense", amount: 0))
    }
 
    // Calculate total expenses and breakdown
    func calculateExpenses() {
        let allExpenses = predefinedExpenses + additionalExpenses
        totalExpenses = allExpenses.reduce(0) { $0 + $1.amount }
 
        expenseBreakdown = allExpenses.reduce(into: [:]) { breakdown, expense in
            breakdown[expense.category] = expense.amount
        }
    }
}
 
struct CalculatorView: View {
    @StateObject private var calculatorViewModel = CalculatorViewModel()
    @StateObject private var expenseViewModel = ExpenseViewModel()
    @State private var showChart = false
 
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Monthly Income")
                    .font(.headline)
 
                TextField("Enter Income", text: $expenseViewModel.income)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)
 
                Text("Monthly Expenses")
                    .font(.headline)
 
                // Predefined Expenses
                ForEach($expenseViewModel.predefinedExpenses) { $expense in
                    HStack {
                        Text(expense.category)
                        Spacer()
                        TextField("Amount", value: $expense.amount, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
 
                // Additional Expenses
                ForEach($expenseViewModel.additionalExpenses) { $expense in
                    HStack {
                        TextField("Custom Category", text: $expense.category)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Spacer()
                        TextField("Amount", value: $expense.amount, formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
 
                Button(action: {
                    expenseViewModel.addCustomExpense()
                }) {
                    Text("Add Expense")
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                }
                .padding(.vertical)
 
                // Calculate Expenses Button
                Button(action: {
                    expenseViewModel.calculateExpenses()
                    calculatorViewModel.incrementCalculatorUse()
                    showChart = true
                }) {
                    Text("Calculate Total Expenses")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                .padding(.bottom)
 
                if showChart {
                    ExpenseSummaryView(
                        totalExpenses: expenseViewModel.totalExpenses,
                        income: Double(expenseViewModel.income) ?? 0,
                        expenseBreakdown: expenseViewModel.expenseBreakdown
                    )
                }
            }
            .padding()
        }
    }
}
 
struct ExpenseSummaryView: View {
 
    var totalExpenses: Double
    var income: Double
    var expenseBreakdown: [String: Double]
 
    var body: some View {
        VStack(alignment: .leading) {
            Text("Summary")
                .font(.headline)
                .padding(.vertical)
 
            if income > 0 {
                if totalExpenses > income {
                    Text("You are spending more than your income. Try to cut back on expenses.")
                        .foregroundColor(.red)
                } else if income - totalExpenses < 100 {
                    Text("You are close to your income limit. Be cautious with your spending.")
                        .foregroundColor(.orange)
                } else {
                    Text("You are managing your expenses well!")
                        .foregroundColor(.green)
                }
            }
 
            Text("Expense Breakdown")
                .font(.headline)
                .padding(.vertical)
 
            PieChartView(data: expenseBreakdown, total: totalExpenses)
                .frame(height: 300)
 
            ForEach(Array(expenseBreakdown.sorted(by: { $0.value > $1.value })), id: \.key) { item in
                HStack {
                    Text(item.key)
                    Spacer()
                    Text("$\(item.value, specifier: "%.2f")")
                }
            }
        }
    }
}
 
// Simple Pie Chart View using Charts framework
struct PieChartView: View {
 
    var data: [String: Double]
    var total: Double
 
    var body: some View {
        Chart {
            ForEach(Array(data.keys.sorted()), id: \.self) { key in
                if let value = data[key] {
                    SectorMark(
                        angle: .value("Amount", value / total),
                        innerRadius: .ratio(0.5)
                    )
                    .foregroundStyle(by: .value("Category", key))
                }
            }
        }
    }
}
