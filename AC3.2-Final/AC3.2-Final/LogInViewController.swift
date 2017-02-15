//
//  LogInViewController.swift
//  AC3.2-Final
//
//  Created by Tong Lin on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class LogInViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewHierarchy()
        configureConstraints()
        
    }
    
    func configureConstraints(){
        logoView.snp.makeConstraints { (view) in
            view.centerX.equalToSuperview()
            view.top.equalToSuperview().offset(40)
            view.size.equalTo(CGSize(width: self.view.frame.height/3, height: self.view.frame.height/3))
        }
        
        usernameTextField.snp.makeConstraints { (view) in
            view.top.equalTo(logoView.snp.bottom).offset(60)
            view.centerX.equalToSuperview()
            view.width.equalTo(self.view.frame.width/1.3)
        }
        
        passwordTextField.snp.makeConstraints { (view) in
            view.top.equalTo(usernameTextField.snp.bottom).offset(20)
            view.centerX.equalToSuperview()
            view.width.equalTo(self.view.frame.width/1.3)
        }
        
        loginButton.snp.makeConstraints { (view) in
            view.top.equalTo(passwordTextField.snp.bottom).offset(45)
            view.centerX.equalToSuperview()
        }
        
        registerButton.snp.makeConstraints { (view) in
            view.top.equalTo(loginButton.snp.bottom).offset(10)
            view.centerX.equalToSuperview()
        }
    }
    
    func setupViewHierarchy(){
        self.view.backgroundColor = .white
        
        self.view.addSubview(logoView)
        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
    }
    
    func pushMainView(){
        let feedViewC = FeedViewController()
        let uploadViewC = UploadViewController()
        
        let feedIcon = UITabBarItem(title: "Feed", image: UIImage(named: "chickenleg"), selectedImage: UIImage(named: "chickenleg"))
        let uploadIcon = UITabBarItem(title: "Upload", image: UIImage(named: "upload"), selectedImage: UIImage(named: "upload"))
        
        feedIcon.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -10, right: 0)
        uploadIcon.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -10, right: 0)
        feedViewC.tabBarItem = feedIcon
        uploadViewC.tabBarItem = uploadIcon
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = UIColor.blue
        tabBarController.viewControllers = [UINavigationController(rootViewController: feedViewC), UINavigationController(rootViewController: uploadViewC)]
        tabBarController.selectedIndex = 0
        
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    func loginTapped(){
        print("login")
        if let username = usernameTextField.text,
            let password = passwordTextField.text{
            loginButton.isEnabled = false
            FIRAuth.auth()?.signIn(withEmail: username, password: password, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print("Erro \(error)")
                }
                if user != nil {
                    print("SUCCESS.... \(user!.uid)")
                    self.showAlert(title: "Login Successful", message: nil, completion: true)
                } else {
                    self.showAlert(title: "Login Failed", message: error?.localizedDescription, completion: false)
                }
                self.loginButton.isEnabled = true
            })
        }
    }
    
    func registerTapped(){
        print("register")
        if let email = usernameTextField.text, let password = passwordTextField.text {
            registerButton.isEnabled = false
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                if error != nil {
                    print("error with completion while creating new Authentication: \(error!)")
                }
                if user != nil {
                    self.showAlert(title: "Register Successful", message: nil, completion: true)
                    
                } else {
                    self.showAlert(title: "Register Failed", message: error?.localizedDescription, completion: false)
                }
                self.registerButton.isEnabled = true
            })
        }
    }
    
    func showAlert(title: String, message: String?, completion: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel) { (a) in
            if completion{
                self.pushMainView()
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }

   //MARK: - Lazy inits
    
    lazy var logoView: UIImageView = {
        let view = UIImageView()
        let image = UIImage(named: "meatly_logo")
        view.image = image
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var usernameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Email..."
        view.borderStyle = .roundedRect
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Password"
        view.borderStyle = .roundedRect
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var loginButton: UIButton = {
        let view = UIButton()
        view.setTitle("LOGIN", for: .normal)
        view.setTitleColor(.blue, for: .normal)
        view.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        view.contentMode = .center
        view.isEnabled = true
        return view
    }()
    
    lazy var registerButton: UIButton = {
        let view = UIButton()
        view.setTitle("REGISTER", for: .normal)
        view.setTitleColor(.blue, for: .normal)
        view.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
        view.contentMode = .center
        view.isEnabled = true
        return view
    }()
    
}
