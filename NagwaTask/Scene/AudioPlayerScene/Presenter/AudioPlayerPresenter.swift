//
//  AudioPlayerPresenter.swift
//  NagwaTask
//
//  Created by Mohamed Samir on 31/07/2022.
//


import Foundation
import AVFoundation

protocol AudioPlayerView: AnyObject{
    var presenter: AudioPlayerPresenterProtocol? {get set}
    func updatePlaybackButton(isNextEnabled: Bool, isPerviousEnabled: Bool)
    func playAudio()
    func updateTimingLabels(remainingTime: String, elapsedTime: String, currentTime: Float)
}

protocol AudioPlayerPresenterProtocol: AnyObject {
    var path: URL? {get}
    func viewDidLoad()
    func getAudioName() -> String
    func nextButtonDidClicked()
    func perviousButtonDidClicked()
    func updateAudioDuration(with duration: TimeInterval)
    func updateTime(with currentTime: TimeInterval)
}

class AudioPlayerPresenter: AudioPlayerPresenterProtocol{
    var path: URL?
    private weak var view: AudioPlayerView?
    private var router: AudioPlayerRouter
    private var audioIndexPath = -1
    private var audioDuration: TimeInterval?
    private var currentDirectoryAudioPaths: [URL] = []

    init (view: AudioPlayerView, router: AudioPlayerRouter, path: URL, audioPaths: [URL]){
        self.view = view
        self.router = router
        self.path = path
        self.currentDirectoryAudioPaths = audioPaths
    }
    func viewDidLoad() {
        DispatchQueue.global().async {[weak self] in
            guard let self = self else {return}
            self.audioIndexPath = self.currentDirectoryAudioPaths.firstIndex(of: self.path!) ?? -1
            DispatchQueue.main.async {
                self.updatePlaybackButtons()
            }
        }
    }

    func updateAudioDuration(with duration: TimeInterval) {
        self.audioDuration = duration
    }
    func updateTime(with currentTime: TimeInterval) {
        if let audioDuration = audioDuration {
            let remainingTime = audioDuration - currentTime
            let elapsedTime = currentTime
            self.view?.updateTimingLabels(remainingTime: remainingTime.getTimeAsString(), elapsedTime: elapsedTime.getTimeAsString(), currentTime: Float(currentTime))
        }
    }

    func getAudioName() -> String {
        return path?.deletingPathExtension().lastPathComponent ?? ""
    }
    func nextButtonDidClicked() {
        audioIndexPath += 1
        path = currentDirectoryAudioPaths[audioIndexPath]
        updatePlaybackButtons()
    }
    func perviousButtonDidClicked() {
        audioIndexPath -= 1
        path = currentDirectoryAudioPaths[audioIndexPath]
        updatePlaybackButtons()
    }
    private func updatePlaybackButtons() {
        self.view?.updatePlaybackButton(isNextEnabled: audioIndexPath + 1 > currentDirectoryAudioPaths.count - 1 ? false : true
                                        , isPerviousEnabled: audioIndexPath - 1 < 0 ? false : true)
        self.view?.playAudio()
    }

}
