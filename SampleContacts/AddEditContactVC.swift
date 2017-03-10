//
//  AddEditContactVC.swift
//  SampleContacts
//
//  Created by Ranganatha Veeranagappa on 3/2/17.
//  Copyright © 2017 Ranganatha Veeranagappa. All rights reserved.
//

import UIKit
import CoreData


@objc protocol NewContactAdded {
    @objc optional func newContactAddedRefreshList() -> Void
    @objc optional func contactEditted(cE: ContactsEntity) -> Void
}

class AddEditContactVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    var forEdit : String = ""
    var contactDetailsParams = ContactsEntity()
    var newConatctAddedDelegate : NewContactAdded!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if !forEdit.isEmpty && forEdit == "YES" {
            self.nameTF.text = self.contactDetailsParams.givenName
            self.phoneNumTF.text = self.contactDetailsParams.phoneNumber
            self.emailTF.text = self.contactDetailsParams.emailAddress
        }
        
        let pCoOrdinator =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
        let bgMoC = NSManagedObjectContext.init(concurrencyType:NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        bgMoC.persistentStoreCoordinator = pCoOrdinator

        
        NotificationCenter.default.addObserver(self, selector:#selector(AddEditContactVC.persistentStoreCoordinatorDidSave(notification:)), name: Notification.Name.NSManagedObjectContextDidSave, object: pCoOrdinator)
        
    }
    
    func persistentStoreCoordinatorDidSave(notification: NSNotification) {
        let dictionary = notification.userInfo!
        print(dictionary)
        let moc: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        DispatchQueue.main.async {
            moc.mergeChanges(fromContextDidSave: notification as Notification)
        }
//        moc.perform { () -> Void in
//          moc.mergeChanges(fromContextDidSave: notification as Notification)
//        }
    }
    func setContactDetail(cDetail:ContactsEntity) -> Void {
        self.contactDetailsParams = cDetail
    }

    @IBAction func cancelButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.persistentContainer.viewContext
        
        if (!forEdit.isEmpty && forEdit == "YES"  ) { // edit existing Contact
            
//            let pCoOrdinator =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.persistentStoreCoordinator
//            let bgMoC = appDelegate.persistentContainer.newBackgroundContext()
////            let bgMoc = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
//            bgMoC.persistentStoreCoordinator = pCoOrdinator
            
                self.contactDetailsParams.givenName = self.nameTF.text
                self.contactDetailsParams.phoneNumber = self.phoneNumTF.text
                self.contactDetailsParams.emailAddress = self.emailTF.text
            
//                appDelegate.saveOtherContext(contextToSave: bgMoC)
                appDelegate.saveContext()
                self.newConatctAddedDelegate?.contactEditted!(cE: self.contactDetailsParams)            
            
        } else { // add new contact to DB
            let newcE = NSEntityDescription.insertNewObject(forEntityName: "ContactsEntity", into: moc) as! ContactsEntity
            newcE.givenName = nameTF.text
            newcE.phoneNumber = phoneNumTF.text
            newcE.emailAddress = emailTF.text
            appDelegate.saveContext()
            
            newConatctAddedDelegate?.newContactAddedRefreshList!()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEqual(nameTF) {
            nameTF.text = textField.text
            phoneNumTF.becomeFirstResponder()
        } else if textField.isEqual(phoneNumTF) {
            phoneNumTF.text = textField.text
            emailTF.becomeFirstResponder()
        } else if textField.isEqual(emailTF) {
            emailTF.text = textField.text
            
        }
        
    }
    
//    func persistentStoreDidImportUbiquitousContentChanges(notification: NSNotification) {
//        let dictionary = notification.userInfo!
//        println(dictionary)
//        var moc: NSManagedObjectContext = self.managedObjectContext!
//        moc.performBlock { () -> Void in
//            moc.mergeChangesFromContextDidSaveNotification(notification)
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
