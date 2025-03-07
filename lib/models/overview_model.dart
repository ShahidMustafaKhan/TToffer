class OverViewModel {
  int? unreadNotifications;
  int? cartItemCount;
  int? savedForLaterCount;
  int? chatCount;
  int? wishListCount;

  OverViewModel(
      {this.unreadNotifications,
        this.cartItemCount,
        this.savedForLaterCount,
        this.chatCount,
        this.wishListCount});

  OverViewModel.fromJson(Map<String, dynamic> json) {
    unreadNotifications = json['unread_notifications'];
    cartItemCount = json['cart_item_count'];
    savedForLaterCount = json['saved_for_later_count'];
    chatCount = json['chat_count'];
    wishListCount = json['wishList_count'];
  }

}