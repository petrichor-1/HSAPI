class EventParameter {
	var type: BlockType
	var description: String
	var id: String
	var object: ObjectID?

	weak var project: Project?

	init(type: BlockType, description: String, id: String, object: ObjectID?, project: Project) {
		self.type = type
		self.description = description
		self.id = id
		self.object = object
		self.project = project
	}
}

extension EventParameter {
	convenience init(from lowLevel: LowLevelEventParameter, project: Project) {
		//TODO: Handle nil values better here
		let type = BlockType(doubleValue: lowLevel.blockType ?? 22)
		let description = type.description ?? "HSAPI Unknown description"
		let id = lowLevel.id ?? "HSAPI PROBLEM Unknown id FIXME throw here"
		let object: ObjectID? = if let objectID = lowLevel.objectID {.id(objectID)} else {nil}

		self.init(type: type, description: description, id: id, object: object, project: project)
	}
}