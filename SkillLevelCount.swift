import SwiftUI

struct SkillLevelCount: View {
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height

    @State private var selectedTsumType: [tsumType] = [.regular, .limited, .pickup, .neverReturn, .reward]
    @State var tsumArray: [Tsum] = [
        Tsum(name: "", type: .regular, slvtype: "36A", slv: 0)
    ]
    @State private var searchText: String = ""
    @State private var sumCoins: Int = 0
    @State private var selectedTsumTypeStr: String = "全ツム"
    @State var myList = [Bool](repeating: false, count: TSUM_ARRAY.count)
    
    @State private var showingMyListModal: Bool = false // MyListModal:CurrentTsumSettings
    init() {
        //        sumCoins = countCoins()
        //        print("list appear")
    }
    
    // ツムのスキルレベル(*100)整数 ex) slv3.5 -> 350
    var body: some View {
        ZStack{
            NavigationStack {
                VStack {
                    List() {
                        ForEach (0..<tsumArray.count, id: \.self) { tsumNum in
                            if selectedTsumType == [.myList] {
                                if myList[tsumNum] && (searchText.isEmpty || tsumArray[tsumNum].name.contains(searchText)){
                                    HStack (spacing: 0) {
                                        Picker(tsumArray[tsumNum].name, selection: $tsumArray[tsumNum].slv) {
                                            ForEach(0..<arrayStr(type: tsumArray[tsumNum].slvtype).count, id: \.self) { index in
                                                Text(arrayStr(type: tsumArray[tsumNum].slvtype)[index])
                                                    .tag(arrayStr(type: tsumArray[tsumNum].slvtype)[index])
                                            }
                                        }
                                        .frame(width: screenWidth*3/5)
                                        .onChange(of: tsumArray[tsumNum].slv) {
                                            saveTsums(tsums: tsumArray)
                                        }
                                        Spacer()
                                        Text(String(tsumArray[tsumNum].slv) + "/" + String(arrayInt(type: tsumArray[tsumNum].slvtype).count-1))
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            else if selectedTsumType.contains(tsumArray[tsumNum].type) && (searchText.isEmpty || tsumArray[tsumNum].name.contains(searchText)) {
                                HStack (spacing: 0) {
                                    Picker(tsumArray[tsumNum].name, selection: $tsumArray[tsumNum].slv) {
                                        ForEach(0..<arrayStr(type: tsumArray[tsumNum].slvtype).count, id: \.self) { index in
                                            Text(arrayStr(type: tsumArray[tsumNum].slvtype)[index])
                                                .tag(arrayStr(type: tsumArray[tsumNum].slvtype)[index])
                                        }
                                    }
                                    .frame(width: screenWidth*3/5)
                                    .onChange(of: tsumArray[tsumNum].slv) {
                                        print(tsumArray[0])
                                        saveTsums(tsums: tsumArray)
                                    }
                                    Spacer()
                                    Text(String(tsumArray[tsumNum].slv) + "/" + String(arrayInt(type: tsumArray[tsumNum].slvtype).count-1))
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                    .frame(maxHeight: screenHeight*3/5)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(0)
                .searchable(text: $searchText)
                .onAppear{
                    tsumArray.removeAll()
                    tsumArray = TSUM_ARRAY
                    
                    if (tsumArray.count <= loadTsums()?.count ?? 0) {
                        tsumArray = loadTsums() ?? []
                    }
                    else if(tsumArray.count > loadTsums()?.count ?? 0) {
                        let kariArray = tsumArray[(loadTsums()?.count ?? 0)..<tsumArray.count]
                        tsumArray = (loadTsums() ?? []) + kariArray
                    }
                    print("list appear")
                    sumCoins = countCoins()
                }
            }
            .frame(maxHeight: screenHeight, alignment: .top)
            
            ZStack {
                VStack(spacing: .zero) {
                    HStack(spacing: 8) {
                        Button(action: {
                            sumCoins = countCoins()
                        }, label: {
                            Text("計算する")
                                .foregroundStyle(.white)
                                .frame(width: screenWidth*1/4 - 10, height: screenHeight/16 - 10)
                                .background(LinearGradient(colors: [.blue, .blue.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 3)
                                .shadow(color: .blue.opacity(0.3), radius: 2, x: 0, y: 1)
                        })
                        
                        Menu {
                            // This should be done in a ForEach loop
                            Button("全ツム", action: {selectedTsumTypeStr = "全ツム"; selectedTsumType = [.regular, .limited, .pickup, .neverReturn, .reward]; sumCoins = countCoins(); print("selected all")})
                            Button("常駐ツム", action: {selectedTsumTypeStr = "常駐ツム"; selectedTsumType = [.regular]; sumCoins = countCoins(); print("selected reg")})
                            Button("期間限定ツム", action: {selectedTsumTypeStr = "期間限定ツム"; selectedTsumType = [.limited]; sumCoins = countCoins(); print("selected ltd")})
                            Button("ピックアップツム", action: {selectedTsumTypeStr = "ピックアップツム"; selectedTsumType = [.pickup]; sumCoins = countCoins(); print("selected pu")})
                            Button("復活しないツム", action: {selectedTsumTypeStr = "復活しないツム"; selectedTsumType = [.neverReturn]; sumCoins = countCoins(); print("selected nr")})
                            Button("報酬ツム", action: {selectedTsumTypeStr = "報酬ツム"; selectedTsumType = [.reward]; sumCoins = countCoins(); print("selected rwd")})
                            Button("MyListに選択中のツム", action: {selectedTsumTypeStr = "MyListに選択中のツム"; selectedTsumType = [.myList]; sumCoins = countCoins(); print("selected crt")})
                        } label: {
                            Text("ツムの絞り込み:\(selectedTsumTypeStr)")
                                .foregroundStyle(.white)
                                .frame(width: screenWidth*3/4-10, height: screenHeight/16 - 10)
                                .background(LinearGradient(colors: [.blue, .blue.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 3)
                                .shadow(color: .blue.opacity(0.3), radius: 2, x: 0, y: 1)
                        }
                    }
                    .frame(height: screenHeight/16)
                    Text("スキルマックスまでのコイン数計算\n\(selectedTsumTypeStr): \(String(sumCoins*30000))コイン")
                        .font(.headline)
                        .frame(width: screenWidth, height: screenHeight/8)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .background(LinearGradient(colors: [.blue, .blue.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing).edgesIgnoringSafeArea(.top))
                }
                .frame(width: screenWidth, height: screenHeight*3/16)
                .background(Color.clear.edgesIgnoringSafeArea(.top))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            ZStack {
                Button{
                    // ContentViewが持つshowingMyListModal(self.showingMyListModal)の切り替え
                    self.showingMyListModal.toggle()
                } label: {
                    Text("MyList選択")
                        .foregroundStyle(.white)
                        .frame(width: screenWidth*1/4 + 10, height: screenHeight/16 - 10)
                        .background(LinearGradient(colors: [.blue, .blue.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 3)
                        .shadow(color: .blue.opacity(0.3), radius: 2, x: 0, y: 1)
                        .offset(x: -20, y: -10)
                }.sheet(isPresented: $showingMyListModal) {
                    MyListModalView(myList: $myList)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    func filterType(tsum:Tsum) -> Bool {
        return selectedTsumType.firstIndex(of: tsum.type) ?? 0 > 0
    }
    private func countCoins(changeNum: Int = 0, oldSum: Int = -1) -> Int{
        var coins: Int = 0
        if changeNum == 0 && oldSum == -1 {
            if selectedTsumType != [.myList] {
                for tsum in tsumArray {
                    if (selectedTsumType.contains(tsum.type)) {
                        coins += (arrayInt(type: tsum.slvtype).count - 1) - tsum.slv
                    }
                }
                print("A", changeNum, oldSum)
            } else {
                for index in tsumArray.indices {
                    if myList[index] {
                        coins += (arrayInt(type: tsumArray[index].slvtype).count - 1) - tsumArray[index].slv
                    }
                }
            }
            return coins
        }
        else if changeNum != 0 && oldSum != -1 {
            coins = oldSum + changeNum
            print("changedPickerValue, oldSum:\(oldSum), changeNum: \(changeNum), => newSum: \(coins)")
            return coins
        }
        else {
            print("C")
            return -1
        }
    }
    private func arrayStr(type: String) -> [String] {
        switch(type) {
        case "36A":
            return arrayStr36A
        case "36B":
            return arrayStr36B
        case "36C":
            return arrayStr36C
        case "35A":
            return arrayStr35A
        case "35B":
            return arrayStr35B
        case "34A":
            return arrayStr34A
        case "32A":
            return arrayStr32A
        case "32B":
            return arrayStr32B
        case "30A":
            return arrayStr30A
        case "30B":
            return arrayStr30B
        case "30C":
            return arrayStr30C
        case "29A":
            return arrayStr29A
        case "28A":
            return arrayStr28A
        case "27A":
            return arrayStr27A
        case "17A":
            return arrayStr17A
        case "15A":
            return arrayStr15A
        case "15B":
            return arrayStr15B
        case "13A":
            return arrayStr13A
        case "12A":
            return arrayStr12A
        case "10A":
            return arrayStr10A
        case "9A":
            return arrayStr9A
        case "8A":
            return arrayStr8A
        case "7A":
            return arrayStr7A
        case "7B":
            return arrayStr7B
        case "6A":
            return arrayStr6A
        case "6B":
            return arrayStr6B
        case "5A":
            return arrayStr5A
        case "5B":
            return arrayStr5B
        case "4A":
            return arrayStr4A
        case "3A":
            return arrayStr3A
        case "1A":
            return arrayStr1A
        default:
            return ["-1"]
        }
    }
    private func arrayInt(type: String) -> [Int] {
        switch(type) {
        case "36A":
            return arrayInt36A
        case "36B":
            return arrayInt36B
        case "36C":
            return arrayInt36C
        case "35A":
            return arrayInt35A
        case "35B":
            return arrayInt35B
        case "34A":
            return arrayInt34A
        case "32A":
            return arrayInt32A
        case "32B":
            return arrayInt32B
        case "30A":
            return arrayInt30A
        case "30B":
            return arrayInt30B
        case "30C":
            return arrayInt30C
        case "29A":
            return arrayInt29A
        case "28A":
            return arrayInt28A
        case "27A":
            return arrayInt27A
        case "17A":
            return arrayInt17A
        case "15A":
            return arrayInt15A
        case "15B":
            return arrayInt15B
        case "13A":
            return arrayInt13A
        case "12A":
            return arrayInt12A
        case "10A":
            return arrayInt10A
        case "9A":
            return arrayInt9A
        case "8A":
            return arrayInt8A
        case "7A":
            return arrayInt7A
        case "7B":
            return arrayInt7B
        case "6A":
            return arrayInt6A
        case "6B":
            return arrayInt6B
        case "5A":
            return arrayInt5A
        case "5B":
            return arrayInt5B
        case "4A":
            return arrayInt4A
        case "3A":
            return arrayInt3A
        case "1A":
            return arrayInt1A
        default:
            return [-1]
        }
    }
    func saveTsums(tsums: [Tsum]) {
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(tsums) else {
            return
        }
        UserDefaults.standard.set(data, forKey: "TSUMS_ARRAY")
    }
    func loadTsums() -> [Tsum]? {
        let jsonDecoder = JSONDecoder()
        guard let data = UserDefaults.standard.data(forKey: "TSUMS_ARRAY"),
              let tsums = try? jsonDecoder.decode([Tsum].self, from: data) else {
            return nil
        }
        return tsums
    }
    func docURL(_ fileName:String) -> URL? {
        let fileManager = FileManager.default
        do {
            //Documentsフォルダ
            let docsUrl = try fileManager.url(
                //Documentフォルダを指定する。
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false)
            let url = docsUrl.appendingPathComponent(fileName)
            return url
        }catch {
            return nil
        }
    }
    //テキストデータを読み込んで返す。
    func loadText(_ fileName:String) -> String? {
        //URLを得られたらアンラップしてurlに代入
        guard let url = docURL(fileName) else {
            return nil
        }
        //urlからの読み込み
        do {
            let textData = try String(contentsOf: url, encoding: .utf8)
            return textData
        } catch {
            return nil
        }
    }
    
}

public struct Tsum:Identifiable, Codable {
    public var id = UUID()
    var name:String
    var type:tsumType
    var slvtype:String
    var slv:Int
}

public enum tsumType: String, Codable {
    case regular = "常駐ツム"
    case limited = "期間限定ツム"
    case pickup = "ピックアップツム"
    case neverReturn = "復活しないツム"
    case reward = "報酬ツム"
    case myList = "現在開催中のボックスのツム"
}

struct MyListModalView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var myList: [Bool]
    @State private var searchText: String = ""

    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: 30) {
                Button(action: {
                    resetMyList()
                }, label: {
                    Text("リセット")
                        .frame(width: screenWidth*1/4 - 10, height: screenHeight/16 - 10)
                })
                Button(action: {
                    dismiss()
                }, label: {
                    Text("閉じる")
                        .foregroundStyle(.white)
                        .frame(width: screenWidth*1/4 - 10, height: screenHeight/16 - 10)
                        .background(LinearGradient(colors: [.blue, .blue.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 3)
                        .shadow(color: .blue.opacity(0.3), radius: 2, x: 0, y: 1)
                })
            }
            .frame(alignment: .center)
            .padding(30)
            ZStack {
                Rectangle()
                    .fill(Color(red: 239 / 255,
                                green: 239 / 255,
                                blue: 241 / 255))
                    .frame(width: screenWidth*2/3 + 30, height: 40)
                    .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                TextField("ツム名で検索", text: $searchText)
                    .frame(width: screenWidth*2/3, height: 50)
            }
            List {
                ForEach (0..<TSUM_ARRAY.count, id: \.self) { num in
                    if checkIsOn(num: num) {
                        Toggle(TSUM_ARRAY[num].name, isOn: $myList[num])
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    private func checkIsOn(num: Int) -> Bool {
        return (myList[num] || TSUM_ARRAY[num].name.contains(searchText)) ? true:false
    }
    private func resetMyList() {
        for index in myList.indices {
            myList[index] = false
        }
    }
}

#Preview {
    SkillLevelCount()
}
