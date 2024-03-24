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

    private var isWorkTime = true
    private var isStarted = false
    private var timer = Timer()
    var workTime = 25
    var restTime = 5
    var time = 25

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
        button.addTarget(self, action: #selector(buttonTappped), for: .touchUpInside)

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

    private func loadSFImage(name: String) -> UIImage? {
        let image = UIImage(systemName: name, withConfiguration: UIImage.SymbolConfiguration(pointSize: 45, weight: .medium, scale: .medium))?.withTintColor(.red, renderingMode: .automatic)
        return image
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
    }

    private func formatTime() -> String {
        let mins = Int(time) / 60 % 60
        let secs = Int(time) % 60
        return String(format: "%02i:%02i", mins, secs)
    }

    @objc private func buttonTappped() {
        if !isStarted {
            startTimer()
            isStarted = true
            stopStartButton.setImage(loadSFImage(name: "pause.circle.fill"), for: .normal)
        }
        else {
            timer.invalidate()
            isStarted = false
            stopStartButton.setImage(loadSFImage(name: "play.circle.fill"), for: .normal)
        }
    }

    @objc private func runTimer() {
        if time <= 1 {
            time = isWorkTime ? workTime : restTime
            timer.invalidate()
            statusLabel.text = isWorkTime ? "Working" : "Rest"
            statusLabel.textColor = isWorkTime ? .red : .green
            timeLabel.textColor = isWorkTime ? .red : .green
            stopStartButton.backgroundColor = isWorkTime ? .red : .green
            timeLabel.text = formatTime()
            stopStartButton.setImage(loadSFImage(name: "play.circle.fill"), for: .normal)
            isWorkTime = !isWorkTime
            isStarted = false
        }
        else {
            time -= 1
            timeLabel.text = formatTime()
        }
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

