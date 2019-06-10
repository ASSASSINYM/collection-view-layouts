//
//  PinterestLayout.swift
//  collection-view-layouts
//
//  Created by sergey on 2/21/18.
//  Copyright © 2018 rubygarage. All rights reserved.
//

import UIKit

public class PinterestLayout: ContentDynamicLayout {
    public var columnsCount = 2

    // MARK: - ContentDynamicLayout

    override public func calculateCollectionViewCellsFrames() {
        guard columnsCount > 0 else {
            fatalError("Value must be greater than zero")
        }

        guard let collectionView = collectionView, let delegate = delegate else {
            return
        }
        
        contentSize.width = collectionView.frame.size.width

        let cellsPaddingWidth = CGFloat(columnsCount - 1) * cellsPadding.vertical
        let cellWidth = (contentWidthWithoutPadding - cellsPaddingWidth) / CGFloat(columnsCount)

        var yOffsets = [CGFloat](repeating: contentPadding.vertical, count: columnsCount)

        for section in 0..<collectionView.numberOfSections {
            let itemsCount = collectionView.numberOfItems(inSection: section)
            
            for item in 0 ..< itemsCount {
                let isLastItem = item == itemsCount - 1
                let indexPath = IndexPath(item: item, section: section)
                let cellhHeight = delegate.cellSize(indexPath: indexPath).height
                let cellSize = CGSize(width: cellWidth, height: cellhHeight)

                let y = yOffsets.min()!
                let column = yOffsets.firstIndex(of: y)!
                let x = CGFloat(column) * (cellWidth + cellsPadding.horizontal) + contentPadding.horizontal
                let origin = CGPoint(x: x, y: y)

                yOffsets[column] += cellhHeight + cellsPadding.vertical

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(origin: origin, size: cellSize)
                addCachedLayoutAttributes(attributes: attributes)

                if isLastItem {
                    let y = yOffsets.max()!
                    for index in 0..<yOffsets.count {
                        yOffsets[index] = y
                    }
                }
            }
        }

        contentSize.height = yOffsets.max()! + contentPadding.vertical - cellsPadding.vertical
    }
}
