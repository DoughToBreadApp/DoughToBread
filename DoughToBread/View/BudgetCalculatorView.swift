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



struct BudgetCalculatorView: View {

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

            

            ForEach(expenseBreakdown.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in

                HStack {

                    Text(key)

                    Spacer()

                    Text("$\(value, specifier: "%.2f")")

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

            ForEach(data.keys.sorted(), id: \.self) { key in

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