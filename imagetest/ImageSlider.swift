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

    func clampedIndex(from predictedIndex: Int) -> Int {
        let newIndex = min(max(predictedIndex, self.index - 1), self.index + 1)
        guard newIndex >= 0 else { return 0 }
        guard newIndex <= maxIndex else { return maxIndex }
        return newIndex
    }
}

struct PageControl: View {
    @Binding var index: Int
    let maxIndex: Int
    
    func moveleft() {
        print(index)
        if index > 0 {
            index -= 1
        }
    }
    
    func moveright() {
        if index < maxIndex {
            index += 1
        }
    }
    
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: moveleft, label: {
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
            ForEach(0...maxIndex, id: \.self) { index in
                Circle()
                    .fill(index == self.index ? Color.white : Color.gray)
                    .frame(width: 8, height: 8)
            }
            Spacer()
            Button(action: moveright, label: {
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
        .padding(15)
        .frame(height: 50)
        .onReceive(timer) { _ in
            index += 1
            if index > maxIndex {
                index = 0
            }
        }
    }
}
