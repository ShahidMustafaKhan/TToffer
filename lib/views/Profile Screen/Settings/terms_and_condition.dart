
import 'package:flutter/material.dart';

import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/widgets/others/app_text.dart';



class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key});

  // The "About Us" content directly embedded in the code.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        title: AppText.appText("Terms & Condition",
            fontSize: 20,
            fontWeight: FontWeight.w500,
            textColor: AppTheme.blackColor),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Text(
    // "Terms and Conditions",
    // style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    // ),
    SizedBox(height: 5.0),
    Text(
    "Last Updated: 05.10.2024",
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    SizedBox(height: 24.0),
    Text(
    "Welcome to TToffer Marketplace! By accessing or using our services, you agree to be bound by these Terms and Conditions. Please read them carefully.",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "1. Acceptance of Terms",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "These TToffer Platform Terms of Use (referred to as 'Terms of Use') outline the rules for utilizing the platform located at www.ttoffer.com and any associated TToffer mobile applications that may be available periodically (collectively known as the 'Platform'). They also encompass all information, content, and materials published on or accessible through the Platform (collectively referred to as the 'Content').",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "2. Listing and Selling Items",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "The Platform allows users looking to sell an item or service (the 'Seller') to advertise it (each referred to as a 'Listing') to other users. Interested users (the 'Buyer') can then contact the Seller through the Listing to make an offer. If you are a Seller, you must...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "3. Boosting Ads",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "TToffer may occasionally offer paid services on the Platform ('Boost Plus'). For instance, you might opt to pay a fee to have your Listing featured more prominently in search results. You acknowledge and agree that, regarding each Paid Service...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "4. Content Restrictions",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "Any content you upload to the Platform, including as part of a Listing, will be treated as non-confidential and non-proprietary. You retain all ownership rights to your content; however, you must grant us and other users of the Platform a limited license to use...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "5. Payment Terms",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "In some cases, we may collect payments from you through the Platform (such as when you opt for Paid Services). We use Stripe technology, which enables us to avoid storing your bank information...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "6. User Rights and Intellectual Property",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "Subject to your ongoing compliance with these Terms of Use, TToffer grants you a personal, limited, non-transferable, non-exclusive, and revocable right to use the Platform and its Content...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "7. Privacy Policy",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "Please review our Privacy Policy to learn how we collect, process, and share your personal data in connection with your use of the Platform.",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "8. Limitation of Liability",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "You acknowledge and agree that TToffer is not obligated to monitor, approve, or moderate Listings or their content. We are not liable for any Listings posted on the Platform...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "9. Eligibility",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "You must not: Use the Platform if you are under eighteen (16) years of age. Use the Platform for any illegal activities or purposes...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "10. Changes to Terms",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "We may update these Terms of Use occasionally, with or without prior notice to you. The latest version will be posted on this page...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "11. Changes to Platform",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "We may modify the operation of the Platform and/or update any Content at any time without prior notice...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "12. Suspension",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "We do not guarantee that the Platform and/or any Content will always be accessible for free or available at all times...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "13. TToffer Liability",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "We do not intend to exclude or limit our liability to you in any manner that would be unlawful...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "14. Violations of These Terms & Conditions",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "If we determine, at our sole discretion, that you are in breach of any part of these Terms of Use, we may take appropriate actions...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "15. Report of illegal or infringing content",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "If you encounter any Content on the Platform that you believe is illegal, please contact us immediately...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "16. General Terms & Conditions",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "Links to Third-Party Sites or Content: Where the Platform contains links to other websites or third-party content...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "17. Language",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "If these Terms of Use are translated into another language and there is a discrepancy between the English version and the translated text...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "18. Dispute Resolution",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "If a dispute arises between you and TToffer, we encourage you to contact us directly at support@ttoffer.com to seek resolution...",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 16.0),
    Text(
    "19. Contact Information",
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 8.0),
    Text(
    "For any questions or concerns regarding these Terms and Conditions, please contact us at:\n- Email: support@ttoffer.com\n- Address: Al Khabeesi building plot 128-246.",
    style: TextStyle(fontSize: 16),
    ),
    SizedBox(height: 24.0),
    ],
    ),
    ),


    );
  }
}