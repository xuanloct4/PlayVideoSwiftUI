
import SwiftUI

struct VideoDownloaderView: View {
    let vm: VideoDownloaderViewModel

    var body: some View {
        VStack {
            Spacer()

            if vm.error != nil {
                Text("Error: \(vm.error!)")
            }
            if vm.percentage != nil {
                Text("Downloaded percentage: \(vm.percentage!) %")
            }
            if vm.fileName != nil {
                Text("File name: \(vm.fileName!)")
            }
            if vm.downloadedSize != nil {
                Text("Downloaded size: \(vm.downloadedSize!)")
            }
            if vm.fileLocalURL != nil {
                Text("Stored file url: \(vm.fileLocalURL?.absoluteString ?? "")")
            }
           
            Spacer()

            Group {
                Button("Download in Background") {
                    vm.downloadInBackground()
                }
                .disabled(vm.isBusy)
                HStack {
                    Button("Pause") {
                        vm.pauseDownload()
                    }
                    .disabled(!vm.canPauseDownload)

                    Button("Resume") {
                        vm.resumeDownload()
                    }
                    .disabled(!vm.canResumeDownload)
                }
            }
        }
        .padding()
    }
}
