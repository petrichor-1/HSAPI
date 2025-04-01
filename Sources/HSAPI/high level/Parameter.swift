class Parameter {
	var defaultValue: String
	var value: String
	var key: String
	var type: ParameterType = .unknown(42)
	var datum: Datum? = nil

	weak var project: Project?

	init(defaultValue: String, value: String, key: String, type: ParameterType = .unknown(42), datum: Datum? = nil, project: Project) {
		self.defaultValue = defaultValue
		self.value = value
		self.key = key
		self.type = type
		self.datum = datum
		self.project = project
	}

	convenience init(defaultValue: String, key: String, type: ParameterType = .unknown(42), datum: Datum? = nil, project: Project) {
		self.init(defaultValue: defaultValue, value: defaultValue, key: key, type: type, datum: datum, project: project)
	}
}

extension Parameter {
	convenience init(from lowLevelParameter: LowLevelParameter, project: Project) {
		//TODO: Handle nil better
		let defaultValue = lowLevelParameter.defaultValue ?? ""
		let value = lowLevelParameter.value ?? ""
		let key = lowLevelParameter.key ?? ""
		let type = ParameterType(doubleValue: lowLevelParameter.type ?? 42)
		let datum: Datum? = if let llDatum = lowLevelParameter.datum {Datum(from: llDatum, project: project)} else {nil}

		self.init(defaultValue: defaultValue, value: value, key: key, type: type, datum: datum, project: project)
	}
}