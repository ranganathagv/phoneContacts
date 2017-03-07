//
//  ViewController.swift
//  SampleContacts
//
//  Created by Ranganatha Veeranagappa on 2/22/17.
//  Copyright © 2017 Ranganatha Veeranagappa. All rights reserved.
//

import UIKit
import Contacts
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewContactAdded{

    @IBOutlet weak var contactsListTV: UITableView!
    var contacts = [CNContact]()
    var contactsFromDB = [NSFetchRequestResult]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.  let filemgr = NSFileManager.defaultManager()
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                .userDomainMask, true)[0]
        print("Database Path \(dirPaths)")
        self.title = "Contacts"
        
        
        let hasDataInDB = getRowsFromDB()
        
        if !hasDataInDB {
          getContactsFromCNContacts()
        }
    }


    
    func  getRowsFromDB () -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentContainer = appDelegate.getPersistentContainerObj()
        let moc = persistentContainer.viewContext
        
        let request : NSFetchRequest<ContactsEntity> = ContactsEntity.fetchRequest()
        do {
            let result = try moc.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
            self.contactsFromDB = result as! [NSFetchRequestResult]
            print("Fetched data from DB \(self.contactsFromDB)")
            return true
        } catch {
            print("Fetching from DB Failed")
            return false
        }
    }
    
    // get contacts from Phone
    func getContactsFromCNContacts () -> Void {
        
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName),CNContactPhoneNumbersKey, CNContactEmailAddressesKey,CNContactImageDataKey,CNContactImageDataAvailableKey] as [Any] //CNContactIdentifierKey
        
        let fetchRequest = CNContactFetchRequest( keysToFetch:keysToFetch as! [CNKeyDescriptor])
        
        
        //            CNContact.localizedString(forKey: CNLabelPhoneNumberiPhone)
        
        fetchRequest.mutableObjects = true
        fetchRequest.unifyResults = true
        fetchRequest.sortOrder = .userDefault
        
        //            let contactStoreID = CNContactStore().defaultContainerIdentifier()
        //            print("\(contactStoreID)")
        
        
        do {
            
            try CNContactStore().enumerateContacts(with: fetchRequest) { (contact, stop) -> Void in
                //do something with contact
                if contact.phoneNumbers.count > 0 {
                    self.contacts.append(contact)
                    
                    print("Phone numbers array is \(self.contacts[0].phoneNumbers)")
                    print("Email Address array is \(self.contacts[0].emailAddresses)")
                    
//                    print ((self.contacts[0].phoneNumbers[0].value ).value(forKey: "digits") as! String)                    
//                    print(self.contacts[0].emailAddresses[0].value(forKey: "value") ?? "default@default.com")

                }
                
            }
        } catch let e as NSError {
            print(e.localizedDescription)
        }
        
        print(self.contacts)
        storeContactsToDB()
//        let myStr : String = "Photon"
//        perform(#selector(ViewController.saveData), with: myStr, afterDelay: 1.0)
    }

    // saving contacts to Coredata
    func storeContactsToDB () -> Void {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let persistentConatiner  = appDelegate.getPersistentContainerObj()
        let moc = persistentConatiner.viewContext
        
        
        for  cE in self.contacts {
            let contactsEntity = NSEntityDescription.insertNewObject(forEntityName: "ContactsEntity", into: moc) as! ContactsEntity
            contactsEntity.givenName = cE.givenName
            contactsEntity.familyName = cE.familyName
            if cE.phoneNumbers.count >= 1 {
                contactsEntity.phoneNumber = (cE.phoneNumbers[0].value).value(forKey: "digits") as? String
            } else {
                contactsEntity.phoneNumber = ""
            }
            if cE.emailAddresses.count >= 1 {
                contactsEntity.emailAddress = cE.emailAddresses[0].value(forKey: "value") as? String
            } else {
                contactsEntity.emailAddress = ""
            }            
            contactsEntity.imageData = nil
        }
        appDelegate.saveContext()
        
        getRowsFromDB()
    }
    

    
    // Tableview delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return self.contacts.count
        return self.contactsFromDB.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "contactsCellId"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ContactListTVCell
        let cE = self.contactsFromDB[indexPath.row] as! ContactsEntity
        
        var fName = ""
        if let opt = cE.familyName {
            fName = opt
        }
        
        let completeName = "\(cE.givenName!) \(fName)"
        cell.contactNameLbl?.text = completeName
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let mainsb = UIStoryboard.init(name: "Main", bundle: nil)
//        let cdVc : ContactDetailsVC = mainsb.instantiateViewController(withIdentifier: "contactDetailsSbId") as! ContactDetailsVC
//        let cdVc = ContactDetailsVC()
        
//        cdVc.setContactDetail(cDetail: self.contactsFromDB[indexPath.row] as! ContactsEntity)
//        cdVc.myVarStr = "My Variable String Value"
//        cdVc.myConatStr = "My Constant String Value"
        self.performSegue(withIdentifier: "contactDetailsSegueId", sender: indexPath)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "contactDetailsSegueId"){
            let cdVc : ContactDetailsVC = segue.destination as! ContactDetailsVC
            cdVc.setContactDetail(cDetail: self.contactsFromDB[(sender as! NSIndexPath).row] as! ContactsEntity)

        }
        else if (segue.identifier == "addContactSegueId") {
            let adCVc : AddEditContactVC = segue.destination as! AddEditContactVC
            adCVc.newConatctAddedDelegate = self
        }
    }
    
    
    func newContactAddedRefreshList() -> Void {
        //TODO:: need to figure out to fetch newly inserted row instead of all list again
        getRowsFromDB()
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.contactsListTV.reloadData()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//extension ViewController : NewContactAdded {
//       func newContactAddedRefreshList() {
//        getRowsFromDB()
//        contactsListTV.reloadData()
//    }
//}


