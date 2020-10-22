//
//  AddView.swift
//  iExpense
//
//  Created by Josh Belmont on 10/21/20.
//

import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    @State private var formError = false
    
    @ObservedObject var expenses: Expenses
    @Environment(\.presentationMode) var presentationMode
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            VStack{
                Form {
                    TextField("Name", text: $name)
                    Picker("Type", selection: $type) {
                        ForEach(Self.types, id: \.self){
                            Text($0)
                        }
                    }
                    TextField("Amount", text: $amount)
                        .keyboardType(.numberPad)
                }
                .navigationBarTitle("Add new expense")
                .navigationBarItems(trailing: Button("Save") {
                    if let actualAmount = Int(self.amount) {
                        let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                        self.expenses.items.append(item)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    else {
                        formError.toggle()
                    }
                })
                .alert(isPresented: $formError, content: {
                    Alert(title: Text("Error"), message: Text("Amount must be a valid number and all fields must be filled").foregroundColor(.red), dismissButton: .default(Text("OK")))
                })
                
            }
            
        }
        
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
