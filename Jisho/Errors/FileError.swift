//
//  FileError.swift
//  Jisho
//
//  Created by Thomas Choquet on 2023/03/23.
//

import Foundation

enum FileError: Error {
	case readError
	
	var localizedDescription: String {
		switch self {
		case .readError:
			return "Read error"
		}
	}
}
