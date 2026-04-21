//
//  ViewController.swift
//  Created on 2026/4/21
//  Description <#文件描述#>
//  PD <#产品文档地址#>
//  Design <#设计文档地址#>
//  Copyright © 2026 Zepp Health. All rights reserved.
//  @author <#zengfei#>(<#zengfei#>@zepp.com)   
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        buildDemoUI()
    }

    private func buildDemoUI() {
        let titleLabel = UILabel()
        titleLabel.text = "Native iOS Host"
        titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let descriptionLabel = UILabel()
        descriptionLabel.text = "This page is UIKit. Tap the button to present a React Native module."
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        let openButton = UIButton(type: .system)
        openButton.setTitle("Open React Native", for: .normal)
        openButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        openButton.backgroundColor = .systemTeal
        openButton.tintColor = .white
        openButton.layer.cornerRadius = 8
        openButton.translatesAutoresizingMaskIntoConstraints = false
        openButton.addTarget(self, action: #selector(openReactNative), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            openButton
        ])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 18
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            openButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func openReactNative() {
        let reactViewController = ReactViewController()
        let navigationController = UINavigationController(rootViewController: reactViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}
