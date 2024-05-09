import 'dart:developer';

const int appID = 354610698;
const String appSign =
    "5407a5e25b243aeb0509e0217766e90f4b32747740bf43687cac2c87249547b4";

String getItemStatus(status) {
  log("status in getItemStatus = $status");
  if (status == 1) {
    return "Ready to sell";
  } else {
    return "Sold";
  }
}
