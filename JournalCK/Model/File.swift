//
//  File.swift
//  JournalCK
//
//  Created by Jason Mandozzi on 7/8/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

class Entry {
    let title: String
    let bodyText: String
    let timestamp: Date
    let ckRecordID: CKRecord.ID
    
    init(title: String, bodyText: String, timestamp:Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
    //Initialize it as a CLASS TO THE CLOUD
    convenience init?(record: CKRecord) {
        //Unwrapping the optional values and type-casting them to what we want
        guard let title = record[EntryConstants.titleKey] as? String,
        let bodyText = record[EntryConstants.bodyKey] as? String,
        let timestamp = record[EntryConstants.timestampKey] as? Date
            else {return nil}
        self.init(title: title, bodyText: bodyText, timestamp: timestamp, ckRecordID: record.recordID)
    }
}
//Coding Keys
struct EntryConstants{
    static let titleKey = "title"
    static let bodyKey = "body"
    static let timestampKey = "timestamp"
    static let recordID = "Entry"
}
//Convenience Initializer for the CLASS FROM THE CLOUD
extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.recordID, recordID: entry.ckRecordID)
        self.setValue(entry.title, forKey: EntryConstants.titleKey)
        self.setValue(entry.bodyText, forKey: EntryConstants.bodyKey)
        self.setValue(entry.timestamp, forKey: EntryConstants.timestampKey)
    }
}
