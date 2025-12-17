//
//  PredatorCard.swift
//  JPApexPredators
//
//  Created by Yaakov Haimoff on 16.12.2025.
//

import SwiftUI

struct PredatorCard: View {
    @Binding var showCard: Bool
    @Binding var animationViewIn: Bool
    @State var scaleButton: Bool = false
    let predator: ApexPredators
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                if animationViewIn {
                    HStack {
                        Spacer()
                        Text(predator.name)
                            .font(.title2.bold())
                            .padding(.top)
                        Spacer()
                        Button {
                            withAnimation(.easeOut) {
                                showCard.toggle()
                            }
                        } label: {
                            Image(systemName: "xmark")
                                .scaledToFit()
                        }
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(radius: 10)
                        .overlay(
                            Circle()
                                .stroke(.gray.opacity(0.2), lineWidth: 10)
                        )
                        .padding(.top)
                        .padding(.trailing, 30)
                    }
                    
                    HStack {
                        Text(predator.type.rawValue.capitalized)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 5)
                            .background(predator.type.background)
                            .clipShape(.capsule)
                        
                        
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .scaleEffect(x: -1)
                            .shadow(color: .black, radius: 7)
                            .offset(y: 20)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                    scaleButton.toggle()
                                }
                            }
                            
                    }
                }
            }
            .presentationDetents([.fraction(3/7), .large])
            .presentationDragIndicator(.visible)
            .animation(.easeInOut(duration: 1).delay(0.5), value: animationViewIn)
        }
    }
}

#Preview {
    PredatorCard(showCard: .constant(true), animationViewIn: .constant(true), predator: Predators().apexPredators[2])
    
}
