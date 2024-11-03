import SwiftUI

struct BudgetItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var amount: Double
}

class BudgetViewModel: ObservableObject {
    @Published var budgetItems: [BudgetItem] = []
    @Published var income: Double = 0
    @Published var totalExpenses: Double = 0
    
    let predefinedCategories = [
        "Housing", "Utilities", "Food", "Transportation", "Clothing",
        "Medical", "Savings", "Charity", "Other"
    ]
    
    private let storageKey = "budgetItems"
    
    init() {
        loadBudgetItems()
    }
    
    func addItem(name: String, amount: Double) {
        let newItem = BudgetItem(name: name, amount: amount)
        budgetItems.append(newItem)
        saveBudgetItems()
        calculateTotalExpenses()
    }
    
    func deleteItem(at offsets: IndexSet) {
        budgetItems.remove(atOffsets: offsets)
        saveBudgetItems()
        calculateTotalExpenses()
    }
    
    func calculateTotalExpenses() {
        totalExpenses = budgetItems.reduce(0) { $0 + $1.amount }
    }
    
    func saveBudgetItems() {
        if let encoded = try? JSONEncoder().encode(budgetItems) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    func loadBudgetItems() {
        if let savedItems = UserDefaults.standard.object(forKey: storageKey) as? Data {
            if let decodedItems = try? JSONDecoder().decode([BudgetItem].self, from: savedItems) {
                budgetItems = decodedItems
                calculateTotalExpenses()
            }
        }
    }
}

struct CalculatorView: View {
    @StateObject private var viewModel = BudgetViewModel()
    @State private var selectedCategory: String = "Housing"
    @State private var itemAmount: String = ""
    
    var body: some View {
        VStack {
            Text("Enter your Monthly Income")
                .font(.headline)
                .padding(.top)
            
            TextField("Monthly Income", value: $viewModel.income, formatter: NumberFormatter())
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Text("Budget Categories")
                .font(.headline)
                .padding()
            
            Picker("Select Category", selection: $selectedCategory) {
                ForEach(viewModel.predefinedCategories, id: \.self) { category in
                    Text(category).tag(category)
                }
            }
            .pickerStyle(MenuPickerStyle())
            
            TextField("Amount", text: $itemAmount)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: {
                if let amount = Double(itemAmount) {
                    viewModel.addItem(name: selectedCategory, amount: amount)
                    itemAmount = ""
                }
            }) {
                Text("Add Item")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .padding()
            
            List {
                ForEach(viewModel.budgetItems) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("$\(item.amount, specifier: "%.2f")")
                        Button(action: {
                            if let index = viewModel.budgetItems.firstIndex(where: { $0.id == item.id }) {
                                viewModel.deleteItem(at: IndexSet(integer: index))
                            }
                        }) {
                            Text("X")
                                .foregroundColor(.red)
                                .padding(.leading)
                        }
                    }
                }
            }
            
            Text("Total Expenses: $\(viewModel.totalExpenses, specifier: "%.2f")")
                .font(.headline)
                .padding()
            
            if viewModel.income > 0 {
                Text("Income: $\(viewModel.income, specifier: "%.2f")")
                    .font(.headline)
                    .padding()
                
                let savings = viewModel.income - viewModel.totalExpenses
                Text("Potential Savings: $\(savings, specifier: "%.2f")")
                    .foregroundColor(savings >= 0 ? .green : .red)
                    .padding()
                
                ForEach(viewModel.budgetItems) { item in
                    let percentage = (item.amount / viewModel.income) * 100
                    Text("\(item.name): \(percentage, specifier: "%.2f")% of Income")
                }
            }
            
            Spacer()
        }
        .padding()
    }
}
