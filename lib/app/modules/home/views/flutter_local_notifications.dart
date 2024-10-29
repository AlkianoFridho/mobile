import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> showProgressNotification(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const int maxProgress = 5; // Jumlah total progres (misal 5 tahap)
  
  for (int i = 0; i <= maxProgress; i++) {
    // Menunda setiap pembaruan progres selama 1 detik
    await Future.delayed(const Duration(seconds: 1), () async {
      // Pengaturan notifikasi untuk Android dengan indikator progres
      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id', // ID channel notifikasi
        'your_channel_name', // Nama channel notifikasi
        channelDescription: 'your_channel_description', // Deskripsi channel
        channelShowBadge: false, // Tidak menampilkan badge di ikon aplikasi
        importance: Importance.max, // Level kepentingan notifikasi
        priority: Priority.high, // Prioritas notifikasi
        onlyAlertOnce: true, // Notifikasi hanya akan memberi alert sekali
        showProgress: true, // Menampilkan indikator progres
        maxProgress: maxProgress, // Nilai maksimum progres
        progress: i, // Nilai progres saat ini
      );

      // Detail notifikasi platform (Android)
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      // Tampilkan notifikasi dengan progres
      await flutterLocalNotificationsPlugin.show(
        0, // ID unik untuk notifikasi
        'Download in progress', // Judul notifikasi
        'Progress: $i/$maxProgress', // Isi notifikasi yang menampilkan status progres
        platformChannelSpecifics, // Detail notifikasi untuk platform
        payload: 'item x', // Payload untuk data tambahan (opsional)
      );
    });
  }
}
