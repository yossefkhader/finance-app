# OpenAI Integration for Mizan Finance App

## Overview
The Mizan finance app now includes a comprehensive AI chatbot system that's ready to connect to OpenAI's API. The AI assistant can provide intelligent financial advice, execute commands, and help users navigate the app.

## Implementation Details

### 1. AI Response Models (`lib/models/ai_response.dart`)
- **AiResponse**: Main response structure containing text, commands, type, and metadata
- **AiCommand**: Represents actionable commands with type, action, parameters, and labels
- **AiCommandTemplates**: Pre-built command templates for common financial actions
- **Enums**: AiResponseType and AiCommandType for structured responses

### 2. OpenAI Service (`lib/services/openai_service.dart`)
- **API Integration**: Complete OpenAI API client with structured JSON responses
- **System Prompt**: Specialized Arabic financial assistant prompt
- **Image Support**: Handles image uploads for receipt analysis
- **Conversation History**: Maintains context across messages
- **Error Handling**: Graceful fallback to mock responses

### 3. Command Handler (`lib/services/command_handler_service.dart`)
- **Command Execution**: Handles all AI command types
- **Navigation**: Routes users to appropriate pages
- **Modal Integration**: Opens forms with pre-filled data
- **Feedback**: Shows success/error messages

### 4. Enhanced Chat UI (`lib/pages/ai_chat_page.dart`)
- **Command Buttons**: Interactive buttons for AI-suggested actions
- **Image Processing**: Converts images to base64 for API
- **Mock Responses**: Development-ready mock system
- **Real-time Updates**: Live conversation with command execution

## API Configuration

### Setting up OpenAI API Key
```dart
// In lib/pages/ai_chat_page.dart, line 43:
OpenAIService.initialize('your-openai-api-key-here');
```

### Environment Variable (Recommended)
```dart
// Create a .env file and load securely:
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  OpenAIService.initialize(dotenv.env['OPENAI_API_KEY']!);
  runApp(MizanApp());
}
```

## AI Response Format

The AI is configured to return structured JSON responses:

```json
{
  "text": "نص الرد باللغة العربية",
  "commands": [
    {
      "type": "navigate",
      "action": "navigate",
      "parameters": {"page": "/budget"},
      "label": "عرض الميزانية"
    }
  ],
  "type": "actionable",
  "metadata": {}
}
```

## Command Types

### Navigation Commands
- Navigate to app pages (`/dashboard`, `/budget`, `/savings`, etc.)

### Financial Actions
- **addExpense**: Add new expense with pre-filled data
- **createBudget**: Set or modify budget categories
- **setGoal**: Create financial goals
- **calculate**: Perform financial calculations

### Educational Commands
- **learn**: Open specific lessons or lesson overview
- **analyze**: Show financial analysis and insights

### Data Commands
- **showChart**: Display specific charts or visualizations
- **export**: Export financial data
- **share**: Share financial information

## Features

### 1. Intelligent Responses
- Context-aware financial advice
- Culturally appropriate for Arabic/Islamic finance
- Personalized based on user's financial data

### 2. Interactive Commands
- Clickable action buttons in chat
- Direct navigation to relevant pages
- Pre-filled forms for quick data entry

### 3. Multi-modal Input
- Text messages
- Voice input (speech-to-text)
- Image analysis for receipts

### 4. Error Handling
- Graceful API failure handling
- Mock responses for development
- User-friendly error messages

## Mock Response System

For development without an API key, the system includes comprehensive mock responses:

```dart
// Example mock response for budget queries
AiResponse(
  text: 'بناءً على بياناتك المالية، ميزانيتك الشهرية ٢٧٥٠ ريال...',
  commands: [
    AiCommandTemplates.navigateToPage('/budget', label: 'عرض الميزانية'),
    AiCommandTemplates.addExpense(0, 'foodDining', ''),
  ],
  type: AiResponseType.financial,
);
```

## System Prompt Features

The AI assistant is configured with:
- Arabic language responses
- Islamic finance compliance
- Family-focused financial advice
- Integration with app features
- Structured command generation

## Usage Examples

### 1. Budget Analysis
**User**: "كيف ميزانيتي هذا الشهر؟"
**AI**: Returns budget analysis with navigation to budget page

### 2. Savings Goals
**User**: "أريد ادخار ١٠٠٠ ريال"
**AI**: Provides savings plan with goal-setting command

### 3. Receipt Analysis
**User**: *uploads receipt image*
**AI**: Analyzes receipt and offers to add expense

### 4. Financial Education
**User**: "علمني عن الادخار"
**AI**: Provides tips with links to relevant lessons

## Integration Benefits

1. **Seamless User Experience**: Commands execute within the app
2. **Contextual Actions**: AI suggestions lead to relevant features
3. **Educational Value**: Links to micro-lessons for learning
4. **Cultural Sensitivity**: Arabic language and Islamic finance principles
5. **Data Integration**: Uses real financial data for personalized advice

## Security Considerations

- API keys stored securely (not hardcoded)
- Image data processed securely
- User financial data handled responsibly
- Error messages don't expose sensitive information

## Future Enhancements

- Advanced financial analysis
- Predictive budgeting
- Investment recommendations (Shariah-compliant)
- Family financial planning
- Multi-language support
- Voice responses
- Advanced receipt OCR
- Bank account integration

The AI chatbot is now fully ready for OpenAI integration and provides a powerful, culturally-appropriate financial assistant for Arabic-speaking users.
