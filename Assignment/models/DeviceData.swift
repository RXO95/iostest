//
//  ComputerItem.swift
//  Assignment
//
//  Created by Kunal on 10/01/25.
//

import Foundation
import RealmSwift


// MARK: - ComputerItem
class DeviceData: Object, Decodable, Identifiable {
    static func == (lhs: DeviceData, rhs: DeviceData) -> Bool {
        return lhs.id == rhs.id
    }
    
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String
    @Persisted var data: ItemData?
    
    
    override static func primaryKey() -> String {
        return "id"
    }
}

class ItemData: Object, ObjectKeyIdentifiable, Codable{
    @Persisted var id: Int = 0
    @Persisted var color: String?
    @Persisted var capacity: String?
    @Persisted var price: Double?
    @Persisted var capacityGB: Int?
    @Persisted var screenSize: Double?
    @Persisted var idescription: String?
    @Persisted var generation: String?
    @Persisted var strapColour: String?
    @Persisted var caseSize: String?
    @Persisted var cpuModel: String?
    @Persisted var hardDiskSize: String?

    enum CodingKeys: String, CodingKey {
        case color
        case capacity
        case price
        case capacityGB = "capacity GB"
        case screenSize = "Screen size"
        case idescription = "Description"
        case generation = "Generation"
        case strapColour = "Strap Colour"
        case caseSize = "Case Size"
        case cpuModel = "CPU model"
        case hardDiskSize = "Hard disk size"
    }
}

extension Realm {
    static var cache: Realm {
        do {
            return try Realm(configuration: cacheConfiguration!)
        } catch {
            print("realm error: \(error.localizedDescription)")
        }
        return (try? Realm(configuration: cacheConfiguration!))!
    }
    
    static var cacheConfiguration: Realm.Configuration? {
        do {
            let fileUrl = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appending(component: "customCache", directoryHint: .isDirectory)
            return Realm.Configuration(fileURL: fileUrl, schemaVersion: 1) { migration, oldSchemaVersion in
                //migration
            }
        } catch {
            print("realm config error: \(error.localizedDescription)")
        }
        
        return nil
    }
}

typealias DeviceDataRW = DeviceData

extension DeviceDataRW {
    class func addToCache(_ data: DeviceData) {
        do {
            let realm = Realm.cache
            realm.beginWrite()
            realm.add(data, update: .modified)
            try realm.commitWrite()
        } catch {
            print("realm addToCache error: \(error.localizedDescription)")
        }
    }
    
    class func addToCache(_ data: [DeviceData]) {
        do {
            let realm = Realm.cache
            realm.beginWrite()
            realm.add(data, update: .modified)
            try realm.commitWrite()
        } catch {
            print("realm addToCache error: \(error.localizedDescription)")
        }
    }
}
