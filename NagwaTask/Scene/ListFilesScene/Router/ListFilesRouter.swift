//
//  ListFilesRouter.swift
//  NagwaTask
//
//  Created by Mohamed Samir on 30/07/2022.
//

import UIKit

class ListFilesRouter {
    class func createListFilesViewController(directory: URL?) -> UIViewController{
        let createViewController = ListFilesViewController()
        
        let filesView = createViewController as ListFilesView
        let router = ListFilesRouter()
        let presenter = ListFilesPresenter(view: filesView, router: router, directory: directory)
        filesView.presenter = presenter
        return createViewController
    }
    
    func navigateToAudioPlayer(from view: ListFilesView, path: URL, audioPaths: [URL]) {
        if let viewController = view as? UIViewController {
            let audioPlayer = AudioPlayerRouter.createAudioPlayerViewController(path: path, audioPaths: audioPaths)
            viewController.navigationController?.present(audioPlayer, animated: true)
        }
    }
    func navigateToSubFolder(from view: ListFilesView, directory: URL) {
        if let viewController = view as? UIViewController {
            let listFile = ListFilesRouter.createListFilesViewController(directory: directory)
            viewController.navigationController?.pushViewController(listFile, animated: true)
        }
    }
}
