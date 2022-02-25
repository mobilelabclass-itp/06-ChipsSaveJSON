//
//  ChipsSaveJSONApp.swift
//  Created by jht2 on 1/12/22.
//

// Guesture04 save as local file json

import SwiftUI

@main
struct ChipsSaveJSONApp: App {
  @StateObject var document = Document()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(document)
    }
  }
}
