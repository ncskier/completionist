//
//  NameTableViewCell.swift
//  completionist
//
//  Created by Brandon Walker on 7/21/16.
//  Copyright © 2016 Brandon Walker. All rights reserved.
//

import UIKit


protocol NameTableViewCellDelegate {
    
    func nameTableViewCell(nameTableViewCell: NameTableViewCell, textFieldValueDidChangeTo newValue: String)
    
    func nameTableViewCellDidBeginEditing(nameTableViewCell: NameTableViewCell)
    
    func nameTableViewCellDidReturn(nameTableViewCell: NameTableViewCell)
}


class NameTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var delegate: NameTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Set nameText Field Delegate
        nameTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func loadCell(name: String?, delegate: NameTableViewCellDelegate?) {
        
        nameTextField.text = name
        self.delegate = delegate
    }
    
    
    // MARK: - IBActions
    
    @IBAction func textFieldDidBeginEditing(_ sender: UITextField) {
        if (delegate != nil) {
            delegate!.nameTableViewCellDidBeginEditing(nameTableViewCell: self)
        }
    }
    
    @IBAction func textFieldValueChanged(_ sender: UITextField) {
        
        if (delegate != nil) {
            delegate?.nameTableViewCell(nameTableViewCell: self, textFieldValueDidChangeTo: sender.text!)
        }
    }
    
    
    // MARK: - UITextField Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameTextField.resignFirstResponder()
        
        if (delegate != nil) {
            delegate?.nameTableViewCellDidReturn(nameTableViewCell: self)
        }
        
        return true
    }
    
}
