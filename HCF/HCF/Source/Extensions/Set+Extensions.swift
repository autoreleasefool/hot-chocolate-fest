import Foundation

extension Set {
	mutating func toggle(_ element: Element) {
		if insert(element).inserted == false {
			remove(element)
		}
	}
}
