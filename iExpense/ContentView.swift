//
//  ContentView.swift
//  iExpense
//
//  Created by Josh Belmont on 10/20/20.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    private(set) var id = UUID()
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items"){
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items){
                self.items = decoded
                return
            }
        }
        self.items = []
    }
    
    
    @Published var items = [ExpenseItem](){
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items){
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false

    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }

                            Spacer()
                            Text("$\(item.amount)")
                                .foregroundColor(getColorForValue(for: item.amount))
                        }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarItems( leading: EditButton(), trailing:
                Button(action: {
                    self.showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                }
            )
        }
        .sheet(isPresented: $showingAddExpense){
            AddView(expenses: self.expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet){
        expenses.items.remove(atOffsets: offsets)
    }
    
    func getColorForValue(for amount: Int) -> Color {
        if(amount < 10){
            return Color.blue
        } else if ( amount < 100 ){
            return Color.green
        } else {
            return Color.red
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
