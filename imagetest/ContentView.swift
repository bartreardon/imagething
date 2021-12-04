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
    
    func moveleft() {
        print(index)
        if index > 0 {
            index -= 1
        }
    }
    
    func moveright() {
        if index < images.count - 1 {
            index += 1
        }
    }
    
    var body: some View {
        
            VStack(spacing: 20) {
                //HStack() {
                    PagingView(index: $index.animation(), maxIndex: images.count - 1) {
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
