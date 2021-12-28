//
//  ImageStore.swift
//  Quiz
//
//  Created by Nahal Khalkhali on 11/26/21.
//

import UIKit
import Foundation

public struct ImageStore: Codable {

    public let image: Data
    
    public init(image: UIImage) {
        self.image = image.pngData()!
    }
}
    
    
    
//    static let sharedInstance = ImageStore()
//
//
//    let cache = NSCache<NSString,UIImage>()
//
//    func setImage(_ image: UIImage, forKey key: String){
//        cache.setObject(image, forKey: key as NSString)
//        //saving image data to disk
//        let url = imageURL(forKey: key)
//        //turn image into JPEG data
//        if let data = image.jpegData(compressionQuality: 0.5){
//            try? data.write(to: url)
//        }
//    }
//
//    //fetching image from filesystem if it is not in the cache
//    func image(forKey key: String) -> UIImage? {
//        if let existingImage = cache.object(forKey: key as NSString){
//            return existingImage
//        }
//        let url = imageURL(forKey: key)
//        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else{
//            return nil
//        }
//        cache.setObject(imageFromDisk, forKey: key as NSString)
//        return imageFromDisk
//    }
//
//    //removing the image from filesystem
//    func deleteImage(forkey key: String) {
//        cache.removeObject(forKey: key as NSString)
//
//        let url = imageURL(forKey: key)
//        do{
//            try FileManager.default.removeItem(at: url)
//        } catch {
//            print("Error removing the image from the disk: \(error)")
//        }
//    }
//
//    //get URL for a given image
//    func imageURL(forKey key: String) -> URL {
//        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentDirectory = documentsDirectories.first!
//
//        return documentDirectory.appendingPathComponent(key)
//    }
        
    
    


