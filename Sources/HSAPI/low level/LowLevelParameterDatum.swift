enum LowLevelParameterDatum {
	// TODO: Confirm that this is all reasonable types
	case block(LowLevelBlock)
	case trait(LowLevelTrait)
	case localVariable(LowLevelVariable)
	/// Character for set image. Will ALWAYS be read for set image parameter types, matching webplayer functionality
	case setImage(LowLevelSetImageDatum)
	case sceneReference(LowLevelSceneReference)
	// TODO: Add extraData to this!
	case nonLocalVariable(id: String)
}

extension LowLevelParameterDatum: Codable {
	init(from decoder: Decoder) throws {
		// TODO: Is this order correct?
		if let container = try? decoder.container(keyedBy: ArbitraryStringCodingKeys.self) {
			if let variableId = try? container.decode(String.self, forKey: ArbitraryStringCodingKeys(stringValue: "variable")) {
				// FIXME: This should have `extraData`!!!!
				self = .nonLocalVariable(id: variableId)
				return
			}
			// TODO: Use known block types
			if let type = try? container.decode(Double.self, forKey: ArbitraryStringCodingKeys(stringValue: "type")) {
				if type == 8009 { //HSBlockType.Scoped
					self = .localVariable(try LowLevelVariable(from: decoder))
					return
				}
			}
		}
		let block = try LowLevelBlock(from: decoder)
		let trait = try LowLevelTrait(from: decoder)
		let sceneReference = try LowLevelSceneReference(from: decoder)
		let minEDCount = min(block.extraData.count, trait.extraData.count, sceneReference.extraData.count)
		if block.extraData.count == minEDCount {
			self = .block(block)
		} else if sceneReference.extraData.count == minEDCount {
			self = .sceneReference(sceneReference)
		} else {
			self = .trait(trait)
		}
	}

	func encode(to encoder: Encoder) throws {
		switch self {
		case let .block(block):
			try block.encode(to: encoder)
		case let .trait(trait):
			try trait.encode(to: encoder)
		case let .localVariable(localVariable):
			try localVariable.encode(to: encoder)
		case let .setImage(datum):
			try datum.encode(to: encoder)
		case let .sceneReference(sceneReference):
			try sceneReference.encode(to: encoder)
		case let .nonLocalVariable(id: id):
			var container = encoder.container(keyedBy: ArbitraryStringCodingKeys.self)
			try container.encode(id, forKey: ArbitraryStringCodingKeys(stringValue: "variable"))
		}
	}
}