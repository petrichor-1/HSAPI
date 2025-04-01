class SetImageDatum {
	var customObject: CustomObjectID? = nil
	var text: String?
	var type: ObjectType
	var name: String
	var description: String

	weak var project: Project?

	init(customObject: CustomObjectID? = nil, text: String? = nil, type: ObjectType, name: String, description: String, project: Project) {
		self.customObject = customObject
		self.text = text
		self.type = type
		self.name = name
		self.description = description
		self.project = project
	}
}

extension SetImageDatum {
	convenience init(from lowLevelSetImageDatum: LowLevelSetImageDatum, project: Project) {
		//TODO: Handle nil values properly
		let customObject: CustomObjectID? = if let id = lowLevelSetImageDatum.customObject {.unknown(id: id)} else {nil}
		let text = lowLevelSetImageDatum.text
		let type = ObjectType(doubleValue: lowLevelSetImageDatum.type ?? 0)
		let name = lowLevelSetImageDatum.name ?? ""
		let description = lowLevelSetImageDatum.description ?? ""

		self.init(customObject: customObject, text: text, type: type, name: name, description: description, project: project)
	}
}