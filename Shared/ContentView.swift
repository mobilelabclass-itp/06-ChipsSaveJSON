//
//  ContentView.swift
//  Created by jht2 on 1/12/22.
//

import SwiftUI

struct ContentView: View {
  
  @EnvironmentObject var document: Document
  
  var body: some View {
    GeometryReader { geometry in
      let rect = geometry.frame(in: .local)
      ZStack {
        Rectangle()
          .fill(Color(white: 0.9))
          .onTapGesture {
            print("ContentView onTapGesture")
            document.clearSelection()
          }
        VStack {
          if document.items.isEmpty {
            Spacer()
          }
          else {
            ZStack {
              ForEach(document.items) { item in
                ItemDragView(item: item)
              }
            }
          }
          if let item = document.selectedItem {
            Text("x \(item.x) y \(item.y) color \(item.colorName)")
            HStack {
              ColorPicker("Color", selection: $document.itemColor)
              Button("Rotate") {
                document.update(id: document.selectedId, rotationBy: 45.0)
              }
              Button("+Size") {
                document.update(id: document.selectedId, sizeBy: 1.1)
              }
              Button("-Size") {
                document.update(id: document.selectedId, sizeBy: 0.9)
              }
            }
            .buttonStyle(.bordered)
          }
          HStack {
            Button("Add") {
              withAnimation {
                document.addItem(rect: rect)
              }
            }
            Button("Fill") {
              withAnimation {
                document.clear();
                document.fillItems(rect: rect)
              }
            }
            Button("Clear") {
              withAnimation {
                document.clear();
              }
            }
            Button("Shake") {
              withAnimation {
                document.shakeDemo();
              }
            }
            Button("Color") {
              withAnimation {
                document.colorDemo();
              }
            }
          }
          .buttonStyle(.bordered)
          HStack {
            Picker("Palette", selection: $document.selectedPalette) {
              Text("rgb").tag(Palette.rgb)
              Text("short").tag(Palette.short)
            }
            Button("To Back") {
              withAnimation {
                document.sendToBack();
              }
            }
            Button("Save") {
              document.save("guesture04.json");
            }
            Button("Restore") {
              document.restore("guesture04.json");
            }
          }
          .buttonStyle(.bordered)
          Text("frame \(format(rect))")
        }
        .padding(20)
        .onAppear() {
          // document.addInitalItem(rect: rect)
        }
      }
    }
  }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(model: Model())
//    }
//}

//PlaygroundPage.current.setLiveView(ExampleView())

