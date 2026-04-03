import 'package:flutter/material.dart';

import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/widgets/others/app_text.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  // The privacy policy text directly embedded in the code.
  final String _privacyPolicy = '''
Welcome to TTOffer. We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about this privacy notice or our practices regarding your personal information, please contact us at support@ttoffer.com. We take your privacy very seriously. We are aware of our obligations to safeguard your personal information in accordance with applicable data protection laws and in a reasonable and lawful manner. This privacy notice describes how we might use your information if you:

● Download and use our mobile application — TTOffer (available on Android and iOS)
● Engage with us in other related ways — including any sales, marketing, or events

1. Information We Collect

We collect personal information that you voluntarily provide to us when you register on the app, express an interest in obtaining information about us or our products and services, when you participate in activities on the app or website, or otherwise when you contact us. The personal information we collect depends on the context of your interactions with us and the app, website, the choices you make, and the products and features you use. The personal information we collect may include the following:
● Personal Information Provided by You. We collect names, phone numbers, email addresses, usernames, passwords, and other similar information.

● PaymentData. We may collect data necessary to process your payment if you make purchases, such as your payment instrument number (e.g., credit card number), and the security code associated with your payment instrument. All payment data is stored by our payment processor and you should review its privacy policies and contact the payment processor directly to respond to your questions.

2. How We Use Your Information

We use personal information collected via our app and website for a variety of business purposes described below. We process your personal information for these purposes in reliance on our legitimate business interests, to enter into or perform a contract with you, with your consent, and/or for compliance with our legal obligations. We indicate the specific processing grounds we rely on next to each purpose listed below:
● To facilitate account creation and logon process. If you choose to link your account with us to a third-party account (such as your Google or Facebook account), we use the information you allowed us to collect from those third parties to facilitate account creation and logon process.

● Request feedback. We may use your information to request feedback and to contact you about your use of our app and website.

● To enable user-to-user communications. We may use your information to enable user-to-user communications with each user’s consent.

● To manage user accounts. We may use your information for the purposes of managing our account and keeping it in working order.

● To send administrative information to you. We may use your personal information to send you product, service, and new feature information and/or information about changes to our terms, conditions, and policies.

● To protect our Services. We may use your information as part of our efforts to keep our app and website safe and secure (for example, for fraud monitoring and prevention).

● To respond to legal requests and prevent harm. If we receive a subpoena or other legal request, we may need to inspect the data we hold to determine how to respond.

● Fulfill and manage your orders. We may use your information to fulfill and manage your orders, payments, returns, and exchanges made through the app and website.

3. Sharing Your Information

We may process or share your data that we hold based on the following legal basis:

● Consent: We may process your data if you have given us specific consent to use your personal information for a specific purpose.

● Legitimate Interests: We may process your data when it is reasonably necessary to achieve our legitimate business interests.

● Performance of a Contract: Where we have entered into a contract with you, we may process your personal information to fulfill the terms of our contract.

● Legal Obligations: We may disclose your information where we are legally required to do so to comply with applicable law, governmental requests, a judicial proceeding, court order, or legal process, such as in response to a court order or a subpoena (including in response to public authorities to meet national security or law enforcement requirements).

● Vital Interests: We may disclose your information where we believe it is necessary to investigate, prevent, or take action regarding potential violations of our policies, suspected fraud, situations involving potential threats to the safety of any person, and illegal activities, or as evidence in litigation in which we are involved.

4. Security of Your Information

We aim to protect your personal information through a system of organizational and technical security measures. However, despite our safeguards and efforts to secure your information, no electronic transmission over the Internet or information storage technology can be guaranteed to be 100% secure, so we cannot promise or guarantee that hackers, cybercriminals, or other unauthorized third parties will not be able to defeat our security and improperly collect, access, steal, or modify your information.

5. Retention

We will keep your information for as long as is required for the relevant purpose specified in this Privacy Policy, unless otherwise mandated by applicable law. If you use the Contact Us Forms to submit an inquiry to us, your information will be kept on file for the duration of that requirement plus an extra period of time to handle any requests pertaining to your inquiry, as well as in compliance with our legal obligations, such as when it's required for the filing, pursuit, or defense of legal claims.

6. Your Privacy Rights

In some regions (like the EEA, UK, and Canada), you have rights that allow you greater access to and control over your personal information. You may review, change, or terminate your account at any time.

Upon your request to terminate your account, we will deactivate or delete your account and information from our active databases. However, we may retain some information in our files to prevent fraud, troubleshoot problems, assist with any investigations, enforce our Terms of Use and/or comply with applicable legal requirements.

7. Updates to This Policy

We may update this privacy notice from time to time to reflect changes to our practices or for other operational, legal, or regulatory reasons. You are advised to review this privacy notice periodically for any changes.

8. Contact Us

If you have questions or comments about this notice, you may contact us by email at support@ttoffer.com.
  ''';

  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        title: AppText.appText("Privacy Policy",
            fontSize: 20,
            fontWeight: FontWeight.w400,
            textColor: AppTheme.blackColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to TTOffer.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),
            const Text(
              'We are committed to protecting your personal information and your right to privacy. '
                  'If you have any questions or concerns about this privacy notice or our practices regarding '
                  'your personal information, please contact us at support@ttoffer.com. We take your privacy very seriously.',
            ),
            const SizedBox(height: 16),
            Text(
              'Information We Collect',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppTheme.yellowColor),
            ),
            const SizedBox(height: 8),
            const Text(
              'We collect personal information that you voluntarily provide to us when you register on the app, express an interest '
                  'in obtaining information about us or our products and services, when you participate in activities on the app or website, '
                  'or otherwise when you contact us. The personal information we collect may include the following:',
            ),
            const SizedBox(height: 8),
            const Text(
              '- Personal Information Provided by You: We collect names, phone numbers, email addresses, usernames, passwords, and other similar information.\n'
                  '- Payment Data: We may collect data necessary to process your payment if you make purchases, such as your payment instrument number '
                  '(e.g., credit card number), and the security code associated with your payment instrument. All payment data is stored by our payment processor.',
            ),
            const SizedBox(height: 16),
            Text(
              'How We Use Your Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppTheme.yellowColor),
            ),
            const SizedBox(height: 8),
            const Text(
              'We use personal information collected via our app and website for a variety of business purposes described below. We process your '
                  'personal information for these purposes in reliance on our legitimate business interests, to enter into or perform a contract with you, '
                  'with your consent, and/or for compliance with our legal obligations. We indicate the specific processing grounds we rely on next to each purpose listed below:',
            ),
            const SizedBox(height: 8),
            const Text(
              '- To facilitate account creation and logon process: If you choose to link your account with us to a third-party account (such as your Google or Facebook account), '
                  'we use the information you allowed us to collect from those third parties to facilitate account creation and logon process.\n'
                  '- Request feedback: We may use your information to request feedback and to contact you about your use of our app and website.\n'
                  '- To enable user-to-user communications: We may use your information to enable user-to-user communications with each user\'s consent.\n'
                  '- To manage user accounts: We may use your information for the purposes of managing our account and keeping it in working order.\n'
                  '- To send administrative information to you: We may use your personal information to send you product, service, and new feature information and/or '
                  'information about changes to our terms, conditions, and policies.\n'
                  '- To protect our services: We may use your information as part of our efforts to keep our app and website safe and secure (for example, for fraud monitoring and prevention).\n'
                  '- To respond to legal requests and prevent harm: If we receive a subpoena or other legal request, we may need to inspect the data we hold to determine how to respond.\n'
                  '- Fulfill and manage your orders: We may use your information to fulfill and manage your orders, payments, returns, and exchanges made through the app and website.',
            ),
            const SizedBox(height: 16),
            // Adding the remaining text
            Text(
              'Sharing Your Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppTheme.yellowColor),
            ),
            const SizedBox(height: 8),
            const Text(
              'We may process or share your data that we hold based on the following legal basis:',
            ),
            const SizedBox(height: 8),
            const Text(
              '- Consent: We may process your data if you have given us specific consent to use your personal information for a specific purpose.\n'
                  '- Legitimate Interests: We may process your data when it is reasonably necessary to achieve our legitimate business interests.\n'
                  '- Performance of a Contract: Where we have entered into a contract with you, we may process your personal information to fulfill the terms of our contract.\n'
                  '- Legal Obligations: We may disclose your information where we are legally required to do so to comply with applicable law, governmental requests, a judicial proceeding, court order, or legal process, such as in response to a court order or a subpoena (including in response to public authorities to meet national security or law enforcement requirements).\n'
                  '- Vital Interests: We may disclose your information where we believe it is necessary to investigate, prevent, or take action regarding potential violations of our policies, suspected fraud, situations involving potential threats to the safety of any person, and illegal activities, or as evidence in litigation in which we are involved.',
            ),
            const SizedBox(height: 16),
            Text(
              'Security of Your Information',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppTheme.yellowColor),
            ),
            const SizedBox(height: 8),
            const Text(
              'We aim to protect your personal information through a system of organizational and technical security measures. However, despite our safeguards and efforts to secure your information, no electronic transmission over the Internet or information storage technology can be guaranteed to be 100% secure, so we cannot promise or guarantee that hackers, cyber criminals, or other unauthorized third parties will not be able to defeat our security and improperly collect, access, steal, or modify your information.',
            ),
            const SizedBox(height: 16),
            Text(
              'Retention',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppTheme.yellowColor),
            ),
            const SizedBox(height: 8),
            const Text(
              'We will keep your information for as long as is required for the relevant purpose specified in this Privacy Policy, unless otherwise mandated by applicable law. If you use the Contact Us Forms to submit an inquiry to us, your information will be kept on file for the duration of that requirement plus an extra period of time to handle any requests pertaining to your inquiry, as well as in compliance with our legal obligations, such as when it\'s required for the filing, pursuit, or defense of legal claims.',
            ),
            const SizedBox(height: 16),
            Text(
              'Your Privacy Rights',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppTheme.yellowColor),
            ),
            const SizedBox(height: 8),
            const Text(
              'In some regions (like the EEA, UK, and Canada), you have rights that allow you greater access to and control over your personal information. You may review, change, or terminate your account at any time. Upon your request to terminate your account, we will deactivate or delete your account and information from our active databases. However, we may retain some information in our files to prevent fraud, troubleshoot problems, assist with any investigations, enforce our Terms of Use and/or comply with applicable legal requirements.',
            ),
            const SizedBox(height: 16),
            Text(
              'Updates to This Policy',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppTheme.yellowColor),
            ),
            const SizedBox(height: 8),
            const Text(
              'We may update this privacy notice from time to time to reflect changes to our practices or for other operational, legal, or regulatory reasons. You are advised to review this privacy notice periodically for any changes.',
            ),
            const SizedBox(height: 16),
            Text(
              'Contact Us',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppTheme.yellowColor),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you have questions or comments about this notice, you may contact us by email at support@ttoffer.com.',
            ),
          ],
        ),
      )

    );
  }
}