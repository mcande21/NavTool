//
//  ConnectControler.swift
//  NavTool
//
//  Created by Cooper Anderson on 3/31/24.
//

import UIKit
import MultipeerConnectivity

class ConnectControler: UIViewController {
    
    var currentPlayer: String!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPlayer = "x"
        mpcHandler.setupPeerWithDisplayName(displayName: UIDevice.current.name)
        mpcHandler.setupSession()
        mpcHandler.advertiseSelf(advertise: true)
        mpcHandler.delegate = self
        setupFields()
    }
    
    // MARK: - IBActions
    @IBAction func connectWithPlayer(_ sender: Any) {
        guard mpcHandler.session != nil else { return }
        mpcHandler.setupBrowser()
        mpcHandler.browser.delegate = self
        self.present(mpcHandler.browser, animated: true, completion: nil)
    }
    
    @IBAction func newGame(_ sender: UIBarButtonItem) {
        resetGame()
        package(json: ["string":"New Game"])
    }
    
}

// MARK: Multipeer Handling
extension ConnectControler: MPCHandlerDelegate {
    
    // Updates the screen with connection status.
    func changed(state: MCSessionState, of peer: MCPeerID) {
        guard state == .connected else {
            navigationItem.title = "No Connection"
            navigationItem.leftBarButtonItem?.isEnabled = true
            mpcHandler.advertiseSelf(advertise: true)
            return
        }
        navigationItem.title = "Connected"
        navigationItem.leftBarButtonItem?.isEnabled = false
        mpcHandler.advertiseSelf(advertise: false)
        resetGame()
    }
    
    // Updates screen with other player's actions.
    func received(data: Data, from peer: MCPeerID) {
        let message = unpack(json: data)
        let senderDisplayName = peer.displayName
        guard message["string"] as? String != "Game Over" else {
            popUp(message: "You Lose!!!", action: pauseGame())
            return
        }
        guard message["string"] as? String != "New Game" else {
            popUp(message: "\(senderDisplayName) has started a new Game!", action: resetGame())
            return
        }
        guard let space = message["field"] as? Int, let player = message["player"] as? String else {
            print("Missing message info.")
            return
        }
        
        fields[space].player = player
        fields[space].setPlayer(player: player)
        currentPlayer = player == "o" ? "x" : "o"
        unPauseGame()
        checkResults()
    }
}


extension ConnectControler: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        mpcHandler.browser.dismiss(animated: true, completion: nil)
    }
}

extension ConnectControler {
    
    func pauseGame() {
        for index in 0 ... fields.count - 1 {
            fields[index].isUserInteractionEnabled = false
        }
    }
    
    func unPauseGame() {
        for index in 0 ... fields.count - 1 {
            fields[index].isUserInteractionEnabled = true
        }
    }
    
    // Used to reset the game.
    func resetGame() {
        for index in 0 ... fields.count - 1 {
            fields[index].image = nil
            fields[index].activated = false
            fields[index].player = ""
            fields[index].isUserInteractionEnabled = true
        }
        currentPlayer = "x"
    }
    
    // Used to convert data into native Dictionary object.
    func unpack(json: Data) -> [String: Any] {
        var message = [String: Any]()
        message = try! JSONSerialization.jsonObject(with: json, options: .allowFragments) as! [String : Any]
        return message
    }
    
    // Creates data object for IoT/net communications and syncs with other player.
    func package(json message: [String : Any]) {
        var messageData : Data
        do {
            messageData = try JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
        } catch {
            print("Error packaging message: \(error.localizedDescription)")
            return
        }
        syncPlayers(with: messageData)
    }
    
    // Sends data objects to other IoT players/devices.
    func syncPlayers(with message: Data) {
        do {
            try mpcHandler.session.send(message, toPeers: mpcHandler.session.connectedPeers, with: .reliable)
        } catch {
            print("Error sending: \(error.localizedDescription)")
        }
    }
    
    // Pops up a specified alert message and performs associated action.
    func popUp(message: String, action: ()) {
        let alert = UIAlertController(title: "Tic Tac Toe", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:  { (alert) in
            action
        }))
        present(alert, animated: true, completion: nil)
    }
}

