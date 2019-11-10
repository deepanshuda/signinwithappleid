//
//  ViewController.swift
//  AppleIdDemo
//
//  Created by DeepMacPro on 09/11/19.
//  Copyright © 2019 Deepanshu. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginController: UIViewController {
    
    @IBOutlet weak var loginStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign in with Apple"
        setupView()
    }

    func setupView() {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleAppleIDAuthorization), for: .touchUpInside)
        
        loginStackView.addArrangedSubview(button)
    }
    
    @objc
    func handleAppleIDAuthorization() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
}

extension LoginController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential:
            let userId = credential.user
            print("User Identifier: ", userId)
            
            if let fullname = credential.fullName {
                print(fullname)
            }
            
            if let email = credential.email {
                print("Email: ", email)
            }
            break
        default:
            break
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Apple ID Authorization failed. ", error.localizedDescription)
    }
}

extension LoginController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
}

