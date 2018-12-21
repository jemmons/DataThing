import UIKit
import CoreData
import PointlessPeople

class ViewController: UITableViewController {
  lazy var fetchedResultsController: NSFetchedResultsController = makeFetchedResults()
  private var moc: NSManagedObjectContext {
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  }

  
  @IBAction func add(){
    let f = First()
    print(f)
    NSEntityDescription.insertNewObject(forEntityName: "Person", into: moc)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    try! fetchedResultsController.performFetch()
    tableView.reloadData()
  }
  
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections!.count
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections![section].numberOfObjects
  }

  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SubCell", for: indexPath)
    let person = fetchedResultsController.object(at: indexPath)
    cell.textLabel?.text = person.firstName + " " + person.lastName
    cell.detailTextLabel?.text = person.company?.name
    return cell
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard
      let selection = tableView.indexPathForSelectedRow,
      let vc = segue.destination as? DetailViewController else {
        return
    }
    let person = fetchedResultsController.object(at: selection)
    vc.person = person
  }
}



private extension ViewController {
  func makeFetchedResults() -> NSFetchedResultsController<Person> {
    let req: NSFetchRequest<Person> = NSFetchRequest(entityName: "Person")
    req.sortDescriptors = [NSSortDescriptor(keyPath: \Person.lastName, ascending: true)]
    let frc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    frc.delegate = self
    return frc
  }
}



extension ViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    case .delete:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
    case .update:
      tableView.reloadRows(at: [indexPath!], with: .automatic)
    case .move:
      tableView.deleteRows(at: [indexPath!], with: .automatic)
      tableView.insertRows(at: [newIndexPath!], with: .automatic)
    }
  }
}
