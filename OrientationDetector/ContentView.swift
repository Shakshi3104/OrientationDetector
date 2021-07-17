//
//  ContentView.swift
//  OrientationDetector
//
//  Created by MacBook Pro on 2021/07/17.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var orientationDetector = OrientationDetector()
    @State var deviceOrientaion = ""
    @State var deviceOrientationImageName = UIDevice.current.userInterfaceIdiom == .phone ? "iphone" : "ipad"
    
    var body: some View {
        VStack {
            Image(systemName: deviceOrientationImageName)
                .resizable()
                .scaledToFit()
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .padding()
            Text(deviceOrientaion)
        }
        .onAppear() {
            self.orientationDetector.onAppear()
        }
        .onReceive(self.orientationDetector.$deviceOrientation) {
            self.deviceOrientaion = getDeviceOrientation(orientation: $0)
            self.deviceOrientationImageName = getDeviceOrientationImageName(orientation: $0)
            print(deviceOrientaion)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
