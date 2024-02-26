//
//  TsumModel+CoreDataProperties.swift
//  ForTsumTsum
//
//  Created by Yo_4040 on 2024/02/13.
//
//

import Foundation
import CoreData


extension TsumModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TsumModel> {
        return NSFetchRequest<TsumModel>(entityName: "TsumModel")
    }

    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var slvtype: String?
    @NSManaged public var slv: NSNumber?

}

extension TsumModel : Identifiable {

}
