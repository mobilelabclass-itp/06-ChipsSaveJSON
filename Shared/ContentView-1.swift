//
//  ContentView.swift
//  Shared
//
//  Created by jht2 on 1/12/22.
//

import SwiftUI
//import PlaygroundSupport

// Need to move to xcode project to add geometry and array
// need to split into other files
// !!@ GeometryReader fails in playground

// geometry.frame(in: .local)
// String(format: "%.1f", model.zoom_x))
// Text("x \(String(format: "%.1f", model.zoom_x)) y \(String(format: "%.1f",  model.zoom_y)) z \(String(format: "%.3f",  zoom_scale))")

// Format double to string
func Fd(_ v: Double) -> String {
    String(format: "%.1f", v)
}
func Fr(_ rt: CGRect) -> String {
    "\(Fd(rt.origin.x)) \(Fd(rt.origin.y)) \(Fd(rt.size.width)) \(Fd(rt.size.height))"
}
func Fp(_ pt: CGPoint) -> String {
    "\(Fd(pt.x)) \(Fd(pt.y))"
}

struct ContentView: View {
    @State var col = Color.yellow
    @State var pos = CGPoint(x: 100, y: 100)
    @State var rotation = 0.0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Item(color: col, pos: $pos, rotation: $rotation)
                let rt = geometry.frame(in: .local)
                Text("rt \(Fr(rt))")
                Text("pos \(Fp(pos))")
                HStack {
                    Button("Rotate") {
                        rotation = (rotation < 360 ? rotation + 60 : 0)
                    }
                    Button("Reset") {
                        col = Color.yellow
                        pos = CGPoint(x: 100, y: 100)
                        rotation = 0.0
                    }
                    Button("Color") {
                        let r = Double.random(in:0...1.0)
                        let g = Double.random(in:0...1.0)
                        let b = Double.random(in:0...1.0)
                        col = Color(red: r, green: g, blue: b)
                    }
                    Button("Jump") {
                        let x = Double.random(in:0...rt.size.width)
                        let y = Double.random(in:0...rt.size.height)
                        pos = CGPoint(x: x, y: y)
                    }
                }
//                .font(.footnote)
                .buttonStyle(.bordered)
            }
//            .frame(width: 200, height: 300)
            .padding(10)
        }
    }
}

struct Item: View {
    var color: Color
    @Binding var pos: CGPoint
    @Binding var rotation: Double

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: 100, height: 100)
            .rotationEffect(.degrees(rotation))
            .animation(.linear, value:rotation)
            .position(posOffset())
            .gesture(panGesture())
    }
    
    @GestureState private var dragOffset: CGSize = CGSize.zero

    func posOffset() -> CGPoint {
        let x = pos.x + dragOffset.width;
        let y = pos.y + dragOffset.height;
        return CGPoint(x: x, y: y)
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($dragOffset) { latestValue, dragOffset, _ in
                dragOffset = latestValue.translation
            }
            .onEnded { finalValue in
                pos.x = pos.x + finalValue.translation.width
                pos.y = pos.y + finalValue.translation.height
            }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//PlaygroundPage.current.setLiveView(ExampleView())


