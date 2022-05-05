//
//  Enums.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/04.
//

import Foundation
import CoreGraphics
import SwiftUI

enum Langue: String, Encodable, /*Comparable,*/ Decodable, Identifiable
{
    var id: Self { self }
    
    case francais = "fre"
    case anglais = "eng"
    case espagnol = "spa"
    case russe = "rus"
    case neerlandais = "dut"
    case allemand = "ger"
    case hongrois = "hun"
    case suedois = "swe"
    case slovene = "slv"
    case none = "none"
        
    static func init_(_ isoCode:String?) -> Langue {
        guard let isoCode = isoCode else { return .none }
        
        if let founded = Langue(rawValue: isoCode) {
            return founded
        }
        else {
            return Langue.none
        }
    }
    
    var flag:String {
        switch self {
        case .francais:
            return "🇫🇷"
        case .anglais:
            return "🇬🇧"
        case .espagnol:
            return "🇪🇸"
        case .russe:
            return "🇷🇺"
        case .neerlandais:
            return "🇳🇱"
        case .allemand:
            return "🇩🇪"
        case .hongrois:
            return "🇭🇺"
        case .suedois:
            return "🇸🇪"
        case .slovene:
            return "🇸🇮"
        case .none:
            return "🇺🇳"
        }
    }

    var fullName:String {
        switch self {
        case .francais:
            return "Français"
        case .anglais:
            return "Anglais"
        case .espagnol:
            return "Espagnol"
        case .russe:
            return "Russe"
        case .neerlandais:
            return "Néerlandais"
        case .allemand:
            return "Allemand"
        case .hongrois:
            return "Hongrois"
        case .suedois:
            return "Suédois"
        case .slovene:
            return "Slovène"
        case .none:
            return "Pas de langue"
        }
    }
    
}

enum TypeInit
{
    case vide
    case preview
}

enum LoadingStatus
{
    case loading
    case loadingPercent(String, Int)
    case finished
}

enum ErrorPerso: Error {
    case metaDataTypeInconnu
    case keyInconnue
    case pasDeMainListe
    case multipleMainListe
    case mulitipleMotWithSameUUID
    case unableToFindTheMot
    case wtf
    
    var localizedDescription: String {
        get {
            switch self {
            case .metaDataTypeInconnu:
                return "MetaData type in importer not exist in the enum"
            case .keyInconnue:
                return "MetaData key in importer no exist in the enum"
            case .wtf:
                return "WTF"
            case .pasDeMainListe:
                return "No liste without parent"
            case .multipleMainListe:
                return "Multiple liste without parent"
            case .mulitipleMotWithSameUUID:
                return "Mulitiple mot with same UUID"
            case .unableToFindTheMot:
                return "Unable to find the mot"
            }
        }
    }
}


enum Page {
    case search
    case listes
    case settings
    case debug
}

enum MetaData: Equatable, Hashable, Identifiable
{
    
    var id: Self { self }
    
    indirect case pos(MetaDataKey)
    /*indirect*/ case ke_pri(String)// -> special
    /*indirect*/ case re_pri(String)// -> special
    indirect case misc(MetaDataKey)
    indirect case ke_inf(MetaDataKey)
    indirect case dial(MetaDataKey)
    indirect case re_inf(MetaDataKey)
    indirect case field(MetaDataKey)
        
    case s_inf(String)
    case stagk(String)
    case stagr(String)
    case xref(String)
    case ant(String)
    case perso(String)
    
    /*
    var description: String {
        switch self {
        case .pos(let metaDataKey):
            return (savedMetaDataDict[MetaData.pos(metaDataKey)] ?? "MetaData inconnu") ?? "Meta data vide"
        case .ke_pri(let string):
            return string
        case .re_pri(let string):
            return string
        case .misc(let metaDataKey):
            return (savedMetaDataDict[MetaData.misc(metaDataKey)] ?? "MetaData inconnu") ?? "Meta data vide"
        case .ke_inf(let metaDataKey):
            return (savedMetaDataDict[MetaData.ke_inf(metaDataKey)] ?? "MetaData inconnu") ?? "Meta data vide"
        case .dial(let metaDataKey):
            return (savedMetaDataDict[MetaData.dial(metaDataKey)] ?? "MetaData inconnu") ?? "Meta data vide"
        case .re_inf(let metaDataKey):
            return (savedMetaDataDict[MetaData.re_inf(metaDataKey)] ?? "MetaData inconnu") ?? "Meta data vide"
        case .field(let metaDataKey):
            return (savedMetaDataDict[MetaData.field(metaDataKey)] ?? "MetaData inconnu") ?? "Meta data vide"
        case .s_inf(let string):
            return string
        case .stagk(let string):
            return string
        case .stagr(let string):
            return string
        case .xref(let string):
            return string
        case .ant(let string):
            return string
        case .perso(let string):
            return string
        }
    }
    */
    
