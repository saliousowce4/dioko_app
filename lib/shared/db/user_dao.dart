import 'package:floor/floor.dart';

import '../../features/auth/data/models/user_model.dart';

@dao
abstract class UserDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUser(UserModel user);

  @Query('SELECT * FROM user LIMIT 1')
  Future<UserModel?> findUser();

  @Query('DELETE FROM user')
  Future<void> deleteUser();
}