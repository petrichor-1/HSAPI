//TODO: Make sure everything is in here
class Rule {
	var beforeGameStartsAbility: AbilityID?
	var id: String
	var parameters = [Parameter]()
	var blockType: BlockType

	weak var project: Project?

	init(beforeGameStartsAbility: AbilityID?, id: String, parameters: [Parameter] = [Parameter](), blockType: BlockType, project: Project) {
		self.beforeGameStartsAbility = beforeGameStartsAbility
		self.id = id
		self.parameters = parameters
		self.blockType = blockType
		self.project = project
	}

	func addParameter(_ parameter: Parameter) {
		parameters.append(parameter)
	}
}

extension Rule {
	convenience init(from lowLevelRule: LowLevelRule, project: Project) {
		//TODO: handle nil values better
		let beforeGameStartsAbility: AbilityID? = if let id = lowLevelRule.abilityID {.unknown(id: id)} else {nil}
		let id = lowLevelRule.id ?? Rule.generateID()
		let type = BlockType(doubleValue: lowLevelRule.ruleBlockType ?? 22)
		self.init(beforeGameStartsAbility: beforeGameStartsAbility, id: id, blockType: type, project: project)
		for lowLevelParameter in lowLevelRule.parameters ?? [] {
			addParameter(Parameter(from: lowLevelParameter, project: project))
		}
	}

	static func generateID() -> String {
		fatalError("TODO: Rule.generateID()")
	}
}