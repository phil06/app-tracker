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
            try contents.write(to: fileURL, atomically: false, encoding: String.Encoding.utf8)
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
    
    func readFileSeparatedCR(fileName: String) -> String {
        let fileURL = getFileURL(fileName: fileName, fileExtension: "dat")
        var readString = ""
        do {
            readString = try String(contentsOf: fileURL, encoding: .utf8)
        } catch let error as NSError {
            print("Failed to read file")
            print(error)
        }
        
        print("Contents of the file : \(readString)")
        return readString
    }
    
    func deleteFile(fileName: String) {
        let fileURL = getFileURL(fileName: fileName, fileExtension: "dat")
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error as NSError {
            print("Failed to delete file")
            print(error)
        }
    }
    
    func readDirectory() -> [String] {
        let documentDir = getDirectory().path

        var contents: [String] = []
        do {
            contents = try FileManager.default.contentsOfDirectory(atPath: documentDir)
        } catch let error as NSError {
            print("Failed to access directory")
            print(error)
        }

        return contents
    }
    
    func readDirectoryNoneExtension() -> [String] {
        var list: [String] = []
        readDirectory().forEach { (item) in
            list.insert(item.hasSuffix(".dat") ? item.components(separatedBy: ".dat")[0] : item, at: list.count)
        }
        return list
    }
    
    private func getDirectory() -> URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
    
    private func getFileURL(fileName: String, fileExtension: String) -> URL {
        let documentDirURL = getDirectory()
        let fileURL = documentDirURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
        return fileURL
    }
    
    private func getFileURL(fileName: String) -> URL {
        let documentDirURL = getDirectory()
        let fileURL = documentDirURL.appendingPathComponent(fileName)
        return fileURL
    }
}
