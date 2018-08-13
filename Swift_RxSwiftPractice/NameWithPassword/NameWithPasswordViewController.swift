//
//  NameWithPasswordViewController.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/07/25.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NameWithPasswordViewController: UIViewController {
    
    let minimalUsernameLength = 5
    let minimalPasswordLength = 5

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var validButton: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.text = "UserName has to be at least \(self.minimalUsernameLength) characters"
        self.passwordLabel.text = "UserName has to be at least \(self.minimalPasswordLength) characters"
        
        
        /*
         .share(replay: 1, scope: .forever) : HotObservableの1つで、ColdObservableだと複数にbindするとその回数分呼ばれてしまうが、
                                              HotObservableだと1度だけ呼ばれ、bindした先全てに反映ができる
         https://qiita.com/toRisouP/items/f6088963037bfda658d3
         */
        let nameValid = self.nameTextField.rx.text
            .map { ($0?.count)! >= self.minimalUsernameLength }
            .share(replay: 1)
        
        let passwordValid = self.passwordTextField.rx.text
            .map { ($0?.count)! > self.minimalPasswordLength }
            .share(replay: 1)
        
        let everythingValid = Observable.combineLatest(nameValid, passwordValid){
            $0 && $1
            }
            .share(replay: 1)
        
        nameValid.bind(to: self.passwordTextField.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        nameValid.bind(to: self.nameLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        passwordValid.bind(to: self.passwordLabel.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        everythingValid.bind(to: self.validButton.rx.isEnabled)
            .disposed(by: self.disposeBag)
        
        self.validButton.rx.tap.subscribe( onNext: {
            [weak self] in
            self?.showAlert()
        })
            .disposed(by: self.disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "RxExample", message: "This is wonderful", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
