//
//  SignupViewController.swift
//  MVVMC-SplitViewController
//
//  Created by Mathew Gacy on 1/1/18.
//  Copyright © 2018 Mathew Gacy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SignupViewController: UIViewController, AttachableType {

    var viewModel: SignupViewModel!
    var bindings: SignupViewModel.Bindings {
        return SignupViewModel.Bindings(
            firstName: firstNameTextField.rx.text.orEmpty.asDriver(),
            lastName: lastNameTextField.rx.text.orEmpty.asDriver(),
            login: loginTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            cancelTaps: cancelButton.rx.tap.asDriver(),
            signupTaps: signupButton.rx.tap.asDriver(),
            doneTaps: passwordTextField.rx.controlEvent(.editingDidEndOnExit).asDriver()
        )
    }

    let disposeBag = DisposeBag()

    // MARK: Interface
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Methods

    private func setupView() {
        title = "Signup"
        self.navigationItem.leftBarButtonItem = cancelButton
    }

    func bindViewModel() {
        viewModel.isValid
            .drive(signupButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.signingUp
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)

        // Next keyboard button
        firstNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { _ in
                self.lastNameTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)

        lastNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { _ in
                self.loginTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)

        loginTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { _ in
                self.passwordTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
    }

}
