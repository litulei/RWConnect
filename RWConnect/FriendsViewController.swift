/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import Contacts
import ContactsUI

class FriendsViewController: UIViewController {
  
    @IBOutlet weak var tableView: UITableView!
    var friendsList = Friend.defaultContacts()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = UIImageView(image: UIImage(named: "RWConnectTitle")!)
        tableView.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
  }
    @IBAction func addFriends(_ sender: UIBarButtonItem) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        present(contactPicker, animated: true, completion: nil)
    }
    
    func presentPermissonErrorAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Could not save contact", message: "How am I supposed to add the contact if you didn't give me permission", preferredStyle: .alert)
            let openSettingsAction = UIAlertAction(title: "Settings", style: .default, handler: { (alert) in
                UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
            })
            let dismissAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(openSettingsAction)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func saveFriendToContacts(friend: Friend) {
        // 1
        let contactFormatter = CNContactFormatter()
        // 2
        let contactName = contactFormatter.string(from: friend.contactValue)!
        // 3
        let predicateForMatchingName = CNContact.predicateForContacts(matchingName: contactName)
        // 4
        let matchContacts = try! CNContactStore().unifiedContacts(matching: predicateForMatchingName, keysToFetch: [])
        // 5
        guard matchContacts.isEmpty else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "contact already exists", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        // 1
        let contact = friend.contactValue.mutableCopy() as! CNMutableContact
        // 2
        let saveRequest = CNSaveRequest()
        // 3
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        do {
            // 4
            let contactStore = CNContactStore()
            try contactStore.execute(saveRequest)
            // show Success Alert
            DispatchQueue.main.async {
                let successAlert = UIAlertController(title: "Contacts Saved", message: nil, preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(successAlert, animated: true, completion: nil)
            }
        } catch {
            // show Failure Alert
            DispatchQueue.main.async {
                let failure = UIAlertController(title: "Contacts Saved", message: nil, preferredStyle: .alert)
                failure.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(failure, animated: true, completion: nil)
            }
        }
        
    }
    
}

//MARK: UITableViewDataSource
extension FriendsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as? FriendCell else { return UITableViewCell() }
        let friend = friendsList[indexPath.row]
        cell.friend = friend
        return cell
    }
    
}

extension FriendsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // 1
        let friend = friendsList[indexPath.row]
        let contact = friend.contactValue
        // 2
        let contactViewController = CNContactViewController(forUnknownContact: contact)
        contactViewController.navigationItem.title = "Profile"
        contactViewController.hidesBottomBarWhenPushed = true
        // 3
        contactViewController.allowsEditing = false
        contactViewController.allowsActions = false
        // 4
        navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let createContact = UITableViewRowAction(style: .normal, title: "Create Contact") { (rowAction, indexPath) in
            let contactStore = CNContactStore()
            contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (userGrantAccess, _) in
                guard userGrantAccess else {
                    self.presentPermissonErrorAlert()
                    return
                }
                let friend = self.friendsList[indexPath.row]
                self.saveFriendToContacts(friend: friend)
            })
        }
        createContact.backgroundColor = BlueColor
        return [createContact]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}

extension FriendsViewController: CNContactPickerDelegate {
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: CNContact) {
//
//    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        let newFriends = contacts.map { Friend(contact: $0) }
        for friend in newFriends {
            if !friendsList.contains(friend) {
                friendsList.append(friend)
            }
        }
        tableView.reloadData()
    }
}
  
  