    func description(_ dict:[MetaData:String?]) -> String {
        switch self {
        case .pos(let metaDataKey):
            return (dict[MetaData.pos(metaDataKey)] ?? "MetaData inconnu") ?? "Meta data vide"
        case .ke_pri(let string):
            return string
        case .re_pri(let string):
            return string
        case .misc(let metaDataKey):
            return (dict[MetaData.misc(metaDataKey)] ?? "MetaData inconnu") ?? "Meta data vide"
        case .ke_inf(let metaDataKey):
            return (dict[MetaData.ke_inf(metaDataKey)] ?? "MetaData inconnu") ?? "Meta data vide"
        case .dial(let metaDataKey):
            return (dict[MetaData.dial(metaDataKey)] ?? "MetaData inconnu") ?? "Meta data vide"
        case .re_inf(let metaDataKey):
            return (dict[MetaData.re_inf(metaDataKey)] ?? "MetaData inconnu") ?? "Meta data vide"
        case .field(let metaDataKey):
            return (dict[MetaData.field(metaDataKey)] ?? "MetaData inconnu") ?? "Meta data vide"
        case .s_inf(let string):
            return string
        case .stagk(let string):
            return string
        case .stagr(let string):
            return string
        case .xref(let string):
            return string
        case .ant(let string):
            return string
        case .perso(let string):
            return string
        }
    }
}

