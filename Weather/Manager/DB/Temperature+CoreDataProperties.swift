import Foundation
import CoreData

extension Temperature {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Temperature> {
        return NSFetchRequest<Temperature>(entityName: "Temperature")
    }

    @NSManaged public var city: String?
    @NSManaged public var icon: String?
    @NSManaged public var lat: Double
    @NSManaged public var long: Double
    @NSManaged public var temperature: Double
    @NSManaged public var windSpeed: Double
    @NSManaged public var humidity: Int
    @NSManaged public var clouds: String?

}

extension Temperature : Identifiable {

}
