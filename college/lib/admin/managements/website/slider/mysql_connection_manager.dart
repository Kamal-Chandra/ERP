import 'package:mysql1/mysql1.dart';

class MySqlConnectionManager {
  MySqlConnection? _connection;

  Future<MySqlConnection> getConnection() async {
    _connection ??= await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: 'MySQLRoot',
        db: 'college',
      ));
    return _connection!;
  }

  Future<void> closeConnection() async {
    if (_connection != null) {
      await _connection!.close();
      _connection = null;
    }
  }
}