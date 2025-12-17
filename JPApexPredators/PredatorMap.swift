//
//  PredatorMap.swift
//  JPApexPredators
//
//  Created by Yaakov Haimoff on 9.11.2025.
//

import SwiftUI
import MapKit

struct PredatorMap: View {
    let predators = Predators()
    @State var satellite: Bool = false
    @State var position: MapCameraPosition
    @State var camera: MapCameraPosition = .automatic
    @State var animateViewIn: Bool = false
    @State private var showCard = false
    @State var scaleButton: Bool = false
    @State private var selectedPredator: ApexPredators = Predators().apexPredators[2]
    
    var body: some View {
            VStack {
                if animateViewIn {
                    Map(position: $position) {
                        ForEach(predators.apexPredators) { predator in
                            Annotation(predator.name, coordinate: predator.location) {
                                Image(predator.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 100)
                                    .shadow(color: .white, radius: 3)
                                    .scaleEffect(x: -1)
                                    .scaleEffect(scaleButton ? 1.5 : 1)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            showCard = true
                                            scaleButton.toggle()
                                            selectedPredator = predator
                                            
                                            position = .camera(
                                                MapCamera(
                                                    centerCoordinate: predator.location,
                                                    distance: 1000,
                                                    heading: 250,
                                                    pitch: 80
                                                )
                                            )
                                        }
                                       
                                    }
                                    .transition(.opacity)
                            }
                        }
                    }
                    .mapStyle(satellite ? .imagery(elevation: .realistic): .standard(elevation: .realistic) )
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            satellite.toggle()
                        } label: {
                            Image(systemName: satellite ? "globe.americas.fill": "globe.americas")
                                .font(.largeTitle)
                                .imageScale(.large)
                                .padding(3)
                                .background(.ultraThinMaterial)
                                .shadow(radius: 3)
                                .padding()
                        }
                    }
                    .toolbarBackground(.automatic)
                }
            }
            .animation(.linear(duration: 1).delay(0.5), value: animateViewIn)
            
        .sheet(isPresented: $showCard) {
            PredatorCard(showCard: $showCard, animationViewIn: $animateViewIn, predator: selectedPredator)
        }
        .onAppear {
            animateViewIn = true
        }
    }
}

#Preview {
    PredatorMap(position: .camera(
        MapCamera(centerCoordinate: Predators().apexPredators[2].location, distance: 1000, heading: 250, pitch: 80)))
    .preferredColorScheme(.dark)
}
