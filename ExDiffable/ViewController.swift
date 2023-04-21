//
//  ViewController.swift
//  ExDiffable
//
//  Created by 김종권 on 2023/04/21.
//

import UIKit
import RxSwift
import SnapKit
import Then

class ViewController: UIViewController {
    private let button = UIButton(type: .system).then {
        $0.setTitle("버튼", for: .normal)
        $0.setTitleColor(.systemBlue, for: .normal)
        $0.setTitleColor(.blue, for: .highlighted)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        button.rx.tap
            .bind(with: self) { ss, _ in
                let vc = MyViewController().then {
                    $0.reactor = .init()
                    $0.modalPresentationStyle = .fullScreen
                }
                ss.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
