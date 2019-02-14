//
//  WebSocketKuzzleConnector.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 12/02/2019.
//  Copyright © 2019 Jeoffrey Thirot. All rights reserved.
//

import Foundation
import Starscream
import RxSwift
import RxStarscream

class WebSocketKuzzleConnector {
    // MARK: - Variables
    // Private variables
    private let disposeBag = DisposeBag()
    
    // Public variables
    let socket: WebSocket
    
    // MARK: - Getter & Setter methods
    
    // MARK: - Constructors
    /**
     Method to create the manager of socket communications
     
     @param settings detail to launch the right sockets connection
     @param delegate used to dispatch event from sockets activities
     */
    public init() {
        
        socket = WebSocket(url: URL(string: Constants.kuzzleWebSocketServerUrl)!)
        socket.connect()
        
        socket.rx.response.subscribe(onNext: { (response: WebSocketEvent) in
            switch response {
            case .connected:
                print("Connected")
            case .disconnected(let error):
                print("Disconnected with optional error : \(String(describing: error))")
            case .message(let msg):
                print("Message : \(msg)")
            case .data(_):
                print("Data")
            case .pong:
                print("Pong")
            }
        }).disposed(by: disposeBag)
        
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(WebSocketKuzzleConnector.sendRandomMsg), userInfo: nil, repeats: true)
    }
    // MARK: - Init behaviors
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    private var cpt = 0
    @objc private func sendRandomMsg() {
        let message = "hello\(cpt)"
        socket.write(string: message)
        cpt += 1
    }
    
    // MARK: - Delegates methods
}
