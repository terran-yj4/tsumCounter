import Foundation

class fileReadModel: ObservableObject {
    
    let fm = FileManager.default
    
    func readData() -> String {
        var output = ""
        guard let path = fm.urls(for: .desktopDirectory, in: .userDomainMask).first else {
            fatalError("URL取得失敗")
        }
        let fullURL = path.appendingPathComponent("sample.txt")
        do {
            output = try String(contentsOf: fullURL, encoding: .utf8)
        } catch {
            output = "読み込み失敗"
        }
        return output
    }
}
