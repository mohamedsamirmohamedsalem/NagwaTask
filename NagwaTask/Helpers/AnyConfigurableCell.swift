//
//  File.swift
//  ytsInCode
//
//  Created by Mohamed Samir on 9/20/19.
//  Copyright © 2019 Mohamed Samir. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype Model
    func configure(model: Model)
}

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView, at indexPath: IndexPath)
}

class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.Model == DataType, CellType: UITableViewCell {
    
    static var reuseId: String { return String(describing: CellType.self) }
    let completeConfiugration: ((CellType, IndexPath) -> ())?
    let item: DataType
    
    init(item: DataType,_ completeConfiugration: ((_ cell: CellType, _ indexPath: IndexPath) -> ())? = nil) {
        self.item = item
        self.completeConfiugration = completeConfiugration
    }
    
    func configure(cell: UIView ,at indexPath : IndexPath) {
        completeConfiugration?(cell as! CellType, indexPath)
        (cell as! CellType).configure(model: item)
    }
}

class CollectionCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.Model == DataType, CellType: UICollectionViewCell {
    
    static var reuseId: String { return String(describing: CellType.self) }
    let completeConfiugration: ((CellType, IndexPath) -> ())?
    let item: DataType
    
    init(item: DataType,_ completeConfiugration: ((_ cell: CellType, _ indexPath: IndexPath) -> ())? = nil) {
        self.item = item
        self.completeConfiugration = completeConfiugration
    }
    
    func configure(cell: UIView ,at indexPath : IndexPath) {
        completeConfiugration?(cell as! CellType, indexPath)
        (cell as! CellType).configure(model: item)
    }
}
