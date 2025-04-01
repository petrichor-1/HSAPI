import Foundation

class Project {
	///UNUSED IN MODERN PLAYERS – Scales character SVGs by a factor of its value. Does not scale shapes or text.
	/// In any versioned webplayer, it is ignored and a value of `0.5` is assumed for *shapes* accesible from editor, and `1` for all other characters
	var baseObjectScale: Double = 1
	///Scales the text size.
	/// Default for standard iPads is `80`, iPhones are `72`
	var fontSize: Double = 80
	var playerUpgrades: [LowLevelPlayerUpgrade]? = nil
	var playerVersion: String = "3.0.0"
	var requiresBetaEditor: Bool = false
	var stageSize: StageSize = StageSize(width: 1024, height: 1024)
	///A representation of the app version that created this project
	/// If it is greater than the version of the iOS app the user is using, it will show an error screen and the message
	/// Someone made this with a newer version of Hopscotch. Update now to see the new awesomeness!
	/// If it is <= 24, the iOS app will use the native player for it.
	var version: Double = 34
	var abilities = [Ability]()
	var customObjects = [CustomObject]()
	var customRuleInstances = [CustomRuleInstance]()
	var customRules = [CustomRule]()
	var eventParameters = [EventParameter]()
	var rules = [Rule]()
	var scenes = [Scene]()
	var sceneReferences = [SceneReference]()
	// TODO: Traits? – discuss this
	var variables = [Variable]()
	var objects = [Object]()
	/// Init a new project decoding json data
	/// - Parameter jsonData: the data to decode
	convenience init(decoding jsonData: Data) throws {
		let decoder = JSONDecoder()
		self.init(from: try decoder.decode(LowLevelProject.self, from: jsonData))
	}

	/// Init a new project decoding a low level project
	/// - Parameter lowLevelProject: The project to decode
	init(from lowLevelProject: LowLevelProject) {
		// Initial parse – all references (i.e. `AbilityID`s will be unresolved)
		//TODO: Optionally throw in the event of missing variables
		for lowLevelVariable in lowLevelProject.variables ?? [] {
			variables.append(Variable(from: lowLevelVariable, project: self))
		}
		for lowLevelAbility in lowLevelProject.abilities ?? [] {
			abilities.append(Ability(from: lowLevelAbility, project: self))
		}
		for lowLevelRule in lowLevelProject.rules ?? [] {
			rules.append(Rule(from: lowLevelRule, project: self))
		}
		for lowLevelCustomRule in lowLevelProject.customRules ?? [] {
			customRules.append(CustomRule(from: lowLevelCustomRule, project: self))
		}
		for lowLevelCustomObject in lowLevelProject.customObjects ?? [] {
			customObjects.append(CustomObject(from: lowLevelCustomObject, project: self))
		}
		for lowLevelCustomRuleInstance in lowLevelProject.customRuleInstances ?? [] {
			customRuleInstances.append(CustomRuleInstance(from: lowLevelCustomRuleInstance, project: self))
		}
		for lowLevelEventParameter in lowLevelProject.eventParameters ?? [] {
			eventParameters.append(EventParameter(from: lowLevelEventParameter, project: self))
		}
		for lowLevelScene in lowLevelProject.scenes ?? [] {
			scenes.append(Scene(from: lowLevelScene, project: self))
		}
		for lowLevelSceneReference in lowLevelProject.sceneReferences ?? [] {
			sceneReferences.append(SceneReference(from: lowLevelSceneReference, project: self))
		}
		for lowLevelObject in lowLevelProject.objects ?? [] {
			objects.append(Object(from: lowLevelObject, project: self))
		}
	}
}