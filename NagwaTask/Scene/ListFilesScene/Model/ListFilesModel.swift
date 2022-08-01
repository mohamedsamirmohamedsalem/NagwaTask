//
//  ListFilesModel.swift
//  NagwaTask
//
//  Created by Mohamed Samir on 30/07/2022.
//

import Foundation

struct FileModel {
    let fileName: String
    let path: URL
    let fileType: FileType
    let duration: String
}

enum FileType: Comparable {
    case Folder, Audio
}
