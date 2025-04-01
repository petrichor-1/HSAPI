class CustomRule {
	var id: String
	var beforeGameStartsAbility: AbilityID? = nil
	var name: String
	var parameters = [Parameter]()
	var rules = [RuleReference]()

	weak var project: Project?

	init(id: String, beforeGameStartsAbility: AbilityID? = nil, name: String, parameters: [Parameter] = [Parameter](), rules: [RuleReference] = [RuleReference](), project: Project) {
		self.id = id
		self.beforeGameStartsAbility = beforeGameStartsAbility
		self.name = name
		self.parameters = parameters
		self.rules = rules
		self.project = project
	}

	func addParameter(_ parameter: Parameter) {
		parameters.append(parameter)
	}
	func addRule(_ rule: RuleReference) {
		rules.append(rule)
	}
}

extension CustomRule {
	convenience init(from lowLevel: LowLevelCustomRule, project: Project) {
		//TODO: Handle nil values better here
		let id = lowLevel.id ?? "HSAPI UNKNSONWN ID REMOVE THIS ERRORERRORERROR"
		let beforeGameStartsAbility: AbilityID? = if let abilityID = lowLevel.abilityID {.unknown(id: abilityID)} else {nil}
		let name = lowLevel.name ?? "HSAPI No name"
		self.init(id: id, beforeGameStartsAbility: beforeGameStartsAbility, name: name, project: project)
		for parameter in lowLevel.parameters ?? [] {
			addParameter(Parameter(from: parameter, project: project))
		}
		for ruleID in lowLevel.rules ?? [] {
			addRule(.unknown(id: ruleID))
		}
	}
}