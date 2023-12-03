import Foundation

class Automation_json {
    private var fileURL: URL
    private var source: DispatchSourceFileSystemObject?

    init(fileURL: URL) {
        self.fileURL = fileURL
    }

    func startWatching() {
        let fileDescriptor = open(fileURL.path, O_EVTONLY)

        guard fileDescriptor != -1 else {
            print("Failed to open file for monitoring.")
            return
        }

        source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileDescriptor,
            eventMask: .write,
            queue: DispatchQueue.global()
        )

        source?.setEventHandler { [weak self] in
            print("File changed. Do something here.")
            self?.handleFileChange()
        }

        source?.resume()
    }

    private func handleFileChange() {
        // 파일이 변경되었을 때 수행할 작업을 여기에 추가
        print("Handling file change...")
    }

    func stopWatching() {
        source?.cancel()
    }
}

// main 함수 추가
func main() {
    let jsonFileURL = URL(fileURLWithPath: "menu_faculty.json")
    let automate = Automation_json(fileURL: jsonFileURL)
    automate.startWatching()
    
    // 프로그램이 종료되지 않도록 대기
    RunLoop.current.run()
}

