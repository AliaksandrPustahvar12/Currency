//
//  ContentView.swift
//  Currency
//
//  Created by Aliaksandr Pustahvar on 27.06.23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject private var viewModel = CurrencyViewModel()
    
    @State private var valutes = [String]()
    
    @State var fromAmount: String
    @State var fromValute = "USD"
    @State var toAmount: Double
    @State var toValute = "EUR"
    @State var result: String
    @FocusState private var isFocused: Bool
    
    
    var body: some View {
        ZStack {
            Color(.systemGray6).ignoresSafeArea()
            VStack {
                if valutes.isEmpty {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .transition(.opacity)
                } else {
                    VStack {
                        
                        Text("Currency converter")
                            .font(.system(size: 34, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(.darkGray))
                            .padding(.top, 50)
                        
                        
                        HStack {
                            Text("Enter amount:")
                                .font(.system(size: 16, weight: .medium))
                            
                            TextField("Amount", text:  $fromAmount)
                                .focused($isFocused)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .backgroundStyle(Color(.systemGray6))
                            
                            Button("Submit") {
                                isFocused = false
                            }
                            .font(.system(size: 14, weight: .light))
                        }
                        .foregroundColor(Color(.darkGray))
                        .padding(.horizontal, 10)
                        .padding(.bottom, 20)
                        .padding(.top, 170)
                        
                        
                        HStack {
                            
                            Text("From")
                                .font(.system(size: 16, weight: .medium))
                            
                            Picker(selection: $fromValute) {
                                ForEach(valutes, id: \.self) {
                                    Text($0)
                                }
                            } label: {
                                Text("Choose valute")
                            }
                            .tint(Color(.darkGray))
                            .padding(.trailing, 10)
                            
                            
                            Text("To")
                                .font(.system(size: 16, weight: .medium))
                                .padding(.leading, 10)
                            
                            Picker(selection: $toValute) {
                                ForEach(valutes, id: \.self) {
                                    Text($0)
                                }
                            } label: {
                                Text("Choose valute")
                            }
                            .tint(Color(.darkGray))
                        }
                        .foregroundColor(Color(.darkGray))
                        .padding(.bottom, 20)
                        
                        Button {
                            Task {
                                isFocused = false
                                if let double = Double(fromAmount) {
                                    if let amount = await viewModel.getResult(from: fromValute, to: toValute, amount: double) {
                                        result = String(format: "%.2f", amount)
                                    }
                                }
                            }
                        } label: {
                            Text("Convert")
                                .padding(.horizontal, 30)
                                .foregroundColor(Color(.darkGray))
                                .font(.system(size: 24, weight: .medium))
                            
                        }
                        .buttonStyle(.bordered)
                        .cornerRadius(20)
                        .backgroundStyle(Color(.systemGray2))
                        .padding(.bottom, 20)
                        
                        HStack {
                            if result != "" {
                                Text(result)
                                    .font(.system(size: 24, weight: .medium))
                                
                                Text(toValute)
                                    .font(.system(size: 24, weight: .light))
                            }
                        }
                    }
                    .alert("Network error", isPresented: $viewModel.isError, actions: {
                        Button("OK", role: .cancel) {
                            viewModel.isError = false
                        }
                    }, message: {
                        Text("Try one more time")
                    })
                    Spacer()
                }
            }
            .task {
                await valutes = viewModel.getValutes()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(fromAmount: "", toAmount: 0, result: "")
    }
}
