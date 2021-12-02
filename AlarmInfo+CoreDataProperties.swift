//
//  AlarmInfo+CoreDataProperties.swift
//  
//
//  Created by 이동헌 on 2021/12/03.
//
//

import Foundation
import CoreData


extension AlarmInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlarmInfo> {
        return NSFetchRequest<AlarmInfo>(entityName: "AlarmInfo")
    }

    @NSManaged public var date: Date?
    @NSManaged public var subject: String?
    @NSManaged public var note: String?
    @NSManaged public var activation: Bool

}
