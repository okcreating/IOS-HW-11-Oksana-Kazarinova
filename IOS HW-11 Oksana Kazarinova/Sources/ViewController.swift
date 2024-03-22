//
//  ViewController.swift
//  IOS HW-11 Oksana Kazarinova
//
//  Created by Oksana Kazarinova on 20/03/2024.
//

import UIKit

import SnapKit

final class ViewController: UIViewController {

    // MARK: - Constants

    // MARK: - UI
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Working"
        label.font = .systemFont(ofSize: 35)
        label.textColor = .red
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:25"
        label.font = .systemFont(ofSize: 60)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stopStartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(loadSFImage(name: "play.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.tintColor = .black
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Actions
    func loadSFImage(name: String) -> UIImage? {
        let image = UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: 45, weight: .medium, scale: .medium))?.withTintColor(.red, renderingMode: .automatic)
        return image
    }

    // MARK: - Setups
    private func setupView() {}

    private func setupHierarchy() {
        view.addSubview(statusLabel)
        view.addSubview(timeLabel)
        view.addSubview(stopStartButton)
    }

    private func setupLayout() {
        statusLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(150)
            //            make.leading.lessThanOrEqualTo(40)
            //            make.trailing.lessThanOrEqualTo(-40)
        }

        timeLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(view)
        }

        stopStartButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel).offset(120)
            make.centerX.equalTo(view)
        }
    }
}

