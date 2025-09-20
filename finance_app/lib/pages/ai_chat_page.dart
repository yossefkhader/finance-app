import 'dart:io';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';

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
    _addWelcomeMessage();
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

  // Widget _buildChatHeader(AppLocalizations l10n) {
  //   return Container(
  //     padding: const EdgeInsets.all(AppTheme.spacingLg),
  //     decoration: BoxDecoration(
  //       color: AppTheme.cardColor,
  //       boxShadow: AppTheme.cardShadow,
  //     ),
  //     child: Row(
  //       children: [
  //         Container(
  //           width: 40,
  //           height: 40,
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               colors: [AppTheme.accentColor, AppTheme.accentSecondary],
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             ),
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: const Center(
  //             child: HeroIcon(
  //               HeroIcons.sparkles,
  //               size: 20,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
          
  //         const SizedBox(width: AppTheme.spacingMd),
          
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'المساعد المالي الذكي',
  //                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               Text(
  //                 _isTyping ? 'يكتب...' : 'متصل',
  //                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
  //                   color: _isTyping ? AppTheme.accentColor : AppTheme.successColor,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
          
  //         IconButton(
  //           icon: const HeroIcon(HeroIcons.ellipsisVertical),
  //           onPressed: () => _showChatOptions(context),
  //           color: AppTheme.textSecondary,
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
    _generateAIResponse('تحليل الصورة المرفقة');
  }

  void _generateAIResponse(String userMessage) {
    // Simulate AI response delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: _getAIResponse(userMessage),
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
      
      _scrollToBottom();
    });
  }

  String _getAIResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('ميزانية') || lowerMessage.contains('budget')) {
      return 'بناءً على بياناتك المالية، ميزانيتك الشهرية ٢٧٥٠ ريال وقد استخدمت ٦٨٪ منها. أنصحك بمراقبة المصروفات في الفئات التالية:\n\n• الطعام والمطاعم: ٨٥٠ ريال\n• الفواتير والخدمات: ٦٥٠ ريال\n\nهل تريد نصائح لتوفير المزيد؟';
    }
    
    if (lowerMessage.contains('مدخرات') || lowerMessage.contains('savings')) {
      return 'مدخراتك تبدو جيدة! هذا الشهر وفرت ٤٨٢ ريال من خلال التقريب والادخار اليدوي.\n\n💡 نصائح لزيادة المدخرات:\n• فعّل التقريب التلقائي\n• ضع هدف ادخار شهري\n• راجع المصروفات غير الضرورية\n\nهدفك الحالي للطوارئ: ٢٨٤٨ من ٥٠٠٠ ريال (٥٧٪)';
    }
    
    if (lowerMessage.contains('صورة') || lowerMessage.contains('تحليل')) {
      return 'شكراً لإرفاق الصورة! 📸\n\nيمكنني مساعدتك في:\n• تحليل الفواتير وإدخالها تلقائياً\n• قراءة أرقام المبالغ\n• تصنيف نوع المصروف\n\nلتفعيل هذه الميزة بالكامل، سنحتاج إلى ربط خدمة التعرف الضوئي على النصوص.';
    }
    
    if (lowerMessage.contains('نصيحة') || lowerMessage.contains('help')) {
      return 'إليك أهم النصائح المالية بناءً على وضعك:\n\n💰 **ادخار فوري:**\n• قلل مصروفات المطاعم بـ ٢٠٪\n• راجع الاشتراكات الشهرية\n\n📊 **تخطيط مالي:**\n• ضع ميزانية للترفيه\n• زيد نسبة الادخار لـ ٢٠٪\n\n🎯 **أهداف:**\n• أكمل صندوق الطوارئ\n• ابدأ استثمار بسيط\n\nأي موضوع تريد التفصيل فيه؟';
    }
    
    return 'شكراً لسؤالك! أنا هنا لمساعدتك في جميع الأمور المالية. يمكنني مساعدتك في:\n\n• تحليل ميزانيتك ومصروفاتك\n• تقديم نصائح للادخار\n• تتبع أهدافك المالية\n• تحليل عادات الإنفاق\n\nما الذي تريد معرفته بالتحديد؟';
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

  void _showChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const HeroIcon(HeroIcons.trash),
              title: const Text('مسح المحادثة'),
              onTap: () {
                Navigator.pop(context);
                _clearChat();
              },
            ),
            ListTile(
              leading: const HeroIcon(HeroIcons.share),
              title: const Text('مشاركة المحادثة'),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
    });
    _addWelcomeMessage();
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

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.image,
  });
}
