import UIKit



class DetailViewController: UIViewController {
  @IBOutlet private weak var firstNameField: UITextField!
  @IBOutlet private weak var lastNameField: UITextField!
  @IBOutlet private weak var companyButton: UIButton!
  var person: Person? {
    didSet {
      update()
    }
  }
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    update()
  }
  
  
  private func update() {
    firstNameField?.text = person?.firstName
    lastNameField?.text = person?.lastName
    companyButton?.setTitle(person?.company?.name ?? "Add Company", for: .normal)
  }
  
  
  @IBAction func save() {
    person?.firstName = firstNameField.text ?? ""
    person?.lastName = lastNameField.text ?? ""
    try! person?.managedObjectContext?.save()
  }
  
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let vc = segue.destination as? CompanyTableViewController else {
      return
    }
    vc.person = person
  }
}
