class Broker {
	static Map<String, String> getCountries() {
		return {
			'us': 'United States of America',
			'ca': 'Canada',
			'at': 'Austria',
			'be': 'Belgium',
			'bg': 'Bulgaria',
			'hr': 'Croatia',
			'cy': 'Cyprus',
			'cz': 'Czechia',
			'dk': 'Denmark',
			'ee': 'Estonia',
			'fi': 'Finland',
			'fr': 'France',
			'de': 'Germany',
			'gr': 'Greece',
			'hu': 'Hungary',
			'ie': 'Ireland',
			'it': 'Italy',
			'lv': 'Latvia',
			'lt': 'Lithuania',
			'lu': 'Luxembourg',
			'mt': 'Malta',
			'nl': 'Netherlands',
			'pl': 'Poland',
			'pt': 'Portugal',
			'ro': 'Romania',
			'sk': 'Slovakia',
			'si': 'Slovenia',
			'es': 'Spain',
			'se': 'Sweden',
			'gb': 'United Kingdom'
		};
	}

	static List<String> getCabinClasses() {
		return ['economy', 'premium'];
	}

	static List<String> getTransportMethods() {
		return ['ship', 'train', 'truck', 'plane'];
	}

	static List<String> getElectricityUnit() {
		return ['mwh', 'kwh'];
	}

	static List<String> getDistanceUnits() {
		return ['mi', 'km'];
	}

	static List<String> getWeightUnits() {
		return ['g', 'lb', 'kg', 'mt'];
	}
}