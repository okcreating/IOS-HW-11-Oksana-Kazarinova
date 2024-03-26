//
//  ViewController.swift
//  IOS HW-11 Oksana Kazarinova
//
//  Created by Oksana Kazarinova on 20/03/2024.
//

import UIKit

import SnapKit

final class ViewController: UIViewController, CAAnimationDelegate {

    // MARK: - Constants

    private var isWorkTime = true
    private var isStarted = false
    private var timer = Timer()
    var workTime = 25
    var restTime = 5
    var time = 25
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    let startPoint = CGFloat(-Double.pi / 2)
    let endPoint = CGFloat(3 * Double.pi / 2)
    private var isAnimationStarted = true

    // MARK: - UI

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Working"
        label.font = .systemFont(ofSize: 35)
        label.textColor = .red
        label.textAlignment = .center
        //  label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:25"
        label.font = .systemFont(ofSize: 60)
        label.textColor = .systemRed
        label.textAlignment = .center
        // label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var stopStartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(loadSFImage(name: "play.circle.fill"), for: .normal)
        // button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.tintColor = .systemBackground
        button.addTarget(self, action: #selector(buttonTappped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        view.backgroundColor = .lightGray
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
        createCircularPath()
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

    @objc private func runTimer() {
        if time <= 1 {
            statusLabel.text = isWorkTime ? "Rest" : "Work"
            time = isWorkTime ? restTime : workTime
            timer.invalidate()
            isWorkTime = !isWorkTime

            stopAnimation()
            statusLabel.textColor = isWorkTime ? .green : .red
            timeLabel.textColor = isWorkTime ? .green : .red
            stopStartButton.backgroundColor = isWorkTime ? .green : .red
            stopStartButton.setImage(loadSFImage(name: "play.circle.fill"), for: .normal)
            isStarted = false
            timeLabel.text = formatTime()
        } else {
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
            make.top.equalTo(timeLabel).offset(220)
            make.centerX.equalTo(view)
        }
    }

    // MARK: - Progress Bar

    private func createCircularPath() {
        circleLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: 110, startAngle: startPoint, endAngle: endPoint, clockwise: true).cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 14.0
        circleLayer.strokeEnd = 1.0
        view.layer.addSublayer(circleLayer)
    }

    private func createProgressBar() {
        // let color: UIColor = isWorkTime ? .red : .green
        progressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY), radius: 110, startAngle: startPoint, endAngle: endPoint, clockwise: true).cgPath
        progressLayer.strokeColor = isWorkTime ? UIColor.red.cgColor : UIColor.green.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 14.0
        progressLayer.strokeEnd = 0.0
        view.layer.addSublayer(progressLayer)
    }

    private func progressAnimation() {
        let progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        //let time = isWorkTime ? workTime : restTime
        progressLayer.strokeEnd = 0.0
        progressAnimation.keyPath = "strokeEnd"
        progressAnimation.fromValue = 0
        progressAnimation.toValue = 1
        progressAnimation.duration = Double(time)
        progressAnimation.isAdditive = true
        progressAnimation.fillMode = .forwards
        progressAnimation.isRemovedOnCompletion = false
        progressLayer.add(progressAnimation, forKey: "strokeEnd")
        isAnimationStarted = true
    }

    private func pauseAnimation() {
        let pausedTime = progressLayer.convertTime(CACurrentMediaTime(), from: nil)
        progressLayer.speed = 0.0
        progressLayer.timeOffset = pausedTime
    }

    private func stopAnimation() {
        isAnimationStarted = false
        progressLayer.removeAnimation(forKey: "strokeEnd")
    }

    private func resumeAnimation() {
        let pausedTime = progressLayer.timeOffset
        progressLayer.speed = 0.8
        progressLayer.timeOffset = 0.0
        progressLayer.beginTime = 0.0
        let timeAfterPaused = progressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        progressLayer.beginTime = timeAfterPaused
    }

  private func startResumeAnimation() {
        if isAnimationStarted {
            resumeAnimation()
        } else {
            progressAnimation()
        }
    }

    @objc private func buttonTappped() {
        if !isStarted {
            createProgressBar()
            isAnimationStarted ? resumeAnimation() : progressAnimation()
            startTimer()
            stopStartButton.setImage(loadSFImage(name: "pause.circle.fill"), for: .normal)
            isStarted = true
        } else {
            pauseAnimation()
            timer.invalidate()
            stopStartButton.setImage(loadSFImage(name: "play.circle.fill"), for: .normal)
            isStarted = false
        }
    }
}
