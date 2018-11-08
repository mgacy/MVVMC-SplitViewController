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

class LoginViewController: UIViewController, ViewModelAttaching {

    var viewModel: Attachable<LoginViewModel>!
    lazy var bindings: LoginViewModel.Bindings = {
        return LoginViewModel.Bindings(
            username: loginTextField.rx.text.orEmpty.asDriver(),
            password: passwordTextField.rx.text.orEmpty.asDriver(),
            loginTaps: loginButton.rx.tap.asDriver(),
            signupTaps: signupButton.rx.tap.asDriver(),
            doneTaps: passwordTextField.rx.controlEvent(.editingDidEndOnExit).asDriver(),
            cancelTaps: cancelButtonItem.rx.tap.asDriver()
        )
    }()

    let disposeBag = DisposeBag()

    // MARK: Interface

    let loginTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Email"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        view.clearButtonMode = .whileEditing
        view.textAlignment = .left
        // UITextInputTraits
        view.autocapitalizationType = .none
        view.autocorrectionType = .no
        view.keyboardType = .emailAddress
        view.returnKeyType = .next
        view.spellCheckingType = .no
        view.textContentType = .emailAddress
        return view
    }()

    let passwordTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Password"
        view.isSecureTextEntry = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.borderStyle = .roundedRect
        view.clearButtonMode = .whileEditing
        view.textAlignment = .left
        // UITextInputTraits
        view.autocapitalizationType = .none
        view.returnKeyType = .go
        view.spellCheckingType = .no
        return view
    }()

    let loginButton: UIButton = {
        let view = UIButton()
        view.setTitle("Login", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.setTitleColor(.red, for: .highlighted)
        view.backgroundColor = UIColor.blue
        return view
    }()

    let signupButton: UIButton = {
        let view = UIButton()
        view.setTitle("Signup", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.blue.cgColor
        view.setTitleColor(.blue, for: .normal)
        view.setTitleColor(.red, for: .highlighted)
        view.backgroundColor = .clear
        return view
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [loginTextField, passwordTextField, loginButton, signupButton])
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fillEqually
        view.spacing = 8.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let cancelButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        if self.presentingViewController != nil {
            navigationItem.leftBarButtonItem = cancelButtonItem
            signupButton.isHidden = true
        }
    }

    // MARK: - View Methods

    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
    }

    private func setupConstraints() {
        let guide = view.safeAreaLayoutGuide
        let height = view.frame.height
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: height / 4.0),
            stackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16.0)
            //stackView.widthAnchor.constraint(lessThanOrEqualToConstant: 380.0)
        ])
    }

    func bind(viewModel: LoginViewModel) -> LoginViewModel {
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

        return viewModel
    }

}
