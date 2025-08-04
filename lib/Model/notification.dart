class NotificationModel {
  final int notifID;
  final String libelle;
  final int utilisateurId;
  final bool isRead;

  NotificationModel({
    required this.notifID,
    required this.libelle,
    required this.utilisateurId,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notifID: json['notif_ID'],
      libelle: json['libelle'],
      utilisateurId: json['utilisateurId'],
      isRead: json['isRead'],
    );
  }
}