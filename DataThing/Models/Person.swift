import Foundation
import CoreData



@objc(Person)
final public class Person: NSManagedObject {
  @NSManaged public var firstName: String
  @NSManaged public var lastName: String
  @NSManaged var company: Company?
}
