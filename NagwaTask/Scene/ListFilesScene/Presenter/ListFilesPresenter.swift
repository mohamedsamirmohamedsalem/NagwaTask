//
//  ListFilesPresenter.swift
//  NagwaTask
//
//  Created by Mohamed Samir on 30/07/2022.
//


import Foundation
import AVFoundation

protocol ListFilesView: AnyObject{
    var presenter: ListFilesPresenterProtocol? {get set}
    func updateUI()
    func updateTitle(with title: String)
    func showAlert(title: String, message: String)
}

protocol ListFilesPresenterProtocol: AnyObject {
    func loadView()
    func numberOfFiles() -> Int
    func getFile(at index: Int) -> FileModel
    func didSelectFile(at index: Int)
}

class ListFilesPresenter: ListFilesPresenterProtocol{
    
    private weak var view: ListFilesView?
    private var router: ListFilesRouter
    private var files: [FileModel] = []
    private var directory: URL?
    
    init (view: ListFilesView, router: ListFilesRouter, directory: URL?){
        self.view = view
        self.router = router
        self.directory = directory
    }
    func loadView() {
        self.view?.updateTitle(with: self.directory == nil ? "Documents" : self.directory!.lastPathComponent)
        DispatchQueue.global().async {[weak self] in
            guard let self = self else {return}
            self.files = self.listFilesFrom(directory: self.directory, with: "mp3")
            DispatchQueue.main.async {
                self.view?.updateUI()
            }
        }
    }
    private func listFilesFrom(directory: URL?, with extensionWanted: String) -> [FileModel] {

        let documentURL: URL
        if let directory = directory {
            documentURL = directory
        }
        else {
            documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        }
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil, options: [])
            
            let filesPath = directoryContents.filter{ $0.pathExtension == extensionWanted || $0.hasDirectoryPath}
            let files = filesPath.map{
                FileModel(fileName: $0.lastPathComponent,
                          path: $0,
                          fileType: $0.pathExtension == extensionWanted ? .Audio : .Folder,
                          duration: AVAsset(url: $0).duration.seconds.getTimeAsString())}
                .sorted {
                    ($0.fileType, $0.fileName.lowercased()) < ($1.fileType, $1.fileName.lowercased())
                }
            
            return files

        } catch {
            self.view?.showAlert(title: "error", message: error.localizedDescription)
        }
        return []
    }
    
    func numberOfFiles() -> Int {
        return files.count
    }
    
    func getFile(at index: Int) -> FileModel{
        return files[index]
    }
    func didSelectFile(at index: Int) {
        let file = files[index]
        switch file.fileType {
        case .Folder:
            router.navigateToSubFolder(from: view!, directory: file.path)
        case .Audio:
            let audioPaths = files.filter({$0.fileType == .Audio}).map({$0.path})
            router.navigateToAudioPlayer(from: view!, path: file.path, audioPaths: audioPaths)
        }
    }
}
