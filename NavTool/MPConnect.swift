//
//  MPConnect.swift
//  NavTool
//
//  Created by Cooper Anderson on 3/31/24.
//
import MultipeerConnectivity

class MPConnect: UITableViewController, MCSessionDelegate, MCBrowserViewControllerDelegate {
    
    var peerID: MCPeerID!
    var mcSession: MCSession!
    var mcAdvertiserAssistant: MCAdvertiserAssistant!
      
    override func viewDidLoad() {
      peerID = MCPeerID(displayName: UIDevice.current.name)
      mcSession = MCSession(peer: peerID, securityIdentity: nil,    encryptionPreference: .required)
      mcSession.delegate = self
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case .connected: print ("connected \(peerID)")
            case .connecting: print ("connecting \(peerID)")
            case .notConnected: print ("not connected \(peerID)")
            default: print("unknown status for \(peerID)")
          }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        <#code#>
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        <#code#>
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        <#code#>
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: (any Error)?) {
        <#code#>
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
}
