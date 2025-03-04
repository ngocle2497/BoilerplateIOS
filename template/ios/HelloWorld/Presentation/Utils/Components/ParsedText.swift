import SwiftUI

struct Parse {
    let id: String = UUID().uuidString
    let findingText: LocalizedStringKey
    let modifier: (inout AttributedSubstring) -> Void
    let perform: (()-> Void)?
    
    init(findingText: LocalizedStringKey, modifier: @escaping (inout AttributedSubstring) -> Void, perform: (() -> Void)?) {
        self.findingText = findingText
        self.modifier = modifier
        self.perform = perform
    }
}

private extension LocalizedStringKey {
    var stringKey: String? {
        Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
    }
    func stringValue(locale: Locale = .current) -> String {
        guard let stringKey = self.stringKey else {
            return ""
        }
        let path = Bundle.main.path(forResource: locale.identifier, ofType: "lproj")
        let bundle = Bundle(path: path!)
        let string = bundle?.localizedString(forKey: stringKey, value: nil, table: nil)
        return string ?? ""
    }
}

struct ParsedText: View {
    @State var text: LocalizedStringKey
    @State var parses: [Parse]
    @State var isFirstAppear = true
    @State var resultString: AttributedString = .init()
    
    @Environment(\.locale) var locale
    
    var body: some View {
        Group {
            textAttribute
                .environment(\.openURL, OpenURLAction { url in
                    let parseId = url.absoluteString.replacing("ParseText://", with: "")
                    if let selectedParse = parses.filter({ $0.id == parseId }).first,
                        parseId == selectedParse.id,
                        let perform = selectedParse.perform {
                        perform()
                    }
                    
                    return .discarded
                })
        }
    }
    
    var textAttribute: some View {
        var attributeString = AttributedString(text.stringValue(locale: locale))
        for parse in parses {
            let stringParse = parse.findingText.stringValue(locale: locale)
            if let range = attributeString.range(of: stringParse) {
                parse.modifier(&attributeString[range])
                attributeString[range].link = URL(string: "ParseText://\(parse.id)")
            }
        }
        
        return Text(attributeString)
    }
}
