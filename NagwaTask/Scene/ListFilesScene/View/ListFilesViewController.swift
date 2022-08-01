//
//  ListFilesViewController.swift
//  NagwaTask
//
//  Created by Mohamed Samir on 30/07/2022.
//

import UIKit

class ListFilesViewController: UIViewController {

    @IBOutlet weak var filesTableView: UITableView!
    var presenter: ListFilesPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.loadView()
        let refresh = UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.2.circlepath"), style: .plain, target: self, action: #selector(self.refresh))
        self.navigationItem.rightBarButtonItem = refresh
    }
    
    @objc private func refresh() {
        presenter?.loadView()
    }
    private func setupUI() {
        filesTableView.register(FileTableViewCell.self)
    }
}

extension ListFilesViewController: ListFilesView {
    func updateUI() {
        filesTableView.reloadData()
    }
    func updateTitle(with title: String) {
        self.title = title
    }
    func showAlert(title: String, message: String) {
        self.showAlert(title: title, message: message, onClick: nil)
    }
}

extension ListFilesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfFiles() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let file = presenter?.getFile(at: indexPath.row) else {return UITableViewCell()}
        let cell = tableView.dequeueCell() as FileTableViewCell
        cell.selectionStyle = .none
        cell.audioDurationLabel.text = file.fileName
        cell.fileNameLabel.text = file.fileName
        cell.audioDurationLabel.text = file.duration
        if file.fileType == .Folder {
            cell.fileImageView.image = UIImage(systemName: "folder.fill")
            cell.fileImageView.tintColor = UIColor(named: "Folder")
            cell.audioDurationLabel.isHidden = true
        } else {
            cell.fileImageView.image = UIImage(systemName: "music.note")
            cell.fileImageView.tintColor = UIColor(named: "Audio")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
}

extension ListFilesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectFile(at: indexPath.row)
    }
}
