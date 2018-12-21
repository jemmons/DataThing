import UIKit
import CoreData


class CompanyTableViewController: UITableViewController {
  private lazy var fetchedResultsController: NSFetchedResultsController = makeFetchedResults()
  private var moc: NSManagedObjectContext {
    return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  }
  public var person: Person?

  override func viewDidLoad() {
    super.viewDidLoad()
    try! fetchedResultsController.performFetch()
  }
  
  @IBAction func add() {
    NSEntityDescription.insertNewObject(forEntityName: "Company", into: moc)
  }
  
  
  private func makeFetchedResults() -> NSFetchedResultsController<Company> {
    let req: NSFetchRequest<Company> = NSFetchRequest(entityName: "Company")
    req.sortDescriptors = [NSSortDescriptor(keyPath: \Company.name, ascending: true)]
    let frc = NSFetchedResultsController(fetchRequest: req, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
    frc.delegate = self
    return frc
  }
  
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return fetchedResultsController.sections?.count ?? 0
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fetchedResultsController.sections?[section].numberOfObjects ?? 0
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
    let company = fetchedResultsController.object(at: indexPath)
    cell.textLabel?.text = company.name
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let company = fetchedResultsController.object(at: indexPath)
    person?.company = company
    try! person?.managedObjectContext?.save()
    navigationController?.popViewController(animated: true)
  }
}



extension CompanyTableViewController: NSFetchedResultsControllerDelegate {
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
