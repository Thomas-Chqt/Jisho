//
//  Constantes.swift
//  Jisho
//
//  Created by Thomas Choquet on 2022/03/05.
//

import Foundation
import CoreData

let languesAffichéesOriginal: Set<Langue> = [.francais, .anglais, .none]

let languesPrefOriginal:[Langue] = [.francais, .anglais, .espagnol, .russe, .neerlandais, .allemand, .hongrois, .suedois, .slovene, .none]

let cacheMotModifier = NSCache<NSUUID, NSManagedObjectID>()
let motJMdictSearchTableCache = NSCache<NSNumber, NSDictionary>()


struct CommunMetaData {
    static let suru = MetaData.pos(.vs)
    static let kanaSeul = MetaData.re_inf(.uK)
    static let nomCommun = MetaData.pos(.n)
}


let metaDataDictOriginal:[MetaData:String] = [
    
//    <!-- <dial> (dialect) entities -->
    MetaData.dial(.bra): "Brésilien",
    MetaData.dial(.hob): "Hokkaido-ben",
    MetaData.dial(.ksb): "Kansai-ben",
    MetaData.dial(.ktb): "Kantou-ben",
    MetaData.dial(.kyb): "Kyoto-ben",
    MetaData.dial(.kyu): "Kyuushuu-ben",
    MetaData.dial(.nab): "Nagano-ben",
    MetaData.dial(.osb): "Osaka-ben",
    MetaData.dial(.rkb): "Ryuukyuu-ben",
    MetaData.dial(.thb): "Touhoku-ben",
    MetaData.dial(.tsb): "Tosa-ben",
    MetaData.dial(.tsug): "Tsugaru-ben",
//    <!-- <field> entities -->
    MetaData.field(.agric): "agriculture",
    MetaData.field(.anat): "anatomie",
    MetaData.field(.archeol): "archéologie",
    MetaData.field(.archit): "architecture",
    MetaData.field(.art): "art, esthétique",
    MetaData.field(.astron): "astronomie",
    MetaData.field(.audvid): "audio-visuel",
    MetaData.field(.aviat): "aviation",
    MetaData.field(.baseb): "base-ball",
    MetaData.field(.biochem): "biochimie",
    MetaData.field(.biol): "biologie",
    MetaData.field(.bot): "botanique",
    MetaData.field(.Buddh): "bouddhisme",
    MetaData.field(.bus): "business",
    MetaData.field(.chem): "chimie",
    MetaData.field(.Christn): "Christianisme",
    MetaData.field(.cloth): "Vêtements",
    MetaData.field(.comp): "informatique",
    MetaData.field(.cryst): "cristallographie",
    MetaData.field(.ecol): "écologie",
    MetaData.field(.econ): "économie",
    MetaData.field(.elec): "electricity, elec. eng.",
    MetaData.field(.electr): "électronique",
    MetaData.field(.embryo): "embryologie",
    MetaData.field(.engr): "ingénierie",
    MetaData.field(.ent): "entomologie",
    MetaData.field(.finc): "finance",
    MetaData.field(.fish): "pêche",
    MetaData.field(.food): "nourriture, cuisine",
    MetaData.field(.gardn): "jardinage, horticulture",
    MetaData.field(.genet): "génétique",
    MetaData.field(.geogr): "géographie",
    MetaData.field(.geol): "géologie",
    MetaData.field(.geom): "géométrie",
    MetaData.field(.go): "go (jeu))",
    MetaData.field(.golf): "golf",
    MetaData.field(.gramm): "grammaire",
    MetaData.field(.grmyth): "mythologie grecque",
    MetaData.field(.hanaf): "hanafuda",
    MetaData.field(.horse): "course de chevaux",
    MetaData.field(.law): "loi",
    MetaData.field(.ling): "linguistique",
    MetaData.field(.logic): "logique",
    MetaData.field(.MA): "arts martiaux",
    MetaData.field(.mahj): "mahjong",
    MetaData.field(.math): "mathématiques",
    MetaData.field(.mech): "génie mécanique",
    MetaData.field(.med): "médecine",
    MetaData.field(.met): "météorologie",
    MetaData.field(.mil): "militaire",
    MetaData.field(.music): "musique",
    MetaData.field(.ornith): "ornithology",
    MetaData.field(.paleo): "ornithologie",
    MetaData.field(.pathol): "pathologie",
    MetaData.field(.pharm): "pharmacie",
    MetaData.field(.phil): "philosophie",
    MetaData.field(.photo): "photographie",
    MetaData.field(.physics): "physique",
    MetaData.field(.physiol): "physiologie",
    MetaData.field(.print): "imprimerie",
    MetaData.field(.psy): "psychiatrie",
    MetaData.field(.psych): "psychologie",
    MetaData.field(.rail): "chemin de fer",
    MetaData.field(.Shinto): "Shinto",
    MetaData.field(.shogi): "shogi",
    MetaData.field(.sports): "sports",
    MetaData.field(.stat): "statistiques",
    MetaData.field(.sumo): "sumo",
    MetaData.field(.telec): "telecommunications",
    MetaData.field(.tradem): "marque déposée",
    MetaData.field(.vidg): "video games",
    MetaData.field(.zool): "zoologie",
//    <!-- <ke_inf> (kanji info) entities -->
    MetaData.ke_inf(.ateji): "ateji (phonetic) reading",
    MetaData.ke_inf(.ik): "word containing irregular kana usage",
    MetaData.ke_inf(.iK): "word containing irregular kanji usage",
    MetaData.ke_inf(.io): "irregular okurigana usage",
    MetaData.ke_inf(.oK): "word containing out-dated kanji or kanji usage",
    MetaData.ke_inf(.rK): "rarely-used kanji form",
//    <!-- <misc> (miscellaneous) entities -->
    MetaData.misc(.abbr): "abréviation",
    MetaData.misc(.arch): "archaïsme",
    MetaData.misc(.char): "personnage",
    MetaData.misc(.chn): "langue des enfants",
    MetaData.misc(.col): "expression familière",
    MetaData.misc(.company): "Nom de d'entreprise",
    MetaData.misc(.creat): "créature",
    MetaData.misc(.dated): "terme daté",
    MetaData.misc(.dei): "déité",
    MetaData.misc(.derog): "péjoratif",
    MetaData.misc(.doc): "document",
    MetaData.misc(.ev): "événement",
    MetaData.misc(.fam): "language familié",
    MetaData.misc(.fem): "terme ou language féminin",
    MetaData.misc(.fict): "fiction",
    MetaData.misc(.form): "terme formel ou littéraire",
    MetaData.misc(.given): "prénom ou prénom, sexe non précisé",
    MetaData.misc(.group): "groupe",
    MetaData.misc(.hist): "terme historique",
    MetaData.misc(.hon): "尊敬語（そんけいご）",
    MetaData.misc(.hum): "謙譲語（けんじょうご）",
    MetaData.misc(.id): "expression idiomatique",
    MetaData.misc(.joc): "terme plaisant et humoristique",
    MetaData.misc(.leg): "Légende",
    MetaData.misc(.m_sl): "argot manga",
    MetaData.misc(.male): "terme ou language masculin",
    MetaData.misc(.myth): "mythologie",
    MetaData.misc(.net_sl): "argot d'internet",
    MetaData.misc(.obj): "objet",
    MetaData.misc(.obs): "obsolete term",
    MetaData.misc(.obsc): "terme obscur",
    MetaData.misc(.on_mim): "mot onomatopéique ou mimétique",
    MetaData.misc(.organization): "nom d'organisation",
    MetaData.misc(.oth): "autre",
    MetaData.misc(.person): "nom complet d'une personne en particulier",
    MetaData.misc(.place): "nom de lieu",
    MetaData.misc(.poet): "terme poétique",
    MetaData.misc(.pol): "丁寧語（ていねいご）",
    MetaData.misc(.product): "nom de produit",
    MetaData.misc(.proverb): "proverbe",
    MetaData.misc(.quote): "devis",
    MetaData.misc(.rare): "rare",
    MetaData.misc(.relig): "religion",
    MetaData.misc(.sens): "sensible",
    MetaData.misc(.serv): "service",
    MetaData.misc(.sl): "argot",
    MetaData.misc(.station): "gare",
    MetaData.misc(.surname): "famille ou nom",
    MetaData.misc(.uk): "word usually written using kana alone",
    MetaData.misc(.unclass): "nom non classé",
    MetaData.misc(.vulg): "expression ou mot vulgaire",
    MetaData.misc(.work): "œuvre d'art, littérature, musique, etc. nom",
    MetaData.misc(.X): "terme grossier ou classé X (non affiché dans les logiciels éducatifs)",
    MetaData.misc(.yoji): "四字熟語（よじじゅく）yojijukugo",
//    <!-- <pos> (part-of-speech) entities -->
    MetaData.pos(.adj_f): "nom ou verbe prénominatif",
    MetaData.pos(.adj_i): "Adjectif en い",
    MetaData.pos(.adj_ix): "Adjectif en い de la classe よい・いい",
    MetaData.pos(.adj_kari): "'kari' adjectif (archaïque)",
    MetaData.pos(.adj_ku): "'ku' adjectif (archaïque)",
    MetaData.pos(.adj_na): "Adjectif en な",
    MetaData.pos(.adj_nari): "forme archaïque/formelle d'adjectif en な",
    MetaData.pos(.adj_no): "les noms qui peuvent prendre la particule génitive 'の'",
    MetaData.pos(.adj_pn): "pre-noun adjectival (rentaishi)",
    MetaData.pos(.adj_shiku): "'shiku' adjectif (archaïque)",
    MetaData.pos(.adj_t): "'taru' adjectif",
    MetaData.pos(.adv): "adverbe 福祉（ふくし）",
    MetaData.pos(.adv_to): "adverbe prenant la particule 'と'",
    MetaData.pos(.aux): "auxiliaire",
    MetaData.pos(.aux_adj): "adjectif auxiliaire",
    MetaData.pos(.aux_v): "verbe auxiliaire",
    MetaData.pos(.conj): "conjonction",
    MetaData.pos(.cop): "copule",
    MetaData.pos(.ctr): "compteur",
    MetaData.pos(.exp): "expressions (phrases, clauses, etc.)",
    MetaData.pos(.int): "interjection (kandoushi)",
    MetaData.pos(.n): "nom (commun) 普通名詞（ふつうめいし）",
    MetaData.pos(.n_adv): "nom adverbial (fukushitekimeishi)",
    MetaData.pos(.n_pr): "nom propre",
    MetaData.pos(.n_pref): "nom, utilisé comme préfixe",
    MetaData.pos(.n_suf): "noun, used as a suffix",
    MetaData.pos(.n_t): "nom (temporel) (jisoumeishi)",
    MetaData.pos(.num): "numérique",
    MetaData.pos(.pn): "pronom",
    MetaData.pos(.pref): "préfixe",
    MetaData.pos(.prt): "particule",
    MetaData.pos(.suf): "suffixe",
    MetaData.pos(.unc): "non classé",
    MetaData.pos(.v_unspec): "verbe non spécifié",
    MetaData.pos(.v1): "Verbe 一段 / Groupe 2",
    MetaData.pos(.v1_s): "Verbe 一段 / Groupe 2 - kureru special class",
    MetaData.pos(.v2a_s): "Nidan verb with 'u' ending (archaic)",
    MetaData.pos(.v2b_k): "Nidan verb (upper class) with 'bu' ending (archaic)",
    MetaData.pos(.v2b_s): "Nidan verb (lower class) with 'bu' ending (archaic)",
    MetaData.pos(.v2d_k): "Nidan verb (upper class) with 'dzu' ending (archaic)",
    MetaData.pos(.v2d_s): "Nidan verb (lower class) with 'dzu' ending (archaic)",
    MetaData.pos(.v2g_k): "Nidan verb (upper class) with 'gu' ending (archaic)",
    MetaData.pos(.v2g_s): "Nidan verb (lower class) with 'gu' ending (archaic)",
    MetaData.pos(.v2h_k): "Nidan verb (upper class) with 'hu/fu' ending (archaic)",
    MetaData.pos(.v2h_s): "Nidan verb (lower class) with 'hu/fu' ending (archaic)",
    MetaData.pos(.v2k_k): "Nidan verb (upper class) with 'ku' ending (archaic)",
    MetaData.pos(.v2k_s): "Nidan verb (lower class) with 'ku' ending (archaic)",
    MetaData.pos(.v2m_k): "Nidan verb (upper class) with 'mu' ending (archaic)",
    MetaData.pos(.v2m_s): "Nidan verb (lower class) with 'mu' ending (archaic)",
    MetaData.pos(.v2n_s): "Nidan verb (lower class) with 'nu' ending (archaic)",
    MetaData.pos(.v2r_k): "Nidan verb (upper class) with 'ru' ending (archaic)",
    MetaData.pos(.v2r_s): "Nidan verb (lower class) with 'ru' ending (archaic)",
    MetaData.pos(.v2s_s): "Nidan verb (lower class) with 'su' ending (archaic)",
    MetaData.pos(.v2t_k): "Nidan verb (upper class) with 'tsu' ending (archaic)",
    MetaData.pos(.v2t_s): "Nidan verb (lower class) with 'tsu' ending (archaic)",
    MetaData.pos(.v2w_s): "Nidan verb (lower class) with 'u' ending and 'we' conjugation (archaic)",
    MetaData.pos(.v2y_k): "Nidan verb (upper class) with 'yu' ending (archaic)",
    MetaData.pos(.v2y_s): "Nidan verb (lower class) with 'yu' ending (archaic)",
    MetaData.pos(.v2z_s): "Nidan verb (lower class) with 'zu' ending (archaic)",
    MetaData.pos(.v4b): "Yodan verb with 'bu' ending (archaic)",
    MetaData.pos(.v4g): "Yodan verb with 'gu' ending (archaic)",
    MetaData.pos(.v4h): "Yodan verb with 'hu/fu' ending (archaic)",
    MetaData.pos(.v4k): "Yodan verb with 'ku' ending (archaic)",
    MetaData.pos(.v4m): "Yodan verb with 'mu' ending (archaic)",
    MetaData.pos(.v4n): "Yodan verb with 'nu' ending (archaic)",
    MetaData.pos(.v4r): "Yodan verb with 'ru' ending (archaic)",
    MetaData.pos(.v4s): "Yodan verb with 'su' ending (archaic)",
    MetaData.pos(.v4t): "Yodan verb with 'tsu' ending (archaic)",
    MetaData.pos(.v5aru): "Verbe 五段 / Groupe 1 - classe speciale -ある): ",
    MetaData.pos(.v5b): "Verbe 五段 / Groupe 1 Avec terminaison en 'ぶ'",
    MetaData.pos(.v5g): "Verbe 五段 / Groupe 1 Avec terminaison en 'ぐ'",
    MetaData.pos(.v5k): "Verbe 五段 / Groupe 1 Avec terminaison en 'く'",
    MetaData.pos(.v5k_s): "Verbe 五段 / Groupe 1 - classe speciale -いく・ゆく",
    MetaData.pos(.v5m): "Verbe 五段 / Groupe 1 Avec terminaison en 'む'",
    MetaData.pos(.v5n): "Verbe 五段 / Groupe 1 Avec terminaison en 'ぬ'",
    MetaData.pos(.v5r): "Verbe 五段 / Groupe 1 Avec terminaison en 'る'",
    MetaData.pos(.v5r_i): "Verbe 五段 / Groupe 1 Avec terminaison en 'る' (verbe irregulier)",
    MetaData.pos(.v5s): "Verbe 五段 / Groupe 1 Avec terminaison en 'す'",
    MetaData.pos(.v5t): "Verbe 五段 / Groupe 1 Avec terminaison en 'つ'",
    MetaData.pos(.v5u): "Verbe 五段 / Groupe 1 Avec terminaison en 'う'",
    MetaData.pos(.v5u_s): "Verbe 五段 / Groupe 1 Avec terminaison en 'う' (classe spéciale)",
    MetaData.pos(.v5uru): "Verbe 五段 / Groupe 1 ancien - verbe de classe -うる (ancienne forme d'える)",
    MetaData.pos(.vi): "自動詞（じどうし）Verbe Intransitif",
    MetaData.pos(.vk): "Verbe くる - classe spéciale",
    MetaData.pos(.vn): "verbe ぬ irrégulier",
    MetaData.pos(.vr): "verbe る irrégulier, la forme simple se termine par -り",
    MetaData.pos(.vs): "noun or participle which takes the aux. verb suru",
    MetaData.pos(.vs_c): "verbe す - précurseur du する moderne",
    MetaData.pos(.vs_i): "verbe する (inclus)",
    MetaData.pos(.vs_s): "verbe する - classe spéciale",
    MetaData.pos(.vt): "他動詞（たどうし）Verbe Transitif",
    MetaData.pos(.vz): "Verbe 一段 / Groupe 2 - verbe ずる (forme alternative des verbes -じる)",
//    <!-- <re_inf> (reading info) entities -->
    MetaData.re_inf(.gikun): "gikun (meaning as reading) or jukujikun (special kanji reading)",
    MetaData.re_inf(.wika): "word containing irregular kana usage",
    MetaData.re_inf(.ok): "out-dated or obsolete kana usage",
    MetaData.re_inf(.uK): "word usually written using kanji alone"
]

