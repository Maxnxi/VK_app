//
//  PhotoNode.swift
//  Homework_1
//
//  Created by Maksim on 30.06.2021.
//

import Foundation
import AsyncDisplayKit

class PhotoNode: ASCellNode {
    private let resource: ImageNodeRepresentable
    private let photoImageNode = ASNetworkImageNode()
    
    init(resource: ImageNodeRepresentable) {
        self.resource = resource
        super.init()
        setupSubnodes()
    }
    
    func setupSubnodes() {
        photoImageNode.url = resource.url
        photoImageNode.contentMode = .scaleAspectFill
        photoImageNode.shouldRenderProgressImages = true
        
        addSubnode(photoImageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.max.width // уточнить размер
        photoImageNode.style.preferredSize = CGSize(width: width, height: width*resource.aspectRatio)
        return ASWrapperLayoutSpec(layoutElement: photoImageNode)
    }
}
