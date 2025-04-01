class CustomRuleInstance {
	var customRule: CustomRuleID
	var id: String
	var parameters = [Parameter]()

	weak var project: Project?

	init(customRule: CustomRuleID, id: String, parameters: [Parameter] = [Parameter](), project: Project) {
		self.customRule = customRule
		self.id = id
		self.parameters = parameters
		self.project = project
	}

	func addParameter(_ parameter: Parameter) {
		parameters.append(parameter)
	}
}

extension CustomRuleInstance {
	convenience init(from lowLevel: LowLevelCustomRuleInstance, project: Project) {
		//TODO: Handle nil values better here
		let customRule = CustomRuleID.unknown(id: lowLevel.customRuleId ?? "HSAPI PROBLEM: UNKNOWN ID")
		let id = lowLevel.id ?? "UNKNOWN ID HSAPI ISSUE"
		self.init(customRule: customRule, id: id, project: project)
		for lowLevelParameter in lowLevel.parameters ?? [] {
			addParameter(Parameter(from: lowLevelParameter, project: project))
		}
	}
}