//
//  AccountViewController.swift
//  AccountKitSampleSwift
//
//  Created by Julian Shen on 2016/10/9.
//  Copyright © 2016年 cowbay.wtf. All rights reserved.
//

import UIKit
import AccountKit

class AccountViewController: UIViewController {

    @IBOutlet weak var accountIDLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stateValueLabel: UILabel!
    
    @IBOutlet weak var stateTitleLabel: UILabel!
    
    var accountKitState:String? {
        didSet {
            if accountKitState != oldValue && self.isViewLoaded {
                _updateStateLabels()
            }
        }
    }
    
    var _accountKit:AKFAccountKit?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _updateStateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        if _accountKit == nil {
            _accountKit = AKFAccountKit.init(responseType: AKFResponseType.accessToken)
            _accountKit?.requestAccount({ (account, error) in
                self.accountIDLabel.text = account?.accountID
                if let email = account?.emailAddress {
                    self.titleLabel.text = "Email Address"
                    self.valueLabel.text = email
                } else {
                    self.titleLabel.text = "Phone Number"
                    self.valueLabel.text = account?.phoneNumber?.stringRepresentation()
                }
            })
        }
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        _accountKit?.logOut()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func _updateStateLabels() {
        if accountKitState == nil || accountKitState == "" {
            self.stateTitleLabel.isHidden = true
            self.stateValueLabel.isHidden = true
        } else {
            self.stateTitleLabel.isHidden = false
            self.stateValueLabel.isHidden = false
            self.stateValueLabel.text = accountKitState
        }
    }
}
