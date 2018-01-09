//
//  LoginViewController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/1/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController, AttachableType {

    var viewModel: LoginViewModel!
    var bindings: LoginViewModel.Bindings {
        return LoginViewModel.Bindings(
            username: loginTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            loginTaps: loginButton.rx.tap.asDriver(),
            signupTaps: signupButton.rx.tap.asDriver(),
            doneTaps: passwordTextField.rx.controlEvent(.editingDidEndOnExit).asDriver(),
            cancelTaps: cancelButtonItem.rx.tap.asDriver()
        )
    }

    let disposeBag = DisposeBag()

    // MARK: Interface
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        if self.presentingViewController != nil {
            navigationItem.leftBarButtonItem = cancelButtonItem
            signupButton.isHidden = true
        }
    }

    // MARK: - View Methods

    func bindViewModel() {
        viewModel.isValid
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.loggingIn
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)

        // Next keyboard button
        loginTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] _ in
                self?.passwordTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }

}
