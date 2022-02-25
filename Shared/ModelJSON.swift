//
//  ModelJSON.swift
//  Created by jht2 on 1/15/22.

import SwiftUI

extension Model {
  
  func saveAsJSON(fileName: String) {
    do {
      let directory = try FileManager.default.url(
        for: .documentDirectory,
           in: .userDomainMask,
           appropriateFor: nil,
           create: true)
      as URL
      let filePath = directory.appendingPathComponent(fileName);
      print("saveAsJSON filePath \(filePath as Any)")
      
      let encoder = JSONEncoder()
      encoder.outputFormatting = .prettyPrinted
      
      let jsonData = try encoder.encode(self)
      // print("Model saveAsJSON jsonData \(String(describing: jsonData))")
      
      let str = String(data: jsonData, encoding: .utf8)!
      // print("Model saveAsJSON encode str \(str)")
      
      try str.write(to: filePath, atomically: true, encoding: .utf8)
      //
    }
    catch {
      fatalError("Model saveAsJSON error \(error)")
    }
  }
  
  init(JSONfileName fileName: String) {
    items = []
    do {
      let fileMan = FileManager.default
      let directory = try fileMan.url(
        for: .documentDirectory,
           in: .userDomainMask,
           appropriateFor: nil,
           create: true)
      as URL
      let filePath = directory.appendingPathComponent(fileName);
      let filePathExists = fileMan.fileExists(atPath: filePath.path)
      if !filePathExists {
        print("Model init not filePath \(filePath as Any)")
        return
      }
      print("Model init filePath \(filePath as Any)")
      
      let jsonData = try String(contentsOfFile: filePath.path).data(using: .utf8)
      
      let decoder = JSONDecoder()
      self = try decoder.decode(Model.self, from: jsonData!)
      //
    } catch {
      fatalError("Model init error \(error)")
    }
  }
}
