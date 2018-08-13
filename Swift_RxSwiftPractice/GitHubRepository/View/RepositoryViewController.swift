//
//  RepositoryViewController.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/07/18.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import ObjectMapper

class RepositoryViewController: UIViewController {
    
    @IBOutlet weak var nameSearchBar: UISearchBar!
    @IBOutlet weak var repositoryListTableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    //ViewModelのインスタンス格納用のメンバ変数
    var repositoryViewModel: RepositoryViewModel!
    //検索ボックスの値の変化を監視対象にする
    var rx_searchBarText: Observable<String> {
        return self.nameSearchBar.rx.text
            .filter { $0 != nil }                             //入力値がnilの状態でない場合のみに絞る
            .map { $0! }                                      //mapでアンラップする
            .filter { $0.count > 0 }                          //入力値が1文字以上である場合のみに絞る
            .debounce(0.5, scheduler: MainScheduler.instance) //0.5秒のバッファを持たせる
            .distinctUntilChanged()                           //distinctUntilChanged : 変化がない間はイベントをスキップ
    }
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRx()
        self.setupUI()
    }
    /*
     ViewModelを経由してGitHubの情報を取得してテーブルビューに検索結果を表示
     【1】メンバ変数の初期化(repositoryViewModel)
       1.検索バーでの入力値の更新が「データ取得のトリガー」になる為、ViewModel側に定義したfetchRepositories()メソッドが実行される
       2.fetchRepositories()メソッドが実行後は、ViewModel側に定義したメンバ変数rx_repositoriesの値が更新される
     
     【2】UI表示に関する処理の流れの概要
     リクエストをして結果が更新されるたびにDriverからはObserverに対して通知が行われ、driveメソッドでバインドしている各UIの更新が働く
       1.テーブルビューへの一覧表示
       2.該当データが0件の場合はポップアップを表示
     */
    func setupRx() {
        self.repositoryViewModel = RepositoryViewModel(withNameObservable: self.rx_searchBarText)
        
        self.repositoryViewModel
            .rx_repositories
            .drive(self.repositoryListTableView.rx.items) { (tableView, row, repository) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell", for: IndexPath(row: row, section: 0))
                cell.textLabel?.text = repository.name
                cell.detailTextLabel?.text = repository.html_url
                return cell
            }
            .disposed(by: self.disposeBag)
        
        //リクエストした結果の更新を元に表示に関する処理を行う(取得したデータの件数に応じたエラーハンドリング処理)
        self.repositoryViewModel
            .rx_repositories
            .drive(onNext: { repositories in
                if repositories.count == 0 {
                    let alert = UIAlertController(title: ":(", message: "No repositories for this user.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    if self.navigationController?.visibleViewController is UIAlertController != true {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func setupUI() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped(_:)))
        self.repositoryListTableView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        self.tableViewBottomConstraint.constant = keyboardFrame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.updateConstraints()
        })
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.tableViewBottomConstraint.constant = 0.0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.updateConstraints()
        })
    }
    
    @objc func tableTapped(_ recognizer: UITapGestureRecognizer){
        //どのセルがタップされたかを検知
        let location = recognizer.location(in: self.repositoryListTableView)
        let path = self.repositoryListTableView.indexPathForRow(at: location)
        
        if self.nameSearchBar.isFirstResponder {
            self.nameSearchBar.resignFirstResponder()
        } else if let path = path {
            //タップされたセルを中央に持ってくる
            self.repositoryListTableView.selectRow(at: path, animated: true, scrollPosition: .middle)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
