//
//  SimpleRxViewController.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/07/23.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SimpleRxViewController: UIViewController {

    @IBOutlet weak var simpleRxLabel: UILabel!
    @IBOutlet weak var simpleRxTextField: UITextField!
    @IBOutlet weak var simpleRxButton: UIButton!
    let disposedbag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Observable : 送るオブジェクトを複数保持しているもの
         subscribe  : 通知受信するメソッド
         */
        
        self.simpleRxButton.rx.tap
            .subscribe { [unowned self] _ in
            self.showAlert()
        }.disposed(by: self.disposedbag)
        
        self.simpleRxTextField.rx.text
            .map { "Your Text is \($0 ?? "")" }
            .bind(to: self.simpleRxLabel.rx.text)
            .disposed(by: self.disposedbag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "Can you see a alert?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
