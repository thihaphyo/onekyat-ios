//
//  Styles.swift
//  CommonUI
//
//  Created by Codigo Phyo Thiha on 2/6/22.
//

import Foundation
import UIKit
import Utilities

public enum Styles {
    
    
    public static func n16() -> UIFont { Font.nutinoRegular.size(16) }
    public static func n14() -> UIFont { Font.nutinoRegular.size(14) }
    public static func n12() -> UIFont { Font.nutinoRegular.size(12) }
    
    public static func nBL8() -> UIFont { Font.nunitoBlack.size(8) }
    public static func nB12() -> UIFont { Font.nutinoBold.size(12) }
    public static func nB14() -> UIFont { Font.nutinoBold.size(14) }
    public static func nB16() -> UIFont { Font.nutinoBold.size(16) }
    public static func nB24() -> UIFont { Font.nutinoBold.size(24) }
    public static func nBL16() -> UIFont { Font.nunitoBlack.size(16) }
    public static func nBE12() -> UIFont { Font.nutinoExtraBold.size(12) }
    public static func nBE14() -> UIFont { Font.nutinoExtraBold.size(14) }
    public static func nBE26() -> UIFont { Font.nutinoExtraBold.size(26) }
    
    
    public static func maintenanceStyle(_ sv: UIStackView, img: UIImageView) {
        sv.setCustomSpacing(30, after: img)
        sv.spacing = 10
        sv.distribution = .fill
        sv.alignment = .center
    }
    
    public static func mainButtonStyle(_ button: UIButton) {
        button.titleLabel?.font = Styles.n16()
        button.backgroundColor = .primaryGreen
        cornerRadiusStyle(6)(button)
        button.setTitleColor(.white, for: .normal)
    }
    
    public static func mainButtonDisabledStyle(_ button: UIButton) {
        button.titleLabel?.font = Styles.n16()
        button.backgroundColor = .disabledGreen
        cornerRadiusStyle(6)(button)
        button.setTitleColor(.white, for: .normal)
    }

}

import Kingfisher
extension UIImageView {
        
    func setImage(with urlString: String?, forceRefresh: Bool = false) {
        urlString.flatMap(URL.init)
            .then { setImage(with: $0, forceRefresh: forceRefresh) }
    }
    
    func setImage(with url: URL?, forceRefresh: Bool = false) {
        let options: KingfisherOptionsInfo = forceRefresh ? [.forceRefresh, .keepCurrentImageWhileLoading, .transition(.fade(0.15))]
            : [.keepCurrentImageWhileLoading, .transition(.fade(0.3))]
        
        kf.setImage(with: url, options: options)
    }
    
    func setImage(withBase64String base64String: String, key cacheKey: String, forceRefresh: Bool = false) {
        let options: KingfisherOptionsInfo = forceRefresh ? [.forceRefresh, .keepCurrentImageWhileLoading, .transition(.fade(0.15))]
            : [.keepCurrentImageWhileLoading, .transition(.fade(0.3))]
        
        let provider = Base64ImageDataProvider(base64String: base64String, cacheKey: cacheKey)
        
        kf.setImage(with: provider, options: options)
        
    }
    
    func showIndicatorWhileLoading(_ type: IndicatorType = .activity) {
        kf.indicatorType = type
    }
    
    func setImage(fromCache cacheKey: String) {
        ImageCache.default.retrieveImage(forKey: cacheKey) { result in
            switch result {
            case .success(let value):
                print(value.cacheType)

                // If the `cacheType is `.none`, `image` will be `nil`.
//                print(value.image)
                self.image = value.image

            case .failure(let error):
                print(error)
            }
        }
    }

}

public extension UIImage {
    static func download(from url: String?, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        URL(string: url.orEmpty).then {
            ImageDownloader.default.downloadImage(with: $0) { result in
                switch result {
                case .success(let value):
                    completion(.success(value.image))
                case .failure(let error):
                    completion(.failure(error))
                    print(error)
                }
            }
        }
    }
}

