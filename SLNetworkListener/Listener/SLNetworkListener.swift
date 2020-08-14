//
//  SLNetworkListener.swift
//  FZXLive
//
//  Created by 孙梁 on 2020/8/14.
//  Copyright © 2020 znclass. All rights reserved.
//

import UIKit

class SLNetworkListener: NSObject {
    
    @objc public static let NotificationNameNetworkChanged = "NotificationNameNetworkChanged"
    @objc public var showAlertWhenNoNetwork = true
    
    @objc public static let shared = SLNetworkListener()
    private override init() {
        super.init()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
    }
    @objc public func listen() {
        internetReachability?.startNotifier()
        reachabilityChanged()
    }
    
    @objc public var networkStatus: SLNetworkStatus = .wifi
    
    private let internetReachability = Reachability.forInternetConnection()
    
    private var alert: UIAlertController?
}

/// private
extension SLNetworkListener {
    @objc private func reachabilityChanged() {
        guard let status = internetReachability?.currentReachabilityStatus() else { return }
        switch status {
        case .init(0):
            networkStatus = .noNet
            showAlert()
        case .init(1):
            networkStatus = .wifi
            alert?.dismiss(animated: true, completion: nil)
        case .init(2):
            networkStatus = .wwan
            alert?.dismiss(animated: true, completion: nil)
        default:
            break
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SLNetworkListener.NotificationNameNetworkChanged), object: networkStatus)
    }
    
    private func showAlert() {
        guard showAlertWhenNoNetwork else { return }
        alert = UIAlertController(title: "网络未连接, 请进行网络设置", message: nil, preferredStyle: .alert)
        let ac1 = UIAlertAction(title: "取消", style: .default) { (_) in
        }
        let ac2 = UIAlertAction(title: "前往设置", style: .default) { (_) in
            if let url = URL(string: "App-Prefs:root") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert?.addAction(ac1)
        alert?.addAction(ac2)
        UIApplication.shared.windows.first{$0.isKeyWindow}?.rootViewController?.present(alert!, animated: true, completion: nil)
    }
}

/// public
extension SLNetworkListener {
    @objc public func showAlertIfNetworkStatusWWAN(ignore: (() -> Void)?, goBack: (() -> Void)?) {
        guard networkStatus == .wwan else { return }
        alert = UIAlertController(title: "您正在使用数据流量进行浏览, 是否需要修改网络设置", message: nil, preferredStyle: .alert)
        let ac1 = UIAlertAction(title: "继续", style: .default) { (_) in
            ignore?()
        }
        let ac2 = UIAlertAction(title: "前往设置", style: .default) { (_) in
            goBack?()
            if let url = URL(string: "App-Prefs:root") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert?.addAction(ac1)
        alert?.addAction(ac2)
        UIApplication.shared.windows.first{$0.isKeyWindow}?.rootViewController?.present(alert!, animated: true, completion: nil)
    }
}

@objc public enum SLNetworkStatus: Int {
    case noNet = 0
    case wifi = 1
    case wwan = 2
}
