//
//  SimplePickerViewExampleViewController.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/07/30.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SimplePickerViewExampleViewController: UIViewController {
    
    @IBOutlet weak var pickerView1: UIPickerView!
    @IBOutlet weak var pickerView2: UIPickerView!
    @IBOutlet weak var pickerView3: UIPickerView!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        //Picker1
        Observable.just([1, 2, 3])
            .bind(to: self.pickerView1.rx.itemTitles) { _, item in
                return "\(item)"
            }
            .disposed(by: self.disposeBag)

        self.pickerView1.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selected 1: \(models)")
            })
            .disposed(by: self.disposeBag)

        //Picker2
        Observable.just([1, 2, 3])
            .bind(to: self.pickerView2.rx.itemAttributedTitles) { _, item in
            return NSAttributedString(string: "\(item)",
                attributes: [
                    NSAttributedStringKey.foregroundColor: UIColor.cyan,
                    NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleDouble.rawValue
                ])
            }
            .disposed(by: self.disposeBag)
        
        self.pickerView2.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                print("models selected 2: \(models)")
            })
            .disposed(by: self.disposeBag)

        //Picker3
        Observable.just([UIColor.red, UIColor.green, UIColor.blue])
            .bind(to: self.pickerView3.rx.items) { _, item, _ in
                let view = UIView()
                view.backgroundColor = item
                return view
            }
            .disposed(by: self.disposeBag)

        self.pickerView3.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { models in
                print("models selected 3: \(models)")
            })
            .disposed(by: self.disposeBag)
    }
}
