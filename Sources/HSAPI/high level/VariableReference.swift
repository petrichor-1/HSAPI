class VariableReference {
	var targetID: VariableID
	var type: BlockType
	var description: String
	var ownerObjectID: ObjectID?

	weak var project: Project?

	enum VariableID {
		case known(Variable)
		case unknown(id: String)
	}

	init(targetID: VariableID, type: BlockType, description: String, ownerObjectID: ObjectID? = nil, project: Project) {
		self.targetID = targetID
		self.type = type
		self.description = description
		self.ownerObjectID = ownerObjectID
		self.project = project
	}
}

extension VariableReference {
	convenience init(from lowLevelVariableReference: LowLevelVariableReference, project: Project) {
		// TODO: Handle nil values properly
		let targetID = VariableID.unknown(id: lowLevelVariableReference.variable ?? "HSAPI UNKNOWN ID")
		let type = BlockType(doubleValue: lowLevelVariableReference.type ?? 22)
		let description = lowLevelVariableReference.description ?? type.description ?? "HSAPI UNKNOWN DESCRIPTION"
		let ownerObjectID: ObjectID? = if let object = lowLevelVariableReference.object {ObjectID.id(object)} else {nil}

		self.init(targetID: targetID, type: type, description: description, ownerObjectID: ownerObjectID, project: project)
	}

	convenience init(to variable: Variable) {
		let targetID = VariableID.known(variable)
		let type = variable.type
		let description = type.description ?? "HSAPI UNKNOWN"
		self.init(targetID: targetID, type: type, description: description, project: variable.project!) // TODO: Is crashing here reasonable?
	}
}