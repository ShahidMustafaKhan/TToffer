
import 'package:flutter/material.dart';

import '../../../Utils/resources/res/app_theme.dart';
import '../../../Utils/widgets/others/app_text.dart';



class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  // The "About Us" content directly embedded in the code.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        title: AppText.appText("About Us",
            fontSize: 20,
            fontWeight: FontWeight.w500,
            textColor: AppTheme.blackColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              'Welcome to TToffer!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'At TToffer we’re transforming the way you shop, sell, and bid. Our online marketplace is designed to connect buyers and sellers in a dynamic environment where everyone can find great deals, unique products, and exciting auction opportunities. Our mission is to create an engaging platform that empowers users to explore, discover, and thrive.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Our Vision',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'We envision a marketplace where every transaction sparks joy. TToffer is committed to offering a diverse array of products and services, allowing buyers to find exactly what they need while enabling sellers to reach a global audience.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Our Values',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Transparency: We prioritize clear communication and honest practices in all transactions.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Customer Focus: Your experience matters. We strive to provide outstanding support and service.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Innovation: We embrace creativity and technology to enhance your buying, selling, and bidding experience.',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Community: We believe in building a supportive community of users who share a passion for commerce.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'What We Offer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Buy: Shop from a wide range of products across various categories.\n'
                  'Sell: List your items easily and connect with interested buyers.\n'
                  'Bid: Participate in exciting auctions for the chance to win unique items at competitive prices.\n'
                  'Sell to Us: Choose an available time to meet with our team. Get your estimated price and make a deal with us.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Free Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'All the features you need to start buying and selling immediately are available for free. You can browse the feed for items to purchase, post items for sale, chat with other TToffer users, and more. The app also helps you find safe locations to meet local buyers and sellers for cash transactions. TToffer does not charge fees or take a commission from your in-person transactions.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Paid Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'While most TToffer features are free, we also provide optional upgraded features for a fee. “Boost Plus” paid features are designed to enhance your buying and selling experience in our marketplace.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'How “Boost Plus” Ads Work on TToffer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Boosting your ads on TToffer allows you to increase their visibility and reach a larger audience in our marketplace. Here’s how the boosting process works:\n'
                  '- Select Your Ad: Choose the listing you want to boost.\n'
                  '- Choose Boost Options: TToffer provides various boosting options.\n'
                  '- Payment: Complete the payment process for boosting.\n'
                  '- Enhanced Visibility: Your ad will be prominently displayed.\n'
                  '- Performance Tracking: Track the performance of your boosted ad through analytics tools.\n'
                  '- End of Boost: Once the boosting period ends, your ad returns to its standard placement.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Join Us',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'At TToffer, every user plays a vital role in our marketplace. Whether you’re hunting for a special item, looking to sell, or eager to place a bid, you’ll find a welcoming community ready to support you.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}