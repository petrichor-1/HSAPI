import Foundation

/// Silly little hack because Hopscotch produces slightly nonstandard dates, for some reason
package struct HSDateFormatter {
	static let singleton = {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		return dateFormatter
	}()
}