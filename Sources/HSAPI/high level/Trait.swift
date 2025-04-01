class Trait {
	var description: String
	var traitID: String
	var object: ObjectID?
	var objectParameterType: BlockType
	var type: BlockType

	weak var project: Project?

	init(description: String, traitID: String, object: ObjectID?, objectParameterType: BlockType, type: BlockType, project: Project) {
		self.description = description
		self.traitID = traitID
		self.object = object
		self.objectParameterType = objectParameterType
		self.type = type
		self.project = project
	}
}

extension Trait {
	convenience init(from lowLevelTrait: LowLevelTrait, project: Project) {
		//TODO: Make optionally fallible if values are missing
		let type = BlockType(doubleValue: lowLevelTrait.type ?? 22)
		let description = lowLevelTrait.description ?? type.description ?? "UNKNOWN HSAPI TODO FAIL HERE"
		let traitID = lowLevelTrait.traitID ?? Trait.generateID()
		let object: ObjectID? = {
			if let id = lowLevelTrait.objectID {
				return ObjectID.id(id)
			} else {
				return nil
			}
		}()
		let objectParameterType = BlockType(doubleValue: lowLevelTrait.objectParameterType ?? 22)
		self.init(description: description, traitID: traitID, object: object, objectParameterType: objectParameterType, type: type, project: project)
	}

	private static func generateID() -> String {
		fatalError("TODO: Trait.generateID")
	}
}