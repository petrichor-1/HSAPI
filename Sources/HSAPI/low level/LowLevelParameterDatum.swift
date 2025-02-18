enum LowLevelParameterDatum {
	// TODO: Confirm that this is all reasonable types
	case block(LowLevelBlock)
	case trait(LowLevelTrait)
	case localVariable(LowLevelVariable)
	/// Character for set image. Will ALWAYS be read for set image parameter types, matching webplayer functionality
	case setImage(LowLevelSetImageDatum)
	case sceneReference(LowLevelSceneReference)
	case nonLocalVariable(id: String)
}

extension LowLevelParameterDatum: Decodable {
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
}