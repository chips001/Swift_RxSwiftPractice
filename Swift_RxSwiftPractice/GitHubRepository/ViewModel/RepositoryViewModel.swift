//
//  RepositoryViewModel.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/07/17.
//  Copyright © 2018年 一木 英希. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import ObjectMapper

class RepositoryViewModel {
    
    lazy var rx_repositories: Driver<[Repository]> = self.fetchRepositories()
    //監視対象のメンバ変数
    fileprivate var repositoryName: Observable<String>
    
    //監視対象の変数初期化処理
    init(withNameObservable nameObservable: Observable<String>) {
        self.repositoryName = nameObservable
    }
    
    //GitHubAPIへアクセスしてデータを取得してViewController側のUI処理とバインドするためにDriverに変換する処理
    fileprivate func fetchRepositories() -> Driver<[Repository]> {
        /*
         Observableな変数に対して「.subscribeOn」「 .observeOn」「 .observeOn」...といった形で数珠つなぎで処理」を実行
         処理の終端まで無事にたどり着いた場合にはObservableをDriverに変換して返却
         */
        return self.repositoryName
            //処置Phase1: 見た目に関する処理
            .subscribeOn(MainScheduler.instance)
            .do(onNext: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            
            //処理Phase2: GitHubAPIのエンドポイントへRxAlamofire経由でアクセス
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest { text in
                return RxAlamofire
                    .requestJSON(.get, "https://api.github.com/users/\(text)/repos")
                    .debug()
                    .catchError { error in
                        return Observable.never()
                }
            }
            
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { (response, json) -> [Repository] in
                if let repos = Mapper<Repository>().mapArray(JSONObject: json){
                    return repos
                } else {
                    return []
                }
            }
            
            .observeOn(MainScheduler.instance)
            .do(onNext: { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: [])
    }
}
