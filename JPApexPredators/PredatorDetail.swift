//
//  PredatorDetail.swift
//  JPApexPredators
//
//  Created by Yaakov Haimoff on 9.11.2025.
//

import Foundation
import SwiftUI
import MapKit

struct PredatorDetail: View {
    let predator: ApexPredators
    
    @State var position: MapCameraPosition
    @Namespace var namespace
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                ZStack (alignment: .bottomTrailing) {
                    // background image
                    Image(predator.type.rawValue)
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            LinearGradient(stops: [Gradient.Stop(color: .clear, location: 0.8), Gradient.Stop(color: .black, location: 1),], startPoint: .top, endPoint: .bottom)
                        }
                    
                    NavigationLink {
                        // dinosoar image
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .scaleEffect(x: -1)
                            .shadow(color: .black, radius: 7)
                            .offset(y: 20)
                    } label: {
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geo.size.width/1.5, height: geo.size.height/4)
                            .scaleEffect(x: -1)
                            .shadow(color: .black, radius: 7)
                            .offset(y: 20)
                    }
                    
                }
                VStack (alignment: .leading){
                    // dinosar image
                    Text(predator.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // current location
                    NavigationLink {
                        PredatorMap(position: .camera(
                            MapCamera(centerCoordinate: predator.location, distance: 1000, heading: 250, pitch: 80)))
                        .navigationTransition(.zoom(sourceID: 1, in: namespace))
                    } label: {
                        Map(position: $position) {
                            Annotation( predator.name, coordinate: predator.location) {
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                    .symbolEffect(.pulse)
                            }
                            .annotationTitles(.hidden)
                        }
                        .frame(height: 125)
                        .overlay(alignment: .trailing) {
                            Image(systemName: "greaterthan")
                                .imageScale(.large)
                                .padding()
                        }
                        .overlay(alignment: .bottom) {
                            Text("Current Location")
                                .padding([.leading, .bottom])
                                .background(.black.opacity(0.33))
                                .clipShape(.rect(bottomTrailingRadius: 15))
                        }
                        .clipShape(.rect(cornerRadius: 15))
                    }
                    .matchedTransitionSource(id: 1, in: namespace)
                    
                    // appears in
                    Text("Appears In:")
                        .font(Font.title3)
                    
                    ForEach(predator.movies, id: \.self) { movie in
                        Text("" + movie)
                            .font(.subheadline)
                    }
                    
                    // movie moments
                    Text("Movie Moments:")
                        .font(Font.title)
                        .padding(.top, 15)
                    
                    ForEach(predator.movieScenes) { scene in
                        Text(scene.movie)
                            .font(.title2)
                            .padding(.vertical, 1)
                        
                        Text(scene.sceneDescription)
                            .padding(.bottom, 15)
                    }
                    
                    // link to web page
                    Text("Read More:")
                    
                    Link(predator.link, destination: URL(string: predator.link)!)
                        .font(.caption)
                        .foregroundStyle(.blue)
                        .padding(.bottom, 10)
                }
                .padding()
                .frame(width: geo.size.width, alignment: .leading)
            }
        }
        .ignoresSafeArea()
        .toolbarBackground(.automatic)
    }
}

#Preview {
    let predator = Predators().apexPredators[2]
    NavigationStack {
        PredatorDetail(predator: predator,
                       position: .camera(
                        MapCamera(centerCoordinate: predator.location, distance: 3000)))
        .preferredColorScheme(.dark)
    }
}
