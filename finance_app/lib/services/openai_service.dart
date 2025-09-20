import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_response.dart';

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1';
  static String? _apiKey;
  
  // Initialize with API key
  static void initialize(String apiKey) {
    _apiKey = apiKey;
  }

  // Check if service is properly configured
  static bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  // Send message to OpenAI and get structured response
  static Future<AiResponse> sendMessage({
    required String message,
    String? imageBase64,
    List<Map<String, dynamic>>? conversationHistory,
  }) async {
    if (!isConfigured) {
      throw Exception('OpenAI API key not configured');
    }

    try {
      final response = await _makeApiCall(
        message: message,
        imageBase64: imageBase64,
        conversationHistory: conversationHistory,
      );

      return _parseResponse(response);
    } catch (e) {
      return AiResponse(
        text: 'عذراً، حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى.',
        type: AiResponseType.error,
        metadata: {'error': e.toString()},
      );
    }
  }

  // Make API call to OpenAI
  static Future<Map<String, dynamic>> _makeApiCall({
    required String message,
    String? imageBase64,
    List<Map<String, dynamic>>? conversationHistory,
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    // Build messages array with system prompt for financial assistant
    final messages = [
      {
        'role': 'system',
        'content': _getSystemPrompt(),
      },
      // Add conversation history if provided
      if (conversationHistory != null) ...conversationHistory,
      // Add current message
      _buildUserMessage(message, imageBase64),
    ];

    final body = {
      'model': 'gpt-4o', // or 'gpt-3.5-turbo' for faster/cheaper responses
      'messages': messages,
      'max_tokens': 1000,
      'temperature': 0.7,
      'response_format': {
        'type': 'json_object',
      },
    };

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/completions'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
    }

    return jsonDecode(response.body);
  }

  // Parse OpenAI response and convert to AiResponse
  static AiResponse _parseResponse(Map<String, dynamic> response) {
    try {
      final choices = response['choices'] as List;
      if (choices.isEmpty) {
        throw Exception('No response choices returned');
      }

      final content = choices[0]['message']['content'] as String;
      final parsedContent = jsonDecode(content);

      return AiResponse.fromJson(parsedContent);
    } catch (e) {
      // Fallback to text-only response if JSON parsing fails
      final choices = response['choices'] as List;
      final content = choices.isNotEmpty 
          ? choices[0]['message']['content'] as String
          : 'عذراً، لم أتمكن من فهم طلبك. يرجى المحاولة مرة أخرى.';

      return AiResponse(
        text: content,
        type: AiResponseType.text,
        metadata: {'parse_error': e.toString()},
      );
    }
  }

  // Build user message object (with optional image)
  static Map<String, dynamic> _buildUserMessage(String text, String? imageBase64) {
    if (imageBase64 == null) {
      return {
        'role': 'user',
        'content': text,
      };
    }

    return {
      'role': 'user',
      'content': [
        {
          'type': 'text',
          'text': text,
        },
        {
          'type': 'image_url',
          'image_url': {
            'url': 'data:image/jpeg;base64,$imageBase64',
          },
        },
      ],
    };
  }

  // System prompt for the financial assistant
  static String _getSystemPrompt() {
    return '''
أنت مساعد مالي ذكي لتطبيق "ميزان" المالي الخاص للعرب الساكنين في دولة اسرائيل. مهمتك مساعدة العائلات العربية في إدارة أموالهم.

يجب أن تستجيب دائماً بتنسيق JSON مع الهيكل التالي:
{
  "text": "نص الرد باللغة العربية",
  "commands": [
    {
      "type": "نوع الأمر",
      "action": "اسم الإجراء",
      "parameters": {},
      "label": "تسمية الزر"
    }
  ],
  "type": "نوع الرد",
  "metadata": {}
}

أنواع الأوامر المتاحة:
- navigate: للانتقال إلى صفحة (/dashboard, /budget, /savings, /charity, /profile, /lessons, /ai-chat)
- addExpense: لإضافة مصروف جديد
- createBudget: لإنشاء أو تعديل ميزانية
- showChart: لعرض رسم بياني
- setGoal: لتحديد هدف مالي
- calculate: لإجراء حسابات مالية
- learn: للانتقال إلى درس تعليمي
- analyze: لتحليل البيانات المالية

أنواع الردود المتاحة:
- text: رد نصي عادي
- actionable: رد يحتوي على أوامر قابلة للتنفيذ
- financial: نصائح مالية
- educational: محتوى تعليمي
- error: رسالة خطأ

مبادئ مهمة:
1. اجعل ردودك مناسبة للثقافة العربية والإسلامية في دولة اسرائيل
2. ركز على حلول عملية للعائلات
3. تجنب الاستثمارات المحرمة (الربا، القمار، إلخ)
4. استخدم اللغة العربية الواضحة والبسيطة
5. قدم أوامر عملية كلما أمكن

أمثلة على الردود:

للسؤال "كيف ميزانيتي؟":
{
  "text": "دعني أتحقق من ميزانيتك الحالية وأعرض لك التفاصيل",
  "commands": [
    {
      "type": "navigate",
      "action": "navigate",
      "parameters": {"page": "/budget"},
      "label": "عرض الميزانية"
    }
  ],
  "type": "actionable"
}

للسؤال "أريد توفير ١٠٠٠ ₪":
{
  "text": "هدف ممتاز! يمكنني مساعدتك في وضع خطة ادخار لتحقيق هدفك",
  "commands": [
    {
      "type": "setGoal",
      "action": "set_goal",
      "parameters": {"goal_type": "savings", "amount": 1000},
      "label": "تحديد هدف الادخار"
    },
    {
      "type": "navigate",
      "action": "navigate",
      "parameters": {"page": "/savings"},
      "label": "إدارة المدخرات"
    }
  ],
  "type": "actionable"
}
''';
  }

  // Convert conversation history to OpenAI format
  static List<Map<String, dynamic>> formatConversationHistory(
    List<Map<String, dynamic>> messages,
  ) {
    return messages.map((msg) {
      return {
        'role': msg['isUser'] == true ? 'user' : 'assistant',
        'content': msg['text'] ?? '',
      };
    }).toList();
  }
}
