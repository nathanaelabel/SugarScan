//
//  OnboardingView.swift
//  SugarScan
//
//  Created by Nathanael Abel on 02/05/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var navigateToMain = false
    @State private var sugarLimit = 36
    @State private var selectedGender = 0 // 0 for male, 1 for female
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Set your daily sugar intake limit in grams. You can edit this anytime later.")
                    .foregroundColor(Color(hex: "85858B"))
                    .bold()
                    .padding()
                
                VStack {
                    HStack {
                        Text("Recommended Daily Sugar Intake")
                            .bold()
                            .padding()
                        Spacer()
                        Picker(selection: $selectedGender, label: Text("")) {
                            Text("Male").tag(0)
                            Text("Female").tag(1)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    }
                    
                    Text("\(selectedGender == 0 ? 36 : 24) g")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    Text("")
                    Text("AHA Recommended Added Sugar Limit >")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .trailing
                        )
                        .underline()
                        .padding()
                        .onTapGesture {
                            if let url = URL(string: "https://www.heart.org/en/healthy-living/healthy-eating/eat-smart/sugar/how-much-sugar-is-too-much") {
                                UIApplication.shared.open(url)
                            }
                        }
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding()
                
                Button(action: {
                    sugarLimit = selectedGender == 0 ? 36 : 24
                    navigateToMain = true
                }) {
                    Text("Set to Recommended")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                
                NavigationLink(destination: MainView(sugarLimit: sugarLimit), isActive: $navigateToMain) {
                    EmptyView()
                }
                
                NavigationLink(destination: SetSugarLimitView(sugarLimit: $sugarLimit)) {
                    Text("Set my own limit")
                        .foregroundColor(Color.gray)
                        .bold()
                        .padding()
                }
                Spacer()
            }
            .navigationBarTitle("Set Sugar Limit")
            .background(Color(hex: "F5F5F5"))
        }
    }
}

#Preview {
    OnboardingView()
}
