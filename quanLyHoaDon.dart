import 'dart:io';
import 'dart:async';

List<Map<String, dynamic>> gioHang = [];

Future<void> clearConsole({int time = 0}) async {
  await Future.delayed(Duration(milliseconds: time));
  stdout.write('\x1B[2J\x1B[0;0H');
}

Future<String> inputString({
  required String message_1,
  required String message_2,
}) async {
  await clearConsole(time: 200);
  String? value;
  bool isValid = false;

  while (!isValid) {
    stdout.write(message_1);
    value = stdin.readLineSync();

    if (value != null && value.trim().isNotEmpty) {
      isValid = true;
    } else {
      print(message_2);
      print('Vui lòng thử lại sau 3 giây...');
      await Future.delayed(Duration(seconds: 3));
    }
  }

  return value!;
}

Future<double> inputDouble({
  required String message_1,
  required String message_2,
}) async {
  await clearConsole(time: 200);
  dynamic value;
  bool isValid = false;

  while (!isValid) {
    stdout.write(message_1);
    value = stdin.readLineSync();

    value = int.tryParse(value.toString()) == null
        ? double.tryParse(value.toString())
        : int.tryParse(value.toString());

    if (value != null) {
      isValid = true;
    } else {
      print(message_2);
      print('Vui lòng thử lại sau 3 giây...');
      await Future.delayed(Duration(seconds: 3));
    }
  }

  return double.tryParse(value.toString())!;
}

Future<int> inputInt({
  required String message_1,
  required String message_2,
}) async {
  await clearConsole(time: 200);
  dynamic value;
  bool isValid = false;

  while (!isValid) {
    stdout.write(message_1);
    value = stdin.readLineSync();

    value = int.tryParse(value.toString());

    if (value != null) {
      isValid = true;
    } else {
      print(message_2);
      print('Vui lòng thử lại sau 3 giây...');
      await Future.delayed(Duration(seconds: 3));
    }
  }

  return int.tryParse(value.toString())!;
}

themSanPham() async {
  String ten = await inputString(
    message_1: "Nhập tên sản phẩm: ",
    message_2: "Tên sản phẩm không hợp lệ!",
  );

  int soLuong = await inputInt(
    message_1: "Nhập số lượng: ",
    message_2: "Số lượng không hợp lệ!",
  );

  double gia = await inputDouble(
    message_1: "Nhập giá tiền: ",
    message_2: "Giá tiền không hợp lệ",
  );

  gioHang.add({'ten': ten, 'soLuong': soLuong, 'gia': gia});

  print('✅ Đã thêm sản phẩm vào giỏ hàng.');
}

suaSanPham() async {
  String ten = await inputString(
    message_1: "Nhập tên sản phẩm cần sửa: ",
    message_2: "Tên sản phẩm không hợp lệ!",
  );

  var sp = gioHang.firstWhere(
    (item) => item['ten'].toLowerCase() == ten.toLowerCase(),
    orElse: () => {},
  );

  if (sp.isEmpty) {
    print('❌ Không tìm thấy sản phẩm!');
    return;
  }

  sp['soLuong'] = await inputInt(
    message_1: "Nhập số lượng mới: ",
    message_2: "Số lượng không hợp lệ",
  );

  stdout.write('Nhập giá tiền mới: ');
  sp['gia'] = await inputDouble(
    message_1: "Nhập giá tiền mới: ",
    message_2: "Giá tiền không hợp lệ",
  );

  print('✅ Đã cập nhật sản phẩm.');
}

xoaSanPham() async {
  String ten = await inputString(
    message_1: "Nhập tên sản phẩm cần xóa: ",
    message_2: "Tên sản phẩm không hợp lệ!",
  );

  bool daXoa = false;

  gioHang.removeWhere((item) {
    if (item['ten'].toLowerCase() == ten.toLowerCase()) {
      daXoa = true;
      return true;
    }
    return false;
  });

  if (daXoa) {
    print('✅ Đã xóa sản phẩm "$ten" thành công.');
  } else {
    print('❌ Sản phẩm "$ten" không tồn tại trong giỏ hàng.');
  }
}

void hienThiGioHang() {
  if (gioHang.isEmpty) {
    print('🛒 Giỏ hàng trống!');
    return;
  }

  print('\n🧾 Danh sách sản phẩm trong giỏ hàng:');
  for (var sp in gioHang) {
    print(
      'Tên: ${sp['ten']} | Số lượng: ${sp['soLuong']} | Giá: ${sp['gia']} | Thành tiền: ${(sp['soLuong'] * sp['gia']).toStringAsFixed(2)}',
    );
  }
}

void tinhTongTien() {
  double tong = 0;
  for (var sp in gioHang) {
    tong += sp['soLuong'] * sp['gia'];
  }
  print('\n💰 Tổng tiền hóa đơn: ${tong.toStringAsFixed(2)}');
}

void main() async {
  while (true) {
    print('\n========= MENU =========');
    print('1. Thêm sản phẩm');
    print('2. Sửa sản phẩm');
    print('3. Xóa sản phẩm');
    print('4. Hiển thị giỏ hàng');
    print('5. Tính tổng tiền');
    print('6. Thoát');
    stdout.write('Chọn chức năng (1-6): ');
    String? chon = stdin.readLineSync();

    switch (chon) {
      case '1':
        await themSanPham();
        break;
      case '2':
        await suaSanPham();
        break;
      case '3':
        await xoaSanPham();
        break;
      case '4':
        hienThiGioHang();
        break;
      case '5':
        tinhTongTien();
        break;
      case '6':
        print('👋 Thoát chương trình.');
        return;
      default:
        print('❌ Lựa chọn không hợp lệ.');
    }
  }
}
