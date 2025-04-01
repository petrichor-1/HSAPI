class Block {
	var blockClass: BlockClass
	var description: String
	var keyboardName: String?
	var type: BlockType
	var parameters = [Parameter]()
	var controlScriptAbility: AbilityID?
	var controlFalseScriptAbility: AbilityID?

	weak var project: Project?

	init(blockClass: BlockClass, description: String, keyboardName: String? = nil, type: BlockType, parameters: [Parameter] = [Parameter](), controlScriptAbility: AbilityID? = nil, controlFalseScriptAbility: AbilityID? = nil, project: Project) {
		self.blockClass = blockClass
		self.description = description
		self.keyboardName = keyboardName
		self.type = type
		self.controlScriptAbility = controlScriptAbility
		self.controlFalseScriptAbility = controlFalseScriptAbility
		self.project = project
	}

	func addParameter(_ parameter: Parameter) {
		parameters.append(parameter)
	}
}

extension Block {
	convenience init(from lowLevel: LowLevelBlock, project: Project) {
		// TODO: Configurably throw an error if one of these values is missing
		let blockClass = BlockClass(stringValue: lowLevel.blockClass ?? "method")
		let type = BlockType(doubleValue: lowLevel.type ?? 22)
		let description = type.description ?? "HSAPI UNKNOWN"
		let keyboardName = lowLevel.keyboardName
		var controlScriptAbility: AbilityID? = nil
		var controlFalseScriptAbility: AbilityID? = nil
		if let abilityID = lowLevel.controlScript?.abilityID {
			controlScriptAbility = .unknown(id: abilityID)
		}
		if let abilityID = lowLevel.controlFalseScript?.abilityID {
			controlFalseScriptAbility = .unknown(id: abilityID)
		}
		self.init(blockClass: blockClass, description: description, keyboardName: keyboardName, type: type, controlScriptAbility: controlScriptAbility, controlFalseScriptAbility: controlFalseScriptAbility, project: project)

		guard let parameters = lowLevel.parameters else {
			return
		}
		for lowLevelParameter in parameters {
			addParameter(Parameter(from: lowLevelParameter, project: project))
		}
	}
}