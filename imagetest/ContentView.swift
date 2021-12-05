//
//  ContentView.swift
//  imagetest
//
//  Created by Bart Reardon on 3/12/21.
//

import SwiftUI
import Foundation
import Combine

struct ContentView: View {
    
    @State var index = 0
    
    let images = ["1", "2", "3", "5", "6", "7"]
    //let images = ["2"]
    
    var body: some View {
        
            VStack(spacing: 20) {
                //HStack() {
                    ImageSlider(index: $index.animation(), maxIndex: images.count - 1, autoPlaySeconds: 8) {
                        ForEach(self.images, id: \.self) { imageName in
                            Image(imageName)
                                .resizable()
                                .scaledToFill()
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .padding()
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
