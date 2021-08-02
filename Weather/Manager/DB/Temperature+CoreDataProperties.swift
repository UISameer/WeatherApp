import Foundation
import CoreData


extension Temperature {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Temperature> {
        return NSFetchRequest<Temperature>(entityName: "Temperature")
    }

    @NSManaged public var city: String?
    @NSManaged public var temperature: Double
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var icon: String?

}

extension Temperature : Identifiable {

}
