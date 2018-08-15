//
//  ONFileManager.swift
//  TRACKER
//
//  Created by saera on 2018. 8. 15..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

class ONFileManager {
    
    func saveToDatFileSeparatedCR(fileName: String, contents: String) {
        let fileURL = getFileURL(fileName: fileName, fileExtension: "dat")
        print("file path : \(fileURL.path)")
        
        do {
            try contents.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("Failed to write to URL")
            print(error)
        }
    }
    
    func readDatFileSeparatedCR(fileName: String) -> String {
        let fileURL = getFileURL(fileName: fileName, fileExtension: "dat")
        var readString = ""
        do {
            readString = try String(contentsOf: fileURL)
        } catch let error as NSError {
            print("Failed to read file")
            print(error)
        }
        
        print("Contents of the file : \(readString)")
        return readString
    }
    
    private func getFileURL(fileName: String, fileExtension: String) -> URL {
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
        return fileURL
    }
}
