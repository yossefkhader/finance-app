import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import '../theme/app_theme.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _roundUpsEnabled = true;
  bool _budgetAlerts = true;
  bool _weeklySummary = false;
  double _monthlySavingsGoal = 500.0;
  
  final TextEditingController _nameController = TextEditingController(text: 'Alex Johnson');
  final TextEditingController _emailController = TextEditingController(text: 'alex.johnson@email.com');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Section
          _buildAccountSection(),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Savings & Round-Ups Section
          _buildSavingsSection(),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Notifications Section
          _buildNotificationsSection(),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Linked Accounts Section
          _buildLinkedAccountsSection(),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      title: 'Account',
      icon: HeroIcons.user,
      child: Column(
        children: [
          // Avatar and Basic Info
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusXl),
                ),
                child: const Center(
                  child: HeroIcon(
                    HeroIcons.user,
                    size: 32,
                    color: AppTheme.accentColor,
                  ),
                ),
              ),
              
              const SizedBox(width: AppTheme.spacingLg),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Picture',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppTheme.spacingXs),
                    Text(
                      'Click to upload a new photo',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              
              OutlinedButton(
                onPressed: () {},
                child: const Text('Change'),
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Form Fields
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Display Name',
              hintText: 'Enter your name',
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingLg),
          
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter your email',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Save Changes'),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.errorColor,
                    side: const BorderSide(color: AppTheme.errorColor),
                  ),
                  child: const Text('Sign Out'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsSection() {
    return _buildSection(
      title: 'Savings & Round-Ups',
      icon: HeroIcons.arrowTrendingUp,
      child: Column(
        children: [
          // Round-ups toggle
          _buildSettingItem(
            title: 'Enable Round-Ups',
            subtitle: 'Automatically round up purchases and save the difference',
            trailing: Switch(
              value: _roundUpsEnabled,
              onChanged: (value) {
                setState(() {
                  _roundUpsEnabled = value;
                });
              },
              activeColor: AppTheme.accentColor,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingLg),
          
          // Monthly savings goal
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Monthly Savings Goal',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    '\$${_monthlySavingsGoal.toInt()}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppTheme.spacingMd),
              
              Slider(
                value: _monthlySavingsGoal,
                min: 100,
                max: 2000,
                divisions: 19,
                activeColor: AppTheme.accentColor,
                onChanged: (value) {
                  setState(() {
                    _monthlySavingsGoal = value;
                  });
                },
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$100',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '\$2,000',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Save Preferences'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection() {
    return _buildSection(
      title: 'Notifications',
      icon: HeroIcons.bell,
      child: Column(
        children: [
          _buildSettingItem(
            title: 'Budget Alerts',
            subtitle: 'Get notified when you\'re close to your budget limit',
            trailing: Switch(
              value: _budgetAlerts,
              onChanged: (value) {
                setState(() {
                  _budgetAlerts = value;
                });
              },
              activeColor: AppTheme.accentColor,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingLg),
          
          _buildSettingItem(
            title: 'Weekly Summary',
            subtitle: 'Receive a weekly summary of your spending and savings',
            trailing: Switch(
              value: _weeklySummary,
              onChanged: (value) {
                setState(() {
                  _weeklySummary = value;
                });
              },
              activeColor: AppTheme.accentColor,
            ),
          ),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Save Preferences'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedAccountsSection() {
    return _buildSection(
      title: 'Linked Accounts',
      icon: HeroIcons.creditCard,
      child: Column(
        children: [
          _buildAccountItem(
            bankName: 'Chase Bank',
            accountType: 'Checking Account',
            lastFour: '••••1234',
            isConnected: true,
          ),
          
          const SizedBox(height: AppTheme.spacingMd),
          
          _buildAccountItem(
            bankName: 'Bank of America',
            accountType: 'Savings Account',
            lastFour: '••••5678',
            isConnected: true,
          ),
          
          const SizedBox(height: AppTheme.spacingMd),
          
          _buildAccountItem(
            bankName: 'Wells Fargo',
            accountType: 'Credit Card',
            lastFour: '••••9012',
            isConnected: false,
          ),
          
          const SizedBox(height: AppTheme.spacingXl),
          
          // Add Account Button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const HeroIcon(
                HeroIcons.plus,
                size: 16,
              ),
              label: const Text('Link New Account'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required HeroIcons icon,
    required Widget child,
  }) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(AppTheme.borderRadiusLg),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppTheme.spacingSm),
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
                  ),
                  child: HeroIcon(
                    icon,
                    size: 20,
                    color: AppTheme.accentColor,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            
            const SizedBox(height: AppTheme.spacingXl),
            
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppTheme.spacingXs),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }

  Widget _buildAccountItem({
    required String bankName,
    required String accountType,
    required String lastFour,
    required bool isConnected,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isConnected 
                  ? AppTheme.successColor.withOpacity(0.1)
                  : AppTheme.textTertiary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusMd),
            ),
            child: Center(
              child: HeroIcon(
                HeroIcons.creditCard,
                size: 20,
                color: isConnected ? AppTheme.successColor : AppTheme.textTertiary,
              ),
            ),
          ),
          
          const SizedBox(width: AppTheme.spacingMd),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bankName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  '$accountType $lastFour',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingSm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: isConnected 
                  ? AppTheme.successColor.withOpacity(0.1)
                  : AppTheme.textTertiary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSm),
            ),
            child: Text(
              isConnected ? 'Connected' : 'Disconnected',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isConnected ? AppTheme.successColor : AppTheme.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
