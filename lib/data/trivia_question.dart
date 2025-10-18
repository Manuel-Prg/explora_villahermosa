class TriviaQuestions {
  static final List<Map<String, dynamic>> questions = [
    {
      'question': '¿En qué año fue fundada Villahermosa?',
      'options': ['1564', '1596', '1598', '1619'],
      'correct': '1564',
      'category': 'Historia',
    },
    {
      'question': '¿Cuál es el nombre del río principal de Villahermosa?',
      'options': ['Grijalva', 'Usumacinta', 'Carrizal', 'Puxcatán'],
      'correct': 'Grijalva',
      'category': 'Geografía',
    },
    {
      'question': '¿Qué cultura prehispánica habitó la región de Tabasco?',
      'options': ['Maya', 'Olmeca', 'Azteca', 'Zapoteca'],
      'correct': 'Olmeca',
      'category': 'Historia',
    },
    {
      'question': '¿Cuál es el nombre antiguo de Villahermosa?',
      'options': [
        'San Juan Bautista',
        'San Pedro',
        'Santa María',
        'San Miguel'
      ],
      'correct': 'San Juan Bautista',
      'category': 'Historia',
    },
    {
      'question': '¿En qué estado de México se encuentra Villahermosa?',
      'options': ['Chiapas', 'Tabasco', 'Veracruz', 'Campeche'],
      'correct': 'Tabasco',
      'category': 'Geografía',
    },
    {
      'question': '¿Qué parque arqueológico importante está en Villahermosa?',
      'options': ['La Venta', 'Palenque', 'Chichén Itzá', 'Uxmal'],
      'correct': 'La Venta',
      'category': 'Cultura',
    },
    {
      'question': '¿Cuál es el platillo típico más famoso de Tabasco?',
      'options': ['Pejelagarto asado', 'Pozole', 'Mole', 'Cochinita pibil'],
      'correct': 'Pejelagarto asado',
      'category': 'Gastronomía',
    },
    {
      'question':
          '¿Qué poeta tabasqueño es conocido como "El Poeta de América"?',
      'options': [
        'Carlos Pellicer',
        'José Gorostiza',
        'Octavio Paz',
        'Jaime Sabines'
      ],
      'correct': 'Carlos Pellicer',
      'category': 'Cultura',
    },
    {
      'question': '¿Cuál es el museo más importante de Villahermosa?',
      'options': [
        'Museo La Venta',
        'Museo de Historia Natural',
        'Museo del Chocolate',
        'Museo Regional de Antropología'
      ],
      'correct': 'Museo Regional de Antropología',
      'category': 'Cultura',
    },
    {
      'question': '¿Qué producto es característico de la economía tabasqueña?',
      'options': ['Cacao', 'Café', 'Henequén', 'Caña de azúcar'],
      'correct': 'Cacao',
      'category': 'Economía',
    },
    {
      'question':
          '¿Cuántas cabezas olmecas se encuentran en el Parque La Venta?',
      'options': ['3', '5', '7', '10'],
      'correct': '3',
      'category': 'Cultura',
    },
    {
      'question':
          '¿Qué evento histórico importante ocurrió en Tabasco en 1863?',
      'options': [
        'Batalla de Jahuactal',
        'Fundación de Villahermosa',
        'Independencia de México',
        'Revolución Mexicana'
      ],
      'correct': 'Batalla de Jahuactal',
      'category': 'Historia',
    },
    {
      'question': '¿Cuál es el apodo de Villahermosa?',
      'options': [
        'La Esmeralda del Sureste',
        'La Perla del Golfo',
        'Ciudad de los Ríos',
        'La Capital del Cacao'
      ],
      'correct': 'La Esmeralda del Sureste',
      'category': 'Cultura',
    },
    {
      'question': '¿Qué zona arqueológica olmeca está cerca de Villahermosa?',
      'options': ['Comalcalco', 'Monte Albán', 'Teotihuacán', 'Tulum'],
      'correct': 'Comalcalco',
      'category': 'Historia',
    },
    {
      'question': '¿Cuál es la bebida tradicional de Tabasco hecha con cacao?',
      'options': ['Pozol', 'Atole', 'Tejate', 'Champurrado'],
      'correct': 'Pozol',
      'category': 'Gastronomía',
    },
    {
      'question':
          '¿En qué año cambió su nombre de San Juan Bautista a Villahermosa?',
      'options': ['1826', '1915', '1598', '1810'],
      'correct': '1826',
      'category': 'Historia',
    },
    {
      'question': '¿Cuál de estos personajes fue gobernador de Tabasco?',
      'options': [
        'Tomás Garrido Canabal',
        'Andrés Manuel López Obrador',
        'Carlos Pellicer',
        'José María Pino Suárez'
      ],
      'correct': 'Tomás Garrido Canabal',
      'category': 'Historia',
    },
    {
      'question':
          '¿Cuál es el edificio más emblemático del centro de Villahermosa?',
      'options': [
        'Palacio Municipal',
        'Torre Pemex',
        'Catedral del Señor',
        'Plaza de Armas'
      ],
      'correct': 'Palacio Municipal',
      'category': 'Arquitectura',
    },
    {
      'question':
          '¿Qué festival cultural importante se celebra en Villahermosa?',
      'options': [
        'Festival del Chocolate',
        'Guelaguetza',
        'Festival Cervantino',
        'Día de Muertos'
      ],
      'correct': 'Festival del Chocolate',
      'category': 'Cultura',
    },
    {
      'question':
          '¿Cuál es el paseo más famoso a orillas del río en Villahermosa?',
      'options': [
        'Malecón Leandro Rovirosa Wade',
        'Paseo Tabasco',
        'Zona Luz',
        'Laguna de las Ilusiones'
      ],
      'correct': 'Malecón Leandro Rovirosa Wade',
      'category': 'Turismo',
    },
  ];

  // Método para obtener preguntas aleatorias
  static List<Map<String, dynamic>> getRandomQuestions(int count) {
    final shuffled = List<Map<String, dynamic>>.from(questions);
    shuffled.shuffle();
    return shuffled.take(count).toList();
  }

  // Método para obtener preguntas por categoría
  static List<Map<String, dynamic>> getQuestionsByCategory(String category) {
    return questions.where((q) => q['category'] == category).toList();
  }

  // Método para obtener todas las categorías
  static List<String> getCategories() {
    return questions.map((q) => q['category'] as String).toSet().toList();
  }
}
