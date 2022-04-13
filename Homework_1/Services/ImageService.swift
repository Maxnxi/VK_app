//
//  ImageService.swift
//  Homework_1
//
//  Created by Maksim on 21.06.2021.
//

import UIKit
import Alamofire

class ImageService {
    
    private static let pathName: String = {
        let pathName = "images"
        
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        //проверка есть ли директория
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return pathName
    }()
    
    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    private var images = [String: UIImage]()
    private let container: DataReloadable
    
    init(container: UITableView) {
        self.container = Table(table: container)
    }

    init(container: UICollectionView) {
        self.container = Collection(collection: container)
    }
    
    // функция получения фото
    func photo(atIndexpath indexPath: IndexPath, byUrl url: String) -> UIImage? {
        var image: UIImage?
        print("URL photo - ",url)
        if let photo = images[url] { //фото из словаря
            image = photo
        } else if let photo = getImageFromCache(url: url) { // загрузка из кеша
            image = photo
        } else {
            
            loadPhoto(atIndexpath: indexPath, byUrl: url) //загрузка из и-нета
        }
        return image
    }
    
    private func getImageFromCache(url: String) -> UIImage? {
        guard
            let fileName = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
            else { return nil }

        let lifeTime = Date().timeIntervalSince(modificationDate)

        guard
            lifeTime <= cacheLifeTime,
            let image = UIImage(contentsOfFile: fileName) else { return nil }

        DispatchQueue.main.async {
            self.images[url] = image
        }
        return image
    }
    
    // функция получения пути к фаилу
    private func getFilePath(url: String) -> String? {

        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }

        let hashName = url.split(separator: "/").last ?? "default"
        return cachesDirectory.appendingPathComponent(ImageService.pathName + "/" + hashName).path
    }
    
    // функция загрузки фото из И-нета
    private func loadPhoto(atIndexpath indexPath: IndexPath, byUrl url: String) {
        AF.request(url).responseData(queue: DispatchQueue.global()) { [weak self] response in
            guard
                let data = response.data,
                let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                self?.images[url] = image //внесение в словарь
            }
            //сохранение в кэш
            self?.saveImageToCache(url: url, image: image)
            DispatchQueue.main.async {
                self?.container.reloadRow(indexPath: indexPath)
            }
        }
    }
    
    //функция сохранения в кэш
    private func saveImageToCache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url),
        let data = image.pngData() else { return }
        print(fileName)
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
    
}

fileprivate protocol DataReloadable {
    func reloadRow(indexPath: IndexPath)
}

extension ImageService {
    private class Table: DataReloadable {
        
        let table: UITableView

        init(table: UITableView) {
            self.table = table
        }

        func reloadRow(indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .none)
        }

    }

    private class Collection: DataReloadable {
        let collection: UICollectionView

        init(collection: UICollectionView) {
            self.collection = collection
        }

        func reloadRow(indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }
}
