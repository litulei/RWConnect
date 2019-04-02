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

@IBDesignable
class FriendCell: UITableViewCell {

    var contactNameLabel = UILabel()
    var contactEmailLabel = UILabel()
    var contactImageView = UIImageView() {
    didSet {
      
    }
  }
  
  var friend : Friend? {
    didSet {
      configureCell()
    }
  }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contactImageView.translatesAutoresizingMaskIntoConstraints = false
        contactEmailLabel.translatesAutoresizingMaskIntoConstraints = false
        contactNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contactImageView.layer.masksToBounds = true
        contactImageView.layer.cornerRadius = 22.0
        contentView.addSubview(contactNameLabel)
        contentView.addSubview(contactEmailLabel)
        contentView.addSubview(contactImageView)
        
        contentView.addConstraint(contactImageView.heightAnchor.constraint(equalToConstant: 40))
        contentView.addConstraint(contactImageView.widthAnchor.constraint(equalToConstant: 40))
        contentView.addConstraint(contactImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20))
        contentView.addConstraint(contactImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20))
        contentView.addConstraint(contactNameLabel.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 20))
        contentView.addConstraint(contactNameLabel.topAnchor.constraint(equalTo: contactImageView.topAnchor))
        contentView.addConstraint(contactEmailLabel.leadingAnchor.constraint(equalTo: contactImageView.trailingAnchor, constant: 20))
        contentView.addConstraint(contactEmailLabel.topAnchor.constraint(equalTo: contactNameLabel.bottomAnchor))
        contentView.addConstraint(contactEmailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20))
        
        configureCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
    if let friend = friend {
      contactNameLabel.text = friend.firstName + " " + friend.lastName
        contactEmailLabel.text = friend.workEmail as String
      contactImageView.image = friend.profilePicture
    }
  }
}
