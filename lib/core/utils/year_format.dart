/// Định dạng năm lịch sử để hiển thị trên UI.
///
/// Với việc bổ sung dữ liệu Thời kỳ Tiền sử & Cổ đại, [HistoricalEventModel.year]
/// có thể là số âm đại diện cho mốc trước Công nguyên (TCN). Hàm này chuyển
/// một số âm như `-2879` thành chuỗi `"2879 TCN"` (có dấu chấm phân cách hàng
/// nghìn cho các mốc tiền sử rất xa, vd: `-300000` → `"300.000 TCN"`), và giữ
/// nguyên số dương (`938` → `"938"`).
String formatHistoricalYear(int year) {
  if (year >= 0) return '$year';
  final digits = (-year).toString();
  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '$buffer TCN';
}
