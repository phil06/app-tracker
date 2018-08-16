//
//  NoteMenuDelegate.swift
//  TRACKER
//
//  Created by NHNEnt on 2018. 8. 10..
//  Copyright © 2018년 OnlyNew. All rights reserved.
//

import UIKit

protocol NoteMenuDelegate: class {
    func markingStatusChanged(isMark: Bool)
}

protocol NoteViewDelegate: class {
    func save()
}

protocol NoteGridViewDelegate: class {
    func save(fileName: String)
    func loadSaved(fileName: String)
}
