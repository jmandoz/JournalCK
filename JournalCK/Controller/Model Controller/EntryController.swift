//
//  EntryController.swift
//  JournalCK
//
//  Created by Jason Mandozzi on 7/8/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

class EntryController {
    
    //Create a notification
    let messagesWereUpdatedNotification = Notification.Name("Messages were updated")
    
    //Singleton
    static let shared = EntryController()
    
    //Source of Truth
    var entries: [Entry] = []{
        didSet {
            //createing a post notification
            NotificationCenter.default.post(name: messagesWereUpdatedNotification, object: nil)
        }
    }
    
    
    //CRUD
    
    //CREATE
    
    //save
    //Our function takes in an Entry and completes with true when the Entry is saved
    func saveEntry(title: String, body: String, completion: @escaping (Bool) -> Void) {
        //create the entry
        let entry = Entry(title: title, bodyText: body)
        //creating our entry that we're saving into a CKRecord using our convenience initializer from the model
        let entryToSave = CKRecord(entry: entry)
        CKContainer.default().privateCloudDatabase.save(entryToSave) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(false)
                return
            }
            guard let record = record,
                let entry = Entry(record: record) else { completion(false) ; return}
            self.entries.append(entry)
            completion(true)
        }
    }
    //create
//    func addEntryWith(title: String, body: String, completion: @escaping (Bool) -> Void) {
//        let entryToAdd = Entry(title: title, bodyText: body)
//        saveEntry(entry: entryToAdd, completion: completion)
//    }
    
    //Read
    
    func fetchEntries(completion: @escaping (Bool) -> ()) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: EntryConstants.recordID, predicate: predicate)
        CKContainer.default().privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(false)
                return
            }
            guard let records = records else { completion(false) ; return }
            let entries = records.compactMap{ Entry(record: $0)}
            self.entries = entries
            completion(true)
        }
    }
    
    //Update
    
    //Delete
    
}
