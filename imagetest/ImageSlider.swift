//
//  ImageSlider.swift
//  imagetest
//
//  Created by Bart Reardon on 3/12/21.
//

// Basis for this view was taken from the following stack overflow post https://stackoverflow.com/questions/58896661/swiftui-create-image-slider-with-dots-as-indicators

import SwiftUI

    
struct PagingView<Content>: View where Content: View {

    @Binding var index: Int
    let maxIndex: Int
    let content: () -> Content

    @State private var offset = CGFloat.zero
    @State private var dragging = false

    init(index: Binding<Int>, maxIndex: Int, @ViewBuilder content: @escaping () -> Content) {
        self._index = index
        self.maxIndex = maxIndex
        self.content = content
    }
    
    var body: some View {
        HStack() {
            ZStack(alignment: .bottomTrailing) {
                GeometryReader { geometry in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            self.content()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .clipped()
                        }
                    }
                    .content.offset(x: self.offset(in: geometry), y: 0)
                    .frame(width: geometry.size.width, alignment: .leading)
                }
                .clipped()
                //.border(Color.green)

                PageControl(index: $index.animation(.easeInOut(duration: 0.5)), maxIndex: maxIndex)
            }
        }
    }

    func offset(in geometry: GeometryProxy) -> CGFloat {
        if self.dragging {
            return max(min(self.offset, 0), -CGFloat(self.maxIndex) * geometry.size.width)
        } else {
            return -CGFloat(self.index) * geometry.size.width
        }
    }
}

struct PageControl: View {
    @Binding var index: Int
    let maxIndex: Int
    
    func moveimage(direction: String) {
        switch direction {
        case "left":
            if index > 0 {
                index -= 1
            }
        case "right":
            if index < maxIndex {
                index += 1
            }
        default:
            // reset index to 0
            index = 0
        }
    }
    
    func rotateIndex() {
        index += 1
        if index > maxIndex {
            index = 0
        }
    }
        
    // change image every 4 seconds (TODO: remove and make this a configurable paramater)
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 8) {
            // move image left chevron
            if maxIndex > 0 {
                Button(action: {moveimage(direction: "left")}, label: {
                    ZStack() {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .foregroundColor(Color.white)
                        
                        Image(systemName: "chevron.left.circle.fill")
                            .resizable()
                            .foregroundColor(Color.black)
                    }
                    .frame(width: 30, height: 30)
                    .opacity(0.80)
                })
                .buttonStyle(.borderless)
            
                Spacer()
                
                // Centre dots
                ForEach(0...maxIndex, id: \.self) { index in
                    Circle()
                        .fill(index == self.index ? Color.white : Color.gray)
                        .frame(width: 8, height: 8)
                }
                
                Spacer()
                
                // move image right chevron
                Button(action: {moveimage(direction: "right")}, label: {
                    ZStack() {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .foregroundColor(Color.white)
                        
                        Image(systemName: "chevron.right.circle.fill")
                            .resizable()
                            .foregroundColor(Color.black)
                    }
                    .frame(width: 30, height: 30)
                    .opacity(0.80)
                        
                })
                .buttonStyle(.borderless)
            }
        }
        .padding(15)
        .frame(height: 50)
        // increment the image index. reset to 0 when we reach the end
        .onReceive(timer) { _ in
            rotateIndex()
        }
    }
}
