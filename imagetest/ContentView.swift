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
                    
                    //.onReceive(timer) { _ in
                    //    index += 1
                    //    if index > images.count-1 {
                    //        index = 0
                    //    }
                    //}
                    /*
                    Button(action: moveleft, label: {
                        Image(systemName: "chevron.left")
                    })
                        .padding(5)
                    Button(action: moveright, label: {
                        Image(systemName: "chevron.right")
                    })
                        .padding(5)
                    */
                //}
                
                
                //Stepper("Index: \(index)", value: $index.animation(.easeInOut(duration: 0.5)), in: 0...images.count-1)
                //    .font(Font.body.monospacedDigit())

            }
            .padding()
        }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
