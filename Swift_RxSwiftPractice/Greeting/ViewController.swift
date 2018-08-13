//
//  ViewController.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/07/05.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
//    enum State: Int {
//        case useButtons
//        case useTextField
//    }
//
//    @IBOutlet weak var greetingLabel: UILabel!
//    @IBOutlet weak var stateSegmentedControl: UISegmentedControl!
//    @IBOutlet weak var freeTextField: UITextField!
//    @IBOutlet weak var nameTextField: UITextField!
//    //OutletCollectionで接続
//    @IBOutlet var greetingButtons: [UIButton]!
//
//    let lastSelectedGreeding: BehaviorRelay<String> = BehaviorRelay(value: "こんにちは")
//
//    let disposeBag = DisposeBag()
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        /*
//         combineLatest : 受け取った値の直近の最新の値同士の結合
//         map           : 受け取った値を別の要素への変換
//         subscribe     : イベント発生時にイベントの状態に応じて処理を行う
//         */
//
//        //1.観測対象として登録
//        let nameObservable: Observable<String?> = self.nameTextField.rx.text.asObservable()
//        let freeObservable: Observable<String?> = self.freeTextField.rx.text.asObservable()
//        //2.「name」と「free」の直近の最新同士を結合
//        let freewordWithNameObservable: Observable<String?> = Observable.combineLatest(
//            nameObservable,
//            freeObservable
//        ) { (name: String?, free: String?) in
//            return name! + free!
//        }
//        //3.bindToの引数内に表示対象のUIパーツを設定してイベントのプロパティ接続する
//        freewordWithNameObservable
//            .bind(to: self.greetingLabel.rx.text)
//            .disposed(by: self.disposeBag)
//
//        //1.観測対象の登録
//        let segmentControlObservable: Observable<Int> = self.stateSegmentedControl.rx.value.asObservable()
//        //2.segmentControlの値の変化を検知して、その状態に対応するenumの値を返す。map: 別の要素へ変換(Int → State)
//        let stateObservable: Observable<State> = segmentControlObservable.map {
//            selectIndex -> State in
//            return State(rawValue: selectIndex)!
//        }
//        //enumの値変化を検知してテキストフィールドが編集を受ける状態かを返す。map: 別の要素へ変換(Int → Bool)
//        let greetingTextFieldEnabledObservable: Observable<Bool> = stateObservable.map {
//            state -> Bool in
//            return state == .useTextField
//        }
//        //3.bindToの引数内に表示対象のUIパーツを設定してイベントのプロパティ接続する
//        greetingTextFieldEnabledObservable
//            .bind(to: self.freeTextField.rx.isEnabled)
//            .disposed(by: self.disposeBag)
//
//        let buttonEnabledObservable: Observable<Bool> = greetingTextFieldEnabledObservable.map {
//            (greetingEnabled: Bool) -> Bool in
//            return !greetingEnabled
//        }
//        self.greetingButtons.forEach {
//            button in
//            buttonEnabledObservable.bind(to: button.rx.isEnabled)
//            .disposed(by: self.disposeBag)
//
//            button.rx.tap.subscribe(onNext: {
//                (nothing: Void) in
//                self.lastSelectedGreeding.accept(button.currentTitle!)
//            })
//            .disposed(by: self.disposeBag)
//        }
//
//        //1.観測対象の登録
//        let predefinedGreetingObservable: Observable<String> = self.lastSelectedGreeding.asObservable()
//        //2.現在入力または選択がされている項目を全て結合する
//        let finalGreetingObservable: Observable<String> = Observable.combineLatest(
//            stateObservable, freeObservable, predefinedGreetingObservable, nameObservable
//        ) {
//            (state: State, freeword: String?, prefindGreeting: String, name: String?) -> String in
//            switch state {
//            case .useTextField: return freeword! + name!
//            case .useButtons: return prefindGreeting + name!
//            }
//        }
//        //3.bindToの引数内に表示対象のUIパーツを設定してイベントのプロパティ接続する
//        finalGreetingObservable
//            .bind(to: self.greetingLabel.rx.text)
//            .disposed(by: self.disposeBag)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
    }
}