enum MetaDataKey: String {
    
//    <!-- <dial> (dialect) entities -->
    case bra = "bra"
    case hob = "hob"
    case ksb = "ksb"
    case ktb = "ktb"
    case kyb = "kyb"
    case kyu = "kyu"
    case nab = "nab"
    case osb = "osb"
    case rkb = "rkb"
    case thb = "thb"
    case tsb = "tsb"
    case tsug = "tsug"
//    <!-- <field> entities -->
    case agric = "agric"
    case anat = "anat"
    case archeol = "archeol"
    case archit = "archit"
    case art = "art"
    case astron = "astron"
    case audvid = "audvid"
    case aviat = "aviat"
    case baseb = "baseb"
    case biochem = "biochem"
    case biol = "biol"
    case bot = "bot"
    case Buddh = "Buddh"
    case bus = "bus"
    case chem = "chem"
    case Christn = "Christn"
    case cloth = "cloth"
    case comp = "comp"
    case cryst = "cryst"
    case ecol = "ecol"
    case econ = "econ"
    case elec = "elec"
    case electr = "electr"
    case embryo = "embryo"
    case engr = "engr"
    case ent = "ent"
    case finc = "finc"
    case fish = "fish"
    case food = "food"
    case gardn = "gardn"
    case genet = "genet"
    case geogr = "geogr"
    case geol = "geol"
    case geom = "geom"
    case go = "go"
    case golf = "golf"
    case gramm = "gramm"
    case grmyth = "grmyth"
    case hanaf = "hanaf"
    case horse = "horse"
    case law = "law"
    case ling = "ling"
    case logic = "logic"
    case MA = "MA"
    case mahj = "mahj"
    case math = "math"
    case mech = "mech"
    case med = "med"
    case met = "met"
    case mil = "mil"
    case music = "music"
    case ornith = "ornith"
    case paleo = "paleo"
    case pathol = "pathol"
    case pharm = "pharm"
    case phil = "phil"
    case photo = "photo"
    case physics = "physics"
    case physiol = "physiol"
    case print = "print"
    case psy = "psy"
    case psych = "psych"
    case rail = "rail"
    case Shinto = "Shinto"
    case shogi = "shogi"
    case sports = "sports"
    case stat = "stat"
    case sumo = "sumo"
    case telec = "telec"
    case tradem = "tradem"
    case vidg = "vidg"
    case zool = "zool"
//    <!-- <ke_inf> (kanji info) entities -->
    case ateji = "ateji"
    case ik = "ikA"
    case iK = "iK"
    case io = "io"
    case oK = "oK"
    case rK = "rK"
//    <!-- <misc> (miscellaneous) entities -->
    case abbr = "abbr"
    case arch = "arch"
    case char = "char"
    case chn = "chn"
    case col = "col"
    case company = "company"
    case creat = "creat"
    case dated = "dated"
    case dei = "dei"
    case derog = "derog"
    case doc = "doc"
    case ev = "ev"
    case fam = "fam"
    case fem = "fem"
    case fict = "fict"
    case form = "form"
    case given = "given"
    case group = "group"
    case hist = "hist"
    case hon = "hon"
    case hum = "hum"
    case id = "id"
    case joc = "joc"
    case leg = "leg"
    case m_sl = "m-sl"
    case male = "male"
    case myth = "myth"
    case net_sl = "net-sl"
    case obj = "obj"
    case obs = "obs"
    case obsc = "obsc"
    case on_mim = "on-mim"
    case organization = "organization"
    case oth = "oth"
    case person = "person"
    case place = "place"
    case poet = "poet"
    case pol = "pol"
    case product = "product"
    case proverb = "proverb"
    case quote = "quote"
    case rare = "rare"
    case relig = "relig"
    case sens = "sens"
    case serv = "serv"
    case sl = "sl"
    case station = "station"
    case surname = "surname"
    case uk = "uk"
    case unclass = "unclass"
    case vulg = "vulg"
    case work = "work"
    case X = "X"
    case yoji = "yoji"
//    <!-- <pos> (part-of-speech) entities -->
    case adj_f = "adj-f"
    case adj_i = "adj-i"
    case adj_ix = "adj-ix"
    case adj_kari = "adj-kari"
    case adj_ku = "adj-ku"
    case adj_na = "adj-na"
    case adj_nari = "adj-nari"
    case adj_no = "adj-no"
    case adj_pn = "adj-pn"
    case adj_shiku = "adj-shiku"
    case adj_t = "adj-t"
    case adv = "adv"
    case adv_to = "adv-to"
    case aux = "aux"
    case aux_adj = "aux-adj"
    case aux_v = "aux-v"
    case conj = "conj"
    case cop = "cop"
    case ctr = "ctr"
    case exp = "exp"
    case int = "int"
    case n = "n"
    case n_adv = "n-adv"
    case n_pr = "n-pr"
    case n_pref = "n-pref"
    case n_suf = "n-suf"
    case n_t = "n-t"
    case num = "num"
    case pn = "pn"
    case pref = "pref"
    case prt = "prt"
    case suf = "suf"
    case unc = "unc"
    case v_unspec = "v-unspec"
    case v1 = "v1"
    case v1_s = "v1-s"
    case v2a_s = "v2a-s"
    case v2b_k = "v2b-k"
    case v2b_s = "v2b-s"
    case v2d_k = "v2d-k"
    case v2d_s = "v2d-s"
    case v2g_k = "v2g-k"
    case v2g_s = "v2g-s"
    case v2h_k = "v2h-k"
    case v2h_s = "v2h-s"
    case v2k_k = "v2k-k"
    case v2k_s = "v2k-s"
    case v2m_k = "v2m-k"
    case v2m_s = "v2m-s"
    case v2n_s = "v2n-s"
    case v2r_k = "v2r-k"
    case v2r_s = "v2r-s"
    case v2s_s = "v2s-s"
    case v2t_k = "v2t-k"
    case v2t_s = "v2t-s"
    case v2w_s = "v2w-s"
    case v2y_k = "v2y-k"
    case v2y_s = "v2y-s"
    case v2z_s = "v2z-s"
    case v4b = "v4b"
    case v4g = "v4g"
    case v4h = "v4h"
    case v4k = "v4k"
    case v4m = "v4m"
    case v4n = "v4n"
    case v4r = "v4r"
    case v4s = "v4s"
    case v4t = "v4t"
    case v5aru = "v5aru"
    case v5b = "v5b"
    case v5g = "v5g"
    case v5k = "v5k"
    case v5k_s = "v5k-s"
    case v5m = "v5m"
    case v5n = "v5n"
    case v5r = "v5r"
    case v5r_i = "v5r-i"
    case v5s = "v5s"
    case v5t = "v5t"
    case v5u = "v5u"
    case v5u_s = "v5u-s"
    case v5uru = "v5uru"
    case vi = "vi"
    case vk = "vk"
    case vn = "vn"
    case vr = "vr"
    case vs = "vs"
    case vs_c = "vs-c"
    case vs_i = "vs-i"
    case vs_s = "vs-s"
    case vt = "vt"
    case vz = "vz"
//    <!-- <re_inf> (reading info) entities -->
    case gikun = "gikun"
    case wika = "ik"
    case ok = "ok"
    case uK = "uK"
}
