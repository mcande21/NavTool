//
//  MPConnectionManager.swift
//  NavTool
//
//  Created by Cooper Anderson on 3/31/24.
//

import MultipeerConnectivity

extension String {
    static var serviceName = "LatAndLon"
}

class MPConnectionManager: NSObject, ObservableObject {
    let serviceType = String.serviceName
    let session: MCSession
    let myPeerId: MCPeerID
    let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser
    let nearbyServiceBrowser: MCNearbyServiceBrowser
    var game: GPSscreen?
    
    func setup(game:GPSscreen) {
        self.game = game
    }
    
    @Published var avaialblePeers = [MCPeerID]()
    @Published var recievedInvite: Bool = false
    @Published var recievedInviteFrom: MCPeerID?
    @Published var invitationHandler: ((Bool, MCSession?) -> Void)?
    @Published var paired: Bool = false
    
    var isAvailablyToPlay: Bool = false {
        didSet {
            if isAvailablyToPlay {
                startAdvertising()
            } else {
                stopAdvertising()
            }
        }
    }
    
    init(yourName: String) {
        myPeerId = MCPeerID(displayName: yourName)
        session = MCSession(peer: myPeerId)
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        nearbyServiceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        super.init()
        session.delegate = self
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceBrowser.delegate = self
    }
    
    deinit {
        stopBrowsing()
        stopAdvertising()
    }
    
    func startAdvertising() {
        nearbyServiceAdvertiser.startAdvertisingPeer()
    }
    func stopAdvertising() {
        nearbyServiceAdvertiser.stopAdvertisingPeer()
    }
    func startBrowsing() {
        nearbyServiceBrowser.startBrowsingForPeers()
    }
    func stopBrowsing() {
        nearbyServiceBrowser.stopBrowsingForPeers()
        avaialblePeers.removeAll()
    }
    
    func send(gameMove: MPLocation) {
        if !session.connectedPeers.isEmpty {
            do {
                if let data = gameMove.data() {
                    try session.send(data, toPeers:  session.connectedPeers, with: .reliable)
                    }
                } catch {
                    print("error sending \(error.localizedDescription)")
                }
            }
        }
    }
extension MPConnectionManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        DispatchQueue.main.async {
            if !self.avaialblePeers.contains(peerID){
                self.avaialblePeers.append(peerID)
            }
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        guard let index = avaialblePeers.firstIndex(of: peerID) else { return }
        DispatchQueue.main.async {
            self.avaialblePeers.remove(at: index)
        }
    }
}

extension MPConnectionManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async {
            self.recievedInvite = true
            self.recievedInviteFrom = peerID
            self.invitationHandler = invitationHandler
        }
    }
}

extension MPConnectionManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .notConnected:
            DispatchQueue.main.async {
                self.paired = false
                self.isAvailablyToPlay = true
            }
        case.connected:
            DispatchQueue.main.async {
                self.paired = true
                self.isAvailablyToPlay = false
            }
        default:
            DispatchQueue.main.async {
                self.paired = false
                self.isAvailablyToPlay = true
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let gameMove = try? JSONDecoder().decode(MPLocation.self, from: data) {
            DispatchQueue.main.async {
                switch gameMove.action {
                case .start:
                   break
                case .lat:
                    if let location = gameMove.Location {
                        self.game?.coordinates.lat
                    }
                case .lon:
                    if let location = gameMove.Location {
                        self.game?.coordinates.lon
                    }
                case .end:
                    self.session.disconnect()
                    self.isAvailablyToPlay = true
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        
    }
    
    
}
