import Foundation
import CoreData



@objc(Company) class Company: NSManagedObject {
  @NSManaged var name: String
  @NSManaged var employees: Set<Person>
}
