//
//  NumbersViewController.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/08/13.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NumbersViewController: ViewController {

    @IBOutlet weak var number1TextField: UITextField!
    @IBOutlet weak var number2TextField: UITextField!
    @IBOutlet weak var number3TextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         combineLatest: 複数のObservableの最新値同士を組み合わせる
         orEmpty: から文字やnilをオブサーブしない
         .description: 数値をStringに変換する。String(数値)でも文字列化できるが、少数やマイナス値だとエラーになる
        */ 
        
        Observable.combineLatest(self.number1TextField.rx.text.orEmpty, self.number2TextField.rx.text.orEmpty, self.number3TextField.rx.text.orEmpty) { number1TextValue, number2TextValue, number3TextValue -> Int in
            return (Int(number1TextValue) ?? 0) + (Int(number2TextValue) ?? 0) + (Int(number3TextValue) ?? 0)
            }
            .map { $0.description }
            .bind(to: self.resultLabel.rx.text)
            .disposed(by: self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
