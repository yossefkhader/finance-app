import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/ai_response.dart';
import '../services/openai_service.dart';
import '../services/command_handler_service.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  final SpeechToText _speechToText = SpeechToText();
  final ImagePicker _imagePicker = ImagePicker();
  
  bool _isListening = false;
  bool _isTyping = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initOpenAI();
    _addWelcomeMessage();
  }

  void _initOpenAI() {
    // TODO: Initialize OpenAI with your API key
    // You should store this securely, not hardcode it!
    // For development, you can set it here or load from environment
    OpenAIService.initialize('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');
    
    // For now, we'll continue with mock responses until API key is provided
    if (!OpenAIService.isConfigured) {
      print('OpenAI API key not configured. Using mock responses.');
    }
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: 'مرحباً! أنا مساعدك المالي الذكي. كيف يمكنني مساعدتك اليوم؟\n\nيمكنك:\n• طرح أسئلة حول ميزانيتك\n• تحليل مصروفاتك\n• الحصول على نصائح مالية\n• إرسال صور للفواتير',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Chat Header
          // _buildChatHeader(l10n),
          
          // Messages List
          Expanded(
            child: _buildMessagesList(),
          ),
          
          // Input Area
          _buildInputArea(l10n),
        ],
      ),
    );
  }

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.accentColor, AppTheme.accentSecondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: HeroIcon(
                  HeroIcons.sparkles,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: AppTheme.spacingSm),
          ],
          
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? AppTheme.accentColor 
                    : AppTheme.cardColor,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
                boxShadow: message.isUser ? [] : AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.image != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                      child: Image.file(
                        message.image!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingSm),
                  ],
                  
                  Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: message.isUser ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  
                  // Show command buttons for AI responses
                  if (!message.isUser && message.aiResponse != null && message.aiResponse!.commands.isNotEmpty) ...[
                    const SizedBox(height: AppTheme.spacingMd),
                    _buildCommandButtons(message.aiResponse!.commands),
                  ],
                  
                  const SizedBox(height: AppTheme.spacingXs),
                  
                  Text(
                    _formatTime(message.timestamp),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: message.isUser 
                          ? Colors.white.withOpacity(0.7)
                          : AppTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (message.isUser) ...[
            const SizedBox(width: AppTheme.spacingSm),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: HeroIcon(
                  HeroIcons.user,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Image Picker Button
            IconButton(
              onPressed: _pickImage,
              icon: const HeroIcon(HeroIcons.photo),
              color: AppTheme.textSecondary,
              tooltip: 'إرفاق صورة',
            ),
            
            // Voice Input Button
            IconButton(
              onPressed: _speechEnabled ? _toggleListening : null,
              icon: HeroIcon(
                _isListening ? HeroIcons.xMark : HeroIcons.microphone,
                style: _isListening ? HeroIconStyle.solid : HeroIconStyle.outline,
              ),
              color: _isListening ? AppTheme.accentColor : AppTheme.textSecondary,
              tooltip: _isListening ? 'إيقاف التسجيل' : 'تسجيل صوتي',
            ),
            
            // Text Input
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك هنا...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingSm,
                  ),
                ),
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            
            const SizedBox(width: AppTheme.spacingSm),
            
            // Send Button
            Container(
              decoration: BoxDecoration(
                color: AppTheme.accentColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                onPressed: _sendMessage,
                icon: const HeroIcon(
                  HeroIcons.paperAirplane,
                  style: HeroIconStyle.solid,
                ),
                color: Colors.white,
                tooltip: 'إرسال',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
      _isTyping = true;
    });

    _scrollToBottom();
    _generateAIResponse(text);
  }

  void _sendImageMessage(File image) {
    setState(() {
      _messages.add(ChatMessage(
        text: 'تم إرفاق صورة',
        isUser: true,
        timestamp: DateTime.now(),
        image: image,
      ));
      _isTyping = true;
    });

    _scrollToBottom();
    _generateAIResponse('تحليل الصورة المرفقة', image: image);
  }

  void _generateAIResponse(String userMessage, {File? image}) async {
    try {
      String? imageBase64;
      if (image != null) {
        final bytes = await image.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

      AiResponse aiResponse;
      
      if (OpenAIService.isConfigured) {
        // Use real OpenAI API
        final conversationHistory = _messages
            .map((msg) => msg.toOpenAIFormat())
            .toList();
            
        aiResponse = await OpenAIService.sendMessage(
          message: userMessage,
          imageBase64: imageBase64,
          conversationHistory: OpenAIService.formatConversationHistory(conversationHistory),
        );
      } else {
        // Use mock response for development
        aiResponse = _getMockAIResponse(userMessage, hasImage: image != null);
      }

      if (!mounted) return;
      
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: aiResponse.text,
          isUser: false,
          timestamp: DateTime.now(),
          aiResponse: aiResponse,
        ));
      });
      
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: 'عذراً، حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى.',
          isUser: false,
          timestamp: DateTime.now(),
          aiResponse: AiResponse(
            text: 'عذراً، حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى.',
            type: AiResponseType.error,
          ),
        ));
      });
      
      _scrollToBottom();
    }
  }

  AiResponse _getMockAIResponse(String userMessage, {bool hasImage = false}) {    
    return AiResponse(
      text: 'مرحباً! أنا مساعدك المالي الذكي. يمكنني مساعدتك في:\n\n💰 إدارة الميزانية\n📊 تتبع المصروفات\n🎯 وضع أهداف الادخار\n📈 تحليل عاداتك المالية\n📚 تعلم الأساسيات المالية\n\nما الذي تريد أن نبدأ به؟',
      commands: [
        AiCommandTemplates.navigateToPage('/dashboard', label: 'عرض لوحة التحكم'),
        AiCommandTemplates.navigateToPage('/lessons', label: 'ابدأ التعلم'),
        AiCommandTemplates.addExpense(0, 'other', ''),
      ],
      type: AiResponseType.text,
    );
  }

  void _toggleListening() async {
    if (!_speechEnabled) return;

    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    } else {
      final available = await _speechToText.listen(
        onResult: (result) {
          setState(() {
            _messageController.text = result.recognizedWords;
          });
        },
        localeId: 'ar_SA',
      );
      
      if (available) {
        setState(() => _isListening = true);
      }
    }
  }

  void _pickImage() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) return;

    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (image != null) {
      _sendImageMessage(File(image.path));
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }


  void _clearChat() {
    setState(() {
      _messages.clear();
    });
    _addWelcomeMessage();
  }

  Widget _buildCommandButtons(List<AiCommand> commands) {
    return Wrap(
      spacing: AppTheme.spacingSm,
      runSpacing: AppTheme.spacingSm,
      children: commands.map((command) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _executeCommand(command),
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingSm,
              ),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                border: Border.all(
                  color: AppTheme.accentColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeroIcon(
                    _getCommandIcon(command.type),
                    size: 16,
                    color: AppTheme.accentColor,
                  ),
                  const SizedBox(width: AppTheme.spacingXs),
                  Text(
                    command.label ?? CommandHandlerService.getCommandDescription(command),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  HeroIcons _getCommandIcon(AiCommandType type) {
    switch (type) {
      case AiCommandType.navigate:
        return HeroIcons.arrowTopRightOnSquare;
      case AiCommandType.addExpense:
        return HeroIcons.plus;
      case AiCommandType.createBudget:
        return HeroIcons.wallet;
      case AiCommandType.showChart:
        return HeroIcons.chartBarSquare;
      case AiCommandType.setGoal:
        return HeroIcons.flag;
      case AiCommandType.calculate:
        return HeroIcons.calculator;
      case AiCommandType.learn:
        return HeroIcons.academicCap;
      case AiCommandType.analyze:
        return HeroIcons.chartPie;
      default:
        return HeroIcons.commandLine;
    }
  }

  void _executeCommand(AiCommand command) async {
    try {
      await CommandHandlerService.executeCommand(context, command);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في تنفيذ الأمر: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final File? image;
  final AiResponse? aiResponse;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.image,
    this.aiResponse,
  });

  // Convert to format suitable for OpenAI conversation history
  Map<String, dynamic> toOpenAIFormat() {
    return {
      'isUser': isUser,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'hasImage': image != null,
    };
  }
}
