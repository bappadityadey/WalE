//
//  Network.swift
//  WalE
//
//  Created by Bappaditya Dey on 23/03/22.
//

import Foundation
import Combine
import Network

class Network {
    @Published
    private(set) var connected: Bool?
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "Monitor")
    
    init() {
        checkConnection()
    }
    
    func checkConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.connected = true
            } else {
                self.connected = false
            }
        }
        monitor.start(queue: queue)
    }
}
