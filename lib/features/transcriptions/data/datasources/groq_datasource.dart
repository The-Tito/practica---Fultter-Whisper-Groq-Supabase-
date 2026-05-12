import 'package:dio/dio.dart';

abstract class GroqDatasource {
  Future<String> transcribe(String filePath);
  Future<String> generateTitle(String transcript);
  Future<String> developIdea(String transcript);
}

class GroqDatasourceImpl implements GroqDatasource {
  final Dio _dio;
  final String _apiKey;

  GroqDatasourceImpl({required String apiKey}) : _apiKey = apiKey, _dio = Dio();

  // --- Whisper: audio → texto ---
  @override
  Future<String> transcribe(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: 'audio.m4a'),
      'model': 'whisper-large-v3',
    });

    final response = await _dio.post(
      'https://api.groq.com/openai/v1/audio/transcriptions',
      data: formData,
      options: Options(headers: {'Authorization': 'Bearer $_apiKey'}),
    );

    return response.data['text'] as String;
  }

  // --- transcript → título corto ---
  @override
  Future<String> generateTitle(String transcript) async {
    final response = await _dio.post(
      'https://api.groq.com/openai/v1/chat/completions',
      data: {
        'model': 'llama-3.3-70b-versatile',
        'messages': [
          {
            'role': 'system',
            'content':
                'Genera un título corto (máximo 6 palabras) para esta nota de voz. '
                'Responde SOLO con el título, sin comillas ni puntuación extra.',
          },
          {'role': 'user', 'content': transcript},
        ],
        'max_tokens': 50,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      ),
    );

    return (response.data['choices'][0]['message']['content'] as String).trim();
  }

  // --- transcript → idea desarrollada ---
  @override
  Future<String> developIdea(String transcript) async {
    final response = await _dio.post(
      'https://api.groq.com/openai/v1/chat/completions',
      data: {
        'model': 'llama-3.3-70b-versatile',
        'messages': [
          {
            'role': 'system',
            'content': '''Eres un estratega de contenido. 
A partir de una idea de voz en bruto, desarrolla una propuesta estructurada. 
Responde SIEMPRE con este formato exacto, sin agregar secciones extra:

🎯 Idea central
[una oración que resume el núcleo de la idea]

🔑 Puntos clave
- [punto 1]
- [punto 2]
- [punto 3]

🪝 Gancho sugerido
[una frase de apertura que engancha al espectador/lector]''',
          },
          {'role': 'user', 'content': transcript},
        ],
        'max_tokens': 400,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
      ),
    );

    return (response.data['choices'][0]['message']['content'] as String).trim();
  }
}
