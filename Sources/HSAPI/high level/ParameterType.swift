enum ParameterType {
	case unknown(Double)
}

extension ParameterType {
	init(doubleValue: Double) {
		self = .unknown(doubleValue)
	}

	///The expected `description` for this type, or `nil` if one is not known
	var description: String? {
		get {
			switch self {
			case .unknown:
				return nil
			}
		}
	}
}