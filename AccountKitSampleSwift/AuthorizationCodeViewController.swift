//
//  AuthorizationCodeViewController.swift
//  AccountKitSampleSwift
//
//  Created by Julian Shen on 2016/10/9.
//  Copyright © 2016年 cowbay.wtf. All rights reserved.
//

import UIKit

class AuthorizationCodeViewController: UIViewController {

    @IBOutlet weak var authorizationCodeView: UITextView!
    @IBOutlet weak var stateTitleLabel: UILabel!
    @IBOutlet weak var stateValueLabel: UILabel!
    
    var accountKitAuthorizationCode:String? {
        didSet {
            if oldValue != accountKitAuthorizationCode && self.isViewLoaded {
                self._updateAuthorizationCodeView()
            }
        }
    }
    
    var accountKitState:String? {
        didSet {
            if oldValue != accountKitState && self.isViewLoaded {
                self._updateStateLabels()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _updateAuthorizationCodeView()
        _updateStateLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func back(_ sender: AnyObject) {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    private func _updateAuthorizationCodeView() {
        self.authorizationCodeView.text = accountKitAuthorizationCode
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
