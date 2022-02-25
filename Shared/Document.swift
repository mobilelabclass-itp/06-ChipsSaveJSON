//
//  Document.swift
//  Guesture
//
//  Created by jht2 on 1/12/22.
//

import SwiftUI

enum Palette: String, CaseIterable, Identifiable {
  case short
  case rgb
  var id: String { self.rawValue }
}

class Document: ObservableObject
{
  @Published var model: Model
  @Published var selectedId: Int = 0
  @Published var selectedPalette:Palette = .rgb
  
  var selectedItem: ItemModel? { model.item(id: selectedId) }

  init() {
    model = Model()
  }
  
  var items:[ItemModel] {
    model.items
  }
  
  func clearSelection() {
    selectedId = 0
    for index in  0..<model.items.count {
      model.items[index].selected = false;
    }
  }
  
  // Computed property to change the color the selected item
  //  ColorPicker("Color", selection: $document.itemColor)
  var itemColor:Color {
    get {
      if let index = model.itemIndex(id: selectedId) {
        return model.items[index].color
      }
      else {
        return Color.red
      }
    }
    set {
      print("Document color set \(newValue)")
      if let index = model.itemIndex(id: selectedId) {
        let colorNum = colorNum_(color: newValue)
        model.items[index].colorNum = colorNum;
      }
    }
  }
  
  func select(id: Int, state:Bool) {
    for index in  0..<model.items.count {
      model.items[index].selected = false;
    }
    if let index = model.itemIndex(id: id) {
      print("ItemView selected index \(index)")
      model.items[index].selected = state;
      selectedId = id
      // move to front
      let item = model.items[index]
      model.items.remove(at: index)
      model.items.append(item)
    }
    else {
      print("Document select failed id \(id)")
    }
  }
  
  func sendToBack() {
    if let index = model.itemIndex(id: selectedId) {
      let item = model.items[index]
      model.items.remove(at: index)
      model.items.insert(item, at: 0)
    }
  }
  
  func update(id: Int, x: Int, y: Int) {
//    print("Document update id \(id) x \(x) y \(y)")
//    print("selectedID \(selectedID)")
    if let index = model.itemIndex(id: id) {
      model.items[index].x = x;
      model.items[index].y = y;
    }
  }
  
  func update(id: Int, sizeBy: Double) {
    if let index = model.itemIndex(id: id) {
      update(index: index, sizeBy: sizeBy)
    }
  }

  func update(index: Int, sizeBy: Double) {
    let w = Double(model.items[index].width)
    let h = Double(model.items[index].height)
    model.items[index].width = Int(w * sizeBy);
    model.items[index].height = Int(h * sizeBy);
  }
  
  func update(id: Int, rotationBy: Double) {
    if let index = model.itemIndex(id: id) {
      var rotation = model.items[index].rotation
      rotation = (rotation < 360 ? rotation + rotationBy : 0)
      model.items[index].rotation = rotation;
    }
  }
  
  func clear () {
    selectedId = 0
    model.reset()
  }
  
  func addItem(rect: CGRect) {
    let x = Int(rect.width / 2);
    let y = Int(rect.height / 2);
    addItem(x: x, y: y)
  }
  
  func addItem(x: Int, y: Int) {
    let colorNum = randomColorNum()
    let item = ItemModel(x: x, y: y, colorNum: colorNum)
    model.addItem(item)
  }
  func randomColorNum_rgb() -> Int {
    let r = Int.random(in:0...255)
    let g = Int.random(in:0...255)
    let b = Int.random(in:0...255)
    return (255 << 24) | (r << 16) | (g << 8) | b
  }
  
  let colorNums = [0xFFFF0000, 0xFF00FF00, 0xFFFFFF00, 0xFF000000, 0xFFFFFFFF]
  
  func randomColorNum_colorNums() -> Int {
    let i = Int.random(in:0..<colorNums.count)
    return colorNums[i]
  }

  func randomColorNum() -> Int {
    if selectedPalette == .short {
      return randomColorNum_colorNums()
    }
    else {
      return randomColorNum_rgb()
    }
  }
  
  func addInitalItem(rect: CGRect) {
    let x = rect.width / 2;
    let y = rect.height / 2;
    let item = ItemModel(x: Int(x), y: Int(y))
    model.addItem(item)
  }
  
  func fillItems(rect: CGRect) {
    var x = 0
    var y = 0
    let len = 50
    let bottom = Int(rect.height - 250.0)
    while y < bottom {
      addItem(x: x, y: y)
      x += len;
      if x > Int(rect.width) {
        x = 0
        y += len;
      }
    }
  }
  
  func shakeDemo() {
    for index in  0..<model.items.count {
//      let item = model.items[index];
//      model.items[index].x = item.x + Int.random(in:-2...2)
//      model.items[index].y = item.y + Int.random(in:-2...2)
      let a = 45.0;
      model.items[index].rotation = Double.random(in:-a...a)
      update(index: index, sizeBy: Double.random(in:0.5...1.5))
    }
    model.items.shuffle()
  }

  func colorDemo() {
    for index in  0..<model.items.count {
      model.items[index].colorNum = randomColorNum();
    }
  }
  
  func save(_ fileName: String) {
    model.saveAsJSON(fileName: fileName)
  }
  
  func restore(_ fileName: String) {
    model = Model(JSONfileName: fileName)
  }
}

