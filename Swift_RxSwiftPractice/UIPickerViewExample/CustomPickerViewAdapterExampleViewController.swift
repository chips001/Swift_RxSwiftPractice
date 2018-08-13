//
//  CustomPickerViewAdpterExampleViewController.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/07/30.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CustomPickerViewAdapterExampleViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Observable.just([[1, 2, 3], [5, 8, 13], [21, 34]])
            .bind(to: self.pickerView.rx.items(adapter: PickerViewViewAdapter()))
            .disposed(by: self.disposeBag)
        
        self.pickerView.rx.modelSelected(Int.self)
            .subscribe(onNext: { models in
                //modelsに現在選択している連番3桁が変化する都度返ってくる
                print(models)
            })
            .disposed(by: self.disposeBag)
    }
}

/*
 Binder: Bindableにする。第一引数で渡したインスタンスがクロージャの第一引数へ(下記だとself(PickerViewViewAdapter))、
         クロージャの第二引数に渡ってくる値が入る
 */
final class PickerViewViewAdapter: NSObject, UIPickerViewDataSource, UIPickerViewDelegate, RxPickerViewDataSourceType, SectionedViewDataSourceType {
    
    typealias Element = [[CustomStringConvertible]]
    private var items: [[CustomStringConvertible]] = []
    
    // MARK: SectionedViewDataSourceType (RxCocoa)
    func model(at indexPath: IndexPath) throws -> Any {
        return items[indexPath.section][indexPath.row]
    }
    
    // MARK: UIPickerViewDataSource
    /*
     列数を返す
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return items.count
    }
    
    // MARK: UIPickerViewDataSource
    /*
     行数を返す。UIPickerViewDataSourceの必須メソッド
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items[component].count
    }
    
    // MARK: UIPickerViewDelegate
    /*
     Picker内の要素のカスタマイズを行う時に使用するメソッド
     */
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.text = items[component][row].description
        label.textColor = UIColor.orange
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textAlignment = .center
        return label
    }
    
    // MARK: RxPickerViewDataSourceType
    func pickerView(_ pickerView: UIPickerView, observedEvent: Event<[[CustomStringConvertible]]>) {
        Binder(self) { adapter, items in
            adapter.items = items
            pickerView.reloadAllComponents()
        }.on(observedEvent)
    }
}
