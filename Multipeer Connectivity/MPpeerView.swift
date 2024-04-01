//
//  MPpeerView.swift
//  NavTool
//
//  Created by Cooper Anderson on 3/31/24.
//

import SwiftUI

struct MPpeerView: View {
    @EnvironmentObject var connectionManager: MPConnectionManager
    @EnvironmentObject var game: GETGPS
    @Binding var startGame: Bool
    var body: some View {
        VStack {
            Text("Available Players")
            List(connectionManager.avaialblePeers, id: \.self) {peer in HStack {
                Text(peer.displayName)
                Spacer()
                Button("Select") {
                    connectionManager.nearbyServiceBrowser.invitePeer(peer, to: connectionManager.session, withContext: nil, timeout: 30)
                }.buttonStyle(.borderedProminent)
            }
            .alert("Recieved Invitation from \(connectionManager.recievedInviteFrom?.displayName ?? "Unknown")", isPresented: $connectionManager.recievedInvite) {
                Button("Accept") {
                    if let invitationHandler = connectionManager.invitationHandler {
                        invitationHandler(true, connectionManager.session)
                    }
                }
                Button("Reject") {
                    if let invitationHandler = connectionManager.invitationHandler {
                        invitationHandler(false, nil)
                    }
                }
            }
            }
        }
        .onAppear {
            connectionManager.isAvailablyToPlay = true
            connectionManager.startBrowsing()
        }
        .onDisappear {
            connectionManager.stopBrowsing()
            connectionManager.stopAdvertising()
            connectionManager.isAvailablyToPlay = false
        }
        .onChange(of: connectionManager.paired) {
            newValue in startGame = newValue
        }
    }
}

