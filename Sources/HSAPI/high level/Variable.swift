class Variable {
	var name: String
	var id: String
	var type: BlockType

	weak var project: Project?

	init(name: String, id: String, type: BlockType, project: Project) {
		self.name = name
		self.id = id
		self.type = type
		self.project = project
	}
}

extension Variable {
	convenience init(from lowLevelVariable: LowLevelVariable, project: Project) {
		//TODO: Optionally throw for missing values
		self.init(name: lowLevelVariable.name ?? "HSAPI UNKNOWN – TODO: Handle this better",
			id: lowLevelVariable.id ?? Variable.generateID(),
			type: .init(doubleValue: lowLevelVariable.type ?? 8000),
			project: project)
	}

	static func generateID() -> String {
		return "TODO"
	}
}