//
//  MyViewController.swift
//  ExDiffable
//
//  Created by 김종권 on 2023/04/21.
//

import Then
import UIKit
import SnapKit
import RxCocoa
import RxSwift
import ReactorKit

class MyViewController: UIViewController, ReactorKit.View {
    // MARK: UI
    private let tableView = UITableView(frame: .zero).then {
        $0.allowsSelection = false
        $0.backgroundColor = UIColor.clear
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.estimatedRowHeight = 34
    }
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12
    }
    private let appendButton = UIButton(type: .system).then {
        $0.setTitle("append", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.blue, for: .highlighted)
    }
    private let removeButton = UIButton(type: .system).then {
        $0.setTitle("remove", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.blue, for: .highlighted)
    }
    private let removeCenterButton = UIButton(type: .system).then {
        $0.setTitle("removeCenter", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.blue, for: .highlighted)
    }
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    let dataSource: MyDataSource
    
    // MARK: Initialize
    init() {
        self.dataSource = MyDataSource(tableView: tableView, cellProvider: { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = itemIdentifier.value.description
            return cell
        })
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Methods
    private func setupViews() {
        view.backgroundColor = .white
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(appendButton)
        stackView.addArrangedSubview(removeButton)
        stackView.addArrangedSubview(removeCenterButton)
        
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(500)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: Bind
    func bind(reactor: MyReactor) {
        // Action
        Observable
            .just(MyReactor.Action.load)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        appendButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.append }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        removeButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.remove }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        removeCenterButton.rx.tap
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.removeCenter }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map(\.items)
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { ss, items in
                ss.dataSource.update(items: items)
            }
            .disposed(by: self.disposeBag)
    }
}
