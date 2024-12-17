import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dongne_chat/data/model/chat_room.dart';

class DongneListRepository {
  // 채팅방 가져오기
  Future<List<ChatRoom>?> getAll({
    required String address,
    required String? category,
  }) async {
    category = category ?? '천체'; // 기본값 설정
    try {
      var query = FirebaseFirestore.instance
          .collection('chatRooms')
          .where('address', isEqualTo: address)
          .orderBy('createdAt', descending: true);

      if (category != '전체') {
        query = query.where('category', isEqualTo: category);
      }

      final snapshot = await query.get();

      final chatRooms =
          snapshot.docs.map((doc) => ChatRoom.fromJson(doc)).toList();
      return chatRooms;
    } catch (e) {
      print("DongneListRepository : $e");
    }
  }

  // 채팅방 생성
  Future<bool> create({
    required String title,
    required String info,
    required String category,
    required List users,
    required String address,
    required String createdUser,
  }) async {
    try {
      //
      FirebaseFirestore.instance.collection('chatRooms').add({
        'title': title,
        'info': info,
        'category': category,
        'users': users,
        'address': address,
        'createdUser': createdUser,
        'createdAt': Timestamp.now(),
      });
      return true;
    } catch (e) {
      //
      return false;
    }
  }
}
