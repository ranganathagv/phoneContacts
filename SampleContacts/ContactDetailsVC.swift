//
//  ContactDetailsVC.swift
//  SampleContacts
//
//  Created by Ranganatha Veeranagappa on 2/28/17.
//  Copyright © 2017 Ranganatha Veeranagappa. All rights reserved.
//

import UIKit


class ContactDetailsVC: UIViewController, NewContactAdded {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var emailIdTF: UITextField!
    var contactDetailsParams = ContactsEntity()
    var contactEditedDelegate : NewContactAdded!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTF.text = self.contactDetailsParams.givenName
        self.phoneNumberTF.text = self.contactDetailsParams.phoneNumber
        self.emailIdTF.text = self.contactDetailsParams.emailAddress
    }
    
    func setContactDetail(cDetail:ContactsEntity) -> Void {
        self.contactDetailsParams = cDetail
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editContactSegueId" {
            
            let adEditVc : AddEditContactVC = segue.destination as! AddEditContactVC
            adEditVc.setContactDetail(cDetail: self.contactDetailsParams)
            adEditVc.forEdit = "YES"
            adEditVc.newConatctAddedDelegate = self
        }
        
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        
        
//        let cListVc = ViewController()
//        self.contactEditedDelegate = cListVc
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.persistentContainer.viewContext
        
        moc.delete(contactDetailsParams)
        appDelegate.saveContext()
        _ = self.navigationController?.popViewController(animated: true)
//        contactEditedDelegate?.newContactAddedRefreshList!()
    }
}

extension ContactDetailsVC  {
    @objc func contactEditted(cE: ContactsEntity) {
        nameTF.text = cE.givenName
        phoneNumberTF.text = cE.phoneNumber
        emailIdTF.text = cE.emailAddress
    }
}
