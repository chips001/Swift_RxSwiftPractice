//
//  SimpleValidationViewController.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/08/15.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleValidationViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userNameValidLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordValidLabel: UILabel!
    @IBOutlet weak var doSomethingButton: UIButton!
    
    fileprivate let minimalUserNameLength = 5
    fileprivate let minimalPasswordLength = 5
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userNameValidLabel.text = "Username has to be at least \(self.minimalUserNameLength) characters"
        self.passwordValidLabel.text = "Username has to be at least \(self.minimalPasswordLength) characters"
        
        let usernameValid = self.userNameTextField.rx.text.orEmpty
            .map { $0.count >= self.minimalUserNameLength }
            .share(replay: 1)
        
        let passwordValid = self.passwordTextField.rx.text.orEmpty
            .map { $0.count >= self.minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable
            .combineLatest(usernameValid, passwordValid)
            .map { $0 && $1 }
            .share(replay: 1)
        
        usernameValid
            .bind(to: self.passwordTextField.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        usernameValid
            .bind(to: self.userNameValidLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        passwordValid
            .bind(to: self.passwordValidLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        everythingValid
            .bind(to: self.doSomethingButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        self.doSomethingButton.rx.tap
            .subscribe ( onNext: { [weak self] _ in
            self?.showAlert()
            }).disposed(by: self.disposeBag)
    }
    
    func showAlert() {
        let alertController = UIAlertController(
            title: "RxExample",
            message: "This is wonderful",
            preferredStyle: .alert
        )
        let alertAction = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
