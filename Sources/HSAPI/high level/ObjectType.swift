enum ObjectType {
	case unknown(Double)
}

extension ObjectType {
	init(doubleValue: Double) {
		self = .unknown(doubleValue)
	}

	var width: Double? {
		get {
			switch self {
			default:
				return nil
			}
		}
	}
	var height: Double? {
		get {
			switch self {
			default:
				return nil
			}
		}
	}
	var filename: String? {
		get {
			switch self {
			default:
				return nil
			}
		}
	}
}