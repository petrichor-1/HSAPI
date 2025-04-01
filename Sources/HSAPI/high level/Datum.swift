enum Datum {
	case block(Block)
	case trait(Trait)
	case variable(VariableReference)
	case setImageDatum(SetImageDatum)
	case sceneReference(SceneReference)
}

extension Datum {
	init(from lowLevelDatum: LowLevelParameterDatum, project: Project) {
		switch lowLevelDatum {
		case let .block(lowLevelBlock):
			self = .block(Block(from: lowLevelBlock, project: project))
		case let .trait(lowLevelTrait):
			self = .trait(Trait(from: lowLevelTrait, project: project))
		case let .nonLocalVariable(lowLevelVariableReference):
			self = .variable(VariableReference(from: lowLevelVariableReference, project: project))
		//TODO: Merge the two variable cases, they shouldn't be different
		case let .localVariable(lowLevelLocalVariable):
			self = .variable(VariableReference(to: Variable(from: lowLevelLocalVariable, project: project)))
		case let .setImage(lowLevelSetImageDatum):
			self = .setImageDatum(SetImageDatum(from: lowLevelSetImageDatum, project: project))
		case let .sceneReference(lowLevelSceneReference):
			self = .sceneReference(SceneReference(from: lowLevelSceneReference, project: project))
		}
	}
}