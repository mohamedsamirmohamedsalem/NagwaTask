//
//  AudioPlayerViewController.swift
//  NagwaTask
//
//  Created by Mohamed Samir on 31/07/2022.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController {

    @IBOutlet weak var elapsedTimeLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var perviousButton: UIButton!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var audioLabel: UILabel!
    
    private var player: AVAudioPlayer?
    private var timer: Timer?
    var presenter: AudioPlayerPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        prepareAudioSession()
        prepareUI()
        togglePlay()
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
    }
    @IBAction func playButtonDidClicked(_ sender: Any) {
        togglePlay()
    }
    
    @IBAction func nextButtonDidClicked(_ sender: Any) {
        presenter?.nextButtonDidClicked()
    }
    
    @IBAction func perviousButtonDidClicked(_ sender: Any) {
        presenter?.perviousButtonDidClicked()
    }
    //it can be only on "sliderViewChanged" but change player current time on value changed made UISlider lagged
    @IBAction func sliderDidEndEditing(_ sender: UISlider) {
        player?.currentTime = TimeInterval(sender.value)
        play()
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        timer?.invalidate()
        presenter?.updateTime(with: TimeInterval(sender.value))
    }
    private func prepareUI() {
        timer?.invalidate()
        setupPlayer()
        setupSlider()
        setupUI()
    }
    private func setupUI() {
        guard let currentTime = player?.currentTime else{return }
        audioLabel.text = presenter?.getAudioName()
        presenter?.updateTime(with: currentTime)
    }
    private func setupSlider() {
        guard let duration = player?.duration else {return}
        audioSlider.maximumValue = Float(duration)
        audioSlider.setValue(0.0, animated: true)
    }
    private func prepareAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            self.showAlert(title: "error", message: error.localizedDescription, onClick: nil)
        }
    }
    private func setupPlayer() {
        do {
            guard let path = presenter?.path else {return}
            player = try AVAudioPlayer(contentsOf: path)
            guard let player = player else { return }
            player.delegate = self
            presenter?.updateAudioDuration(with: player.duration)
        } catch {
            self.showAlert(title: "error", message: error.localizedDescription, onClick: nil)
        }
    }
    @objc private func updateTime() {
        guard let player = player else {return}
        presenter?.updateTime(with: player.currentTime)
    
    }
    private func togglePlay() {
        guard let player = player else {return}
        if player.isPlaying {
            self.pause()
        } else {
            self.play()
        }
    }
    private func pause() {
        guard let player = player else {return}
        player.pause()
        timer?.invalidate()
        playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    private func play() {
        guard let player = player else {return}
        player.prepareToPlay()
        player.volume = 1.0
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
        player.play()
        playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)

    }
}

extension AudioPlayerViewController: AudioPlayerView {
    func updatePlaybackButton(isNextEnabled: Bool, isPerviousEnabled: Bool) {
        nextButton.isEnabled = isNextEnabled
        perviousButton.isEnabled = isPerviousEnabled

    }
    func playAudio() {
        prepareUI()
        togglePlay()
    }
    func updateTimingLabels(remainingTime: String, elapsedTime: String, currentTime: Float) {
        UIView.animate(withDuration: 0.5) {
            self.audioSlider.setValue(currentTime, animated: true)
        }
        remainingTimeLabel.text = "-\(remainingTime)"
        elapsedTimeLabel.text = elapsedTime
    }
}

extension AudioPlayerViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            pause()
        }
    }
}
