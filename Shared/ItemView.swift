
import SwiftUI

struct ItemDragView: View {
  var item: ItemModel
  
  @EnvironmentObject var document: Document
  
  var body: some View {
    ItemView(item: item, position: positionOffset())
      .gesture(panGesture())
  }
  
  @GestureState private var dragOffset: CGSize = CGSize.zero
  
  func positionOffset() -> CGPoint {
    let x = CGFloat(item.x) + dragOffset.width;
    let y = CGFloat(item.y) + dragOffset.height;
    return CGPoint(x: x, y: y)
  }
  
  private func panGesture() -> some Gesture {
    DragGesture(minimumDistance: 0)
      .updating($dragOffset) { latestValue, dragOffset, _ in
        dragOffset = latestValue.translation
      }
      .onEnded { finalValue in
        let x = Int(CGFloat(item.x) + finalValue.translation.width)
        let y = Int(CGFloat(item.y) + finalValue.translation.height)
        document.update(id: item.id, x: x, y: y)
        document.select(id: item.id, state: !item.selected)
      }
  }
}

struct ItemView: View {
  var item: ItemModel
  var position: CGPoint;
  
  @EnvironmentObject var document: Document
  
  var body: some View {
    ZStack {
      if (item.selected) {
        Rectangle()
          .stroke(lineWidth: 5)
        
      }
      Rectangle()
        .fill(item.color)
        // on tap here causes pause before drag begins
        //  .onTapGesture {
        //  document.select(id: item.id, state: !item.selected)
        //  }
      if (item.assetName != "") {
        Image(item.assetName)
      }
      if document.selectedId != 0 {
        Text("\(item.id)")
      }
    }
    .frame(width: CGFloat(item.width), height: CGFloat(item.height))
    .rotationEffect(.degrees(item.rotation))
    .animation(.linear, value:item.rotation)
    .position(position)
  }
}
