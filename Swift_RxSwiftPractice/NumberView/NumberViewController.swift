//
//  NumberViewController.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/07/24.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NumberViewController: UIViewController {

    @IBOutlet weak var reslutLabel: UILabel!
    @IBOutlet weak var numberTextField1: UITextField!
    @IBOutlet weak var numberTextField2: UITextField!
    @IBOutlet weak var numberTextField3: UITextField!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Observable.combineLatest(self.numberTextField1.rx.text, self.numberTextField2.rx.text, self.numberTextField3.rx.text) {
//            numberText1, numberText2, numberText3 -> Int in
//            return (Int(numberText1!) ?? 0) + (Int(numberText2!) ?? 0) + (Int(numberText3!) ?? 0)
//            }
//            .map{ $0.description }
//            .bind(to: self.reslutLabel.rx.text)
//            .disposed(by: self.disposeBag)
        
        Observable.combineLatest(self.numberTextField1.rx.text, self.numberTextField2.rx.text, self.numberTextField3.rx.text) {
            numberText1, numberText2, numberText3 -> String in
            return (numberText1 ?? "") + (numberText2 ?? "") + (numberText3 ?? "")
            }
            .bind(to: self.reslutLabel.rx.text)
            .disposed(by: self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
