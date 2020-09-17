//
//  CompanyDetailView.swift
//  Weed delivery
//
//  Created by Ilya Senchukov on 14.09.2020.
//  Copyright © 2020 Ilya Senchukov. All rights reserved.
//

import SwiftUI

struct CompanyDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @State var productDetailsPresented = false
    @State var alertPresented = false
    
    var company: Company
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .trailing) {
                    Image("close")
                        .resizable()
                        
                        .frame(width: 30, height: 30)
                        .offset(x: -20, y: 20)
                        .onTapGesture {
                            self.close()
                        }
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            
                            Image(self.company.imageName)
                                .resizable()
                                .frame(height: 200)
                                
                            
                            Text(self.company.name)
                                .font(.title)
                            .padding(10)
                            
                            Divider()
                            
                            Text("Products")
                                .font(.system(size: 20))
                                .padding(10)
                            if self.company.products != nil {
                                ProductsListView(products: self.company.products)
                            } else {
                                Text("No products available")
                            }
                        }
                        .offset(y: 20)
                        Spacer(minLength: 20)
                    }
                    .edgesIgnoringSafeArea(.top)
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
                    .frame(height: geometry.size.height - geometry.safeAreaInsets.bottom)
                    .alert(isPresented: self.$alertPresented) {
                        Alert(
                            title: Text("Are you sure you want to leave?"),
                            primaryButton: .default(Text("Yes"), action: {
                                self.leaveView()
                            }), secondaryButton: .default(Text("Leave here")
                        ))
                    }
                    
                }
                
                CartButton()
                    
                    .frame(width: geometry.size.width - 65)
                    
                    .padding(25)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .position( x: geometry.size.width / 2, y: geometry.size.height - 45)
                    .onTapGesture {
                            self.productDetailsPresented = true
                        }
                    .sheet(isPresented: self.$productDetailsPresented) {
                            CartView()
                        }
            }
        }
    }
    
    func leaveView() {
        appDelegate.cart = [] 
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func close() {
        
        let cart = appDelegate.cart

        if cart.count > 0 {
            self.alertPresented = true
        } else {
            self.presentationMode.wrappedValue.dismiss()
        }
        
    }
}

struct CompanyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CompanyDetailView(company: Company(
            id: 1,
            name: "Test company",
            imageName: "mcdonalds",
            products:
                [Product(id: 1, name: "Big Mac Menu", price: 100.0),
                Product(id: 1, name: "Big Mac Menu", price: 100.0),
                Product(id: 1, name: "Big Mac Menu", price: 100.0),
                Product(id: 1, name: "Big Mac Menu", price: 100.0)]
        ))
    }
}
