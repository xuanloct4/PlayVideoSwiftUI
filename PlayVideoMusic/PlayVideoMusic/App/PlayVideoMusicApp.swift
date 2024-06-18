//
//  PlayVideoMusicApp.swift
//  PlayVideoMusic
//
//  Created by AnhND47.APL on 20/12/2022.
//

import SwiftUI
import AVFAudio

@main
struct PlayVideoMusicApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

//    let persistenceController = PersistenceController.shared
    @StateObject private var dataController = DataController()

    @Environment(\.scenePhase) var scenePhase

    init() {
        do {
             try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
             print("Playback OK")
             try AVAudioSession.sharedInstance().setActive(true)
             print("Session is Active")
           } catch {
             print(error)
           }
    }
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
//            VideoDownloadBackgroundView()
        }
        .onChange(of: scenePhase) { _ in
//            persistenceController.save()
            dataController.save()
        }
    }
}
