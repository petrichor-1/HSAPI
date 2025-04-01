import Foundation

class CustomObject {
	///When the image was added to the project
	var createdAt: Date
	var fileName: String
	var id: String
	var name: String
	///Image dimensions
	var size: (width: Double, height: Double)
	///When the image was last updated at
	var updatedAt: Date

	weak var project: Project?

	init(createdAt: Date, fileName: String, id: String, name: String, size: (width: Double, height: Double), updatedAt: Date, project: Project) {
		self.createdAt = createdAt
		self.fileName = fileName
		self.id = id
		self.name = name
		self.size = size
		self.updatedAt = updatedAt
		self.project = project
	}
}

extension CustomObject {
	convenience init(from lowLevel: LowLevelCustomObject, project: Project) {
		//TODO: handle nil and invalid values better
		let dateFormatter = DateFormatter()
		let createdAt = if let d = lowLevel.createdDate {dateFormatter.date(from: d)} else {Date()}
		let fileName = lowLevel.fileName ?? "HSAPI UNKNOWN FILENAME"
		let id = lowLevel.id ?? "HSAPI UNKNWO NID THIS IS A PROBLEM"
		let name = lowLevel.name ?? "HSAPI Unknown image names"
		let size = (width: lowLevel.size?.width ?? 150, height: lowLevel.size?.height ?? 150)
		let updatedAt = if let d = lowLevel.updatedDate {dateFormatter.date(from: d)} else {Date()}
		self.init(createdAt: createdAt ?? Date(), fileName: fileName, id: id, name: name, size: size, updatedAt: updatedAt ?? Date(), project: project)
	}
}