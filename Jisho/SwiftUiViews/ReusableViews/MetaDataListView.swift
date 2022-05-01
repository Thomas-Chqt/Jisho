//
//  MetaDataListView.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/23.
//

import SwiftUI

struct MetaDataListView<Content: View>: View
{
    @Environment(\.metaDataDict) var metaDataDict
    
    var content: (MetaData) -> Content
    
    @State var search:String = ""
    @State var metaDataDictKeysVisible:[MetaData]? = nil
    
    var body: some View
    {
        let groupedMetaDataDictKeys = Dictionary(grouping: metaDataDictKeysVisible ?? Array(metaDataDict.wrappedValue.keys),
                                                 by: {key -> String in
            switch key {
                
            case .pos(_):
                return "pos"
            case .misc(_):
                return "misc"
            case .ke_inf(_):
                return "ke_inf"
            case .dial(_):
                return "dial"
            case .re_inf(_):
                return "re_inf"
            case .field(_):
                return "field"
            default:
                return "Autres"
            }
        })
        /*
        List {
            Section("pos") {
                ForEach(Array(metaDataDict.wrappedValue.keys)) { metaData in
                    if search == "" || (metaData.description(metaDataDict.wrappedValue).range(of: search, options: .caseInsensitive) != nil) {
                        if case MetaData.pos(_) = metaData {
                            content(metaData)
                        }
                    }
                }
            }
            
            Section("misc") {
                ForEach(Array(metaDataDict.wrappedValue.keys)) { metaData in
                    if search == "" || (metaData.description(metaDataDict.wrappedValue).range(of: search, options: .caseInsensitive) != nil) {
                        if case MetaData.misc(_) = metaData {
                            content(metaData)
                        }
                    }
                }
            }
            
            Section("ke_inf") {
                ForEach(Array(metaDataDict.wrappedValue.keys)) { metaData in
                    if search == "" || (metaData.description(metaDataDict.wrappedValue).range(of: search, options: .caseInsensitive) != nil) {
                        if case MetaData.ke_inf(_) = metaData {
                            content(metaData)
                        }
                    }
                }
            }
            
            Section("dial") {
                ForEach(Array(metaDataDict.wrappedValue.keys)) { metaData in
                    if search == "" || (metaData.description(metaDataDict.wrappedValue).range(of: search, options: .caseInsensitive) != nil) {
                        if case MetaData.dial(_) = metaData {
                            content(metaData)
                        }
                    }
                }
            }
            
            Section("re_inf") {
                ForEach(Array(metaDataDict.wrappedValue.keys)) { metaData in
                    if search == "" || (metaData.description(metaDataDict.wrappedValue).range(of: search, options: .caseInsensitive) != nil) {
                        if case MetaData.re_inf(_) = metaData {
                            content(metaData)
                        }
                    }
                }
            }
            
            Section("field") {
                ForEach(Array(metaDataDict.wrappedValue.keys)) { metaData in
                    if search == "" || (metaData.description(metaDataDict.wrappedValue).range(of: search, options: .caseInsensitive) != nil) {
                        if case MetaData.field(_) = metaData {
                            content(metaData)
                        }
                    }
                }
            }
        }
         */
        
        List {
            Section("pos") {
                ForEach(groupedMetaDataDictKeys["pos"] ?? []) { metaData in
                    content(metaData)
                }
            }
            
            Section("misc") {
                ForEach(groupedMetaDataDictKeys["misc"] ?? []) { metaData in
                    content(metaData)
                }
            }
            
            Section("ke_inf") {
                ForEach(groupedMetaDataDictKeys["ke_inf"] ?? []) { metaData in
                    content(metaData)
                }
            }
            
            Section("dial") {
                ForEach(groupedMetaDataDictKeys["dial"] ?? []) { metaData in
                    content(metaData)
                }
            }
            
            Section("re_inf") {
                ForEach(groupedMetaDataDictKeys["re_inf"] ?? []) { metaData in
                    content(metaData)
                }
            }
            
            Section("field") {
                ForEach(groupedMetaDataDictKeys["field"] ?? []) { metaData in
                    content(metaData)
                }
            }
        }
        .searchable(text: $search)
        .onChange(of: search, perform: { search in
            self.metaDataDictKeysVisible = metaDataDict.wrappedValue.compactMap { (key: MetaData, value: String?) -> MetaData? in
                if search == "" { return key }
                else if (value ?? "").range(of: search, options: .caseInsensitive) != nil {return key}
                else { return nil as MetaData?}
            }
        })
        .animation(.default, value: metaDataDictKeysVisible)
    }
}


//struct MetaDataListView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        MetaDataListView(metaDataDict: savedMetaDataDict) { metaData in
//            Text(metaData.description)
//        }
//    }
//}
