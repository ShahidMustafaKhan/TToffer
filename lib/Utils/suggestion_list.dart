final Map<String, dynamic> categoryMessages = {
  "Mobiles": [
    "Hi, is this mobile still available?",
    "Hi, I'd like to buy this mobile.",
    "Hi, can you provide more details about the phone?",
    "Is this mobile in good working condition?"
  ],
  "Electronics & Appliances": [
    "Hi, is this item still available?",
    "Hi, I'd like to buy this electronic item.",
    "Hi, can you confirm the warranty details?",
    "Does this come with all necessary accessories?"
  ],
  "Property for Sale": [
    "Hi, is this property still available for sale?",
    "Hi, I'd like to schedule a visit to see this property.",
    "Can you provide more details about the property?",
    "Is the price negotiable?"
  ],
  "Property for Rent": [
    "Hi, is this property still available for rent?",
    "Hi, I'd like to know about the lease terms.",
    "Can you provide details about the neighborhood?",
    "Is this property pet-friendly?"
  ],
  "Vehicles": [
    "Hi, is this vehicle still available?",
    "Hi, I'd like to know more about the vehicle's condition.",
    "Can I schedule a test drive?",
    "Is the price negotiable?"
  ],
  "Bikes": [
    "Hi, is this bike still available?",
    "Hi, I'd like to buy this bike.",
    "Can you provide more details about the bike?",
    "Is this bike in good condition?"
  ],
  "hiring": [
    "Hi, is this position still open?",
    "Hi, I'm interested in applying for this job.",
    "Can you provide more details about the role?",
    "What are the working hours and benefits?"
  ],
  "looking": [
    "Hi, is this candidate still available for hiring?",
    "Hi, I'm interested in this candidate's profile.",
    "Can you provide more details about their experience?",
    "Is the candidate available for an interview?"
  ],
  "Services": [
    "Hi, is this service still available?",
    "Hi, I'd like to inquire about your services.",
    "Can you provide details about pricing?",
    "Are there any available slots this week?"
  ],
  "Furniture & home decor": [
    "Hi, is this furniture piece still available?",
    "Hi, I'd like to buy this item.",
    "Can you provide dimensions for this item?",
    "Is this furniture in good condition?"
  ],
  "Fashion & beauty": [
    "Hi, is this fashion item still available?",
    "Hi, I'd like to buy this beauty product.",
    "Can you provide details about the material or ingredients?",
    "Is this item brand new?"
  ],
  "Kids": [
    "Hi, is this item still available?",
    "Hi, I'd like to buy this for my kids.",
    "Can you provide more details about the item?",
    "Is this item safe for children of all ages?"
  ],
  "Animals": [
    "Hi, is this animal or pet item still available?",
    "Hi, I'd like to know more about this pet.",
    "Can you provide details about the pet's health and vaccinations?",
    "Is there any adoption fee or requirement?"
  ]
};

List<String> getMessages(String category, [String? subcategory]) {
  if (categoryMessages.containsKey(category)) {
    final messages = categoryMessages[category];
    if (messages is List<String>) {
      return messages;
    } else if (messages is Map<String, List<String>> && subcategory != null) {
      return messages[subcategory] ?? [];
    }
  }
  return [];
}