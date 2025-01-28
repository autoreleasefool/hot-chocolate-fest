import Foundation

func extractDate(from text: any StringProtocol, format: String) -> Date? {
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = format
	return dateFormatter.date(from: String(text))
}
