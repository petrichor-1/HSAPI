class Object {
	var width: Double
	var height: Double
	var name: String
	var resizeScale: Double? = 1
	var filename: String
	var beforeGameStartsAbility: AbilityID? = nil
	var rules = [RuleReference]()
	var xPosition: Double
	var yPosition: Double
	var id: String
	var type: ObjectType
	var text: String? = nil
	var customImage: CustomObjectID? = nil
	var rotation: Double? = 0

	weak var project: Project?

	init(width: Double, height: Double, name: String, resizeScale: Double? = 1, filename: String, beforeGameStartsAbility: AbilityID? = nil, xPosition: Double, yPosition: Double, id: String, type: ObjectType, text: String? = nil, customImage: CustomObjectID? = nil, rotation: Double? = 0, project: Project) {
		self.width = width
		self.height = height
		self.name = name
		self.resizeScale = resizeScale
		self.filename = filename
		self.beforeGameStartsAbility = beforeGameStartsAbility
		self.xPosition = xPosition
		self.yPosition = yPosition
		self.id = id
		self.type = type
		self.text = text
		self.customImage = customImage
		self.rotation = rotation
		self.project = project
	}

	func addRule(_ id: RuleReference) {
		rules.append(id)
	}
}

extension Object {
	convenience init(from lowLevel: LowLevelObject, project: Project) {
		let type = ObjectType(doubleValue: lowLevel.type ?? 0)
		let width = if let w = lowLevel.width {Double(w) ?? type.width ?? 150} else {type.width ?? 150}
		let height = if let h = lowLevel.height {Double(h) ?? type.height ?? 150} else {type.height ?? 150}
		let name = lowLevel.name ?? "HSAPI Unknown object name"
		let resizeScale: Double? = if let r = lowLevel.resizeScale {Double(r)} else {nil}
		let filename = lowLevel.filename ?? type.filename ?? "HSAPI UNKNOWN FILENAME"
		let beforeGameStartsAbility: AbilityID? = if let abilityID = lowLevel.abilityID {.unknown(id: abilityID)} else {nil}
		let xPosition = Double(lowLevel.xPosition ?? "0") ?? 0
		let yPosition = Double(lowLevel.yPosition ?? "0") ?? 0
		let id = lowLevel.objectID ?? "HSAPI Unknown id"
		let text = lowLevel.text
		let customImage: CustomObjectID? = if let id = lowLevel.customObjectID {.unknown(id: id)} else {nil}
		let rotation = Double(lowLevel.rotation ?? "0") ?? 0
		self.init(width: width, height: height, name: name, resizeScale: resizeScale, filename: filename, beforeGameStartsAbility: beforeGameStartsAbility, xPosition: xPosition, yPosition: yPosition, id: id, type: type, text: text, customImage: customImage, rotation: rotation, project: project)
		for ruleID in lowLevel.rules ?? [] {
			addRule(.unknown(id: ruleID))
		}
	}
}