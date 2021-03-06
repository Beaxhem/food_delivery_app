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
    @State var isOpened = false
    
    var company: Company
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(alignment: .leading) {
                    CloseBar()
                        .onTapGesture {
                            self.close()
                        }
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 5) {
                            
                            Image(self.company.imageName)
                                .resizable()
                                .frame(height: 200)
                                .background(Color.white)
                                
                            HStack {
                                Text(self.company.name)
                                    .font(.title)
                                    .padding(10)
                                    .padding(.bottom, 0)
                                
                                RatingView(rating: 4.5)
                                    .font(.title)
                            }
                            
                            
                            Text(self.company.description)
                                .padding(10)
                                .padding(.top, 0)
                                .frame(maxHeight: self.isOpened ? .infinity : 150)
                            
                            Button(action: {
                                self.isOpened.toggle()
                            }) {
                                Text(self.isOpened ? "Hide details" : "View details")
                                    .underline()
                            }
                            .buttonStyle(PlainButtonStyle())
                            .font(.footnote)
                            .padding(.leading, 10)
                            
                            
                            Divider()
                            
                            HStack {
                                VStack {
                                    Image(systemName: "map")
                                    Link("View on map", destination: URL(string: "https://maps.google.com/?daddr=" + self.company.name.lowercased())!)
                                        .lineLimit(0)
                                }.frame(minWidth: 0, maxWidth: .infinity)
                                
                                VStack {
                                    Image(systemName: "speedometer")
                                    Text("Fast")
                                }
                                .frame(minWidth: 0, maxWidth: .infinity)
                            }
                            .padding()
                            
                            Divider()
                            
                            Text("Products")
                                .font(.system(size: 30, weight: .bold))
                                .padding(10)
                            if self.company.products != nil {
                                ProductsListView(products: self.company.products)
                            } else {
                                Text("No products available")
                            }
                        }
                        
                        Spacer(minLength: 20)
                    }
                    
                    .navigationBarTitle("", displayMode: .inline)
                    .navigationBarHidden(true)
                    .frame(height: geometry.size.height - 100)
                    .alert(isPresented: self.$alertPresented) {
                        Alert(
                            title: Text("Are you sure you want to leave?"),
                            primaryButton: .default(Text("Yes"), action: {
                                self.leaveView()
                            }), secondaryButton: .default(Text("Leave here")
                        ))
                    }
                    Spacer()
                        
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
        appDelegate.cart.items = []
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func close() {
        
        let cart = appDelegate.cart

        if cart.items.count > 0 {
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
                [Product(id: 1, name: "Big Mac Menu", price: 100.0, category: "Menu"),
                Product(id: 1, name: "Big Mac Menu", price: 100.0, category: "Menu"),
                Product(id: 1, name: "Big Mac Menu", price: 100.0, category: "Menu"),
                Product(id: 1, name: "Big Mac Menu", price: 100.0, category: "Menu")]
        ))
    }
}
