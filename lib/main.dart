import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'router/app_router.dart';

// Chế độ hệ thống UI dùng chung cho toàn app: ẩn cả status bar lẫn thanh
// điều hướng/gesture bar. `immersiveSticky` cho phép người dùng vuốt từ mép
// màn hình để tạm hiện lại thanh hệ thống (bán trong suốt, tự ẩn lại sau
// vài giây) thay vì chặn hẳn thao tác vuốt như `immersive`.
const _kImmersiveMode = SystemUiMode.immersiveSticky;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khóa toàn bộ app ở chế độ màn hình ngang (landscape).
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Ẩn thanh trạng thái + thanh điều hướng/gesture bar của Android.
  SystemChrome.setEnabledSystemUIMode(_kImmersiveMode);

  // Đặt sẵn overlay trong suốt cho khoảnh khắc thanh hệ thống được vuốt ra
  // tạm thời (immersiveSticky vẫn cho phép việc này) để không bị lộ thanh
  // đen mặc định của Android.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(const ProviderScope(child: HistoQuestApp()));
}

// Màu nền chuẩn của game — dùng làm scaffoldBackgroundColor và màu nền
// hiển thị xuyên qua thanh trạng thái/điều hướng hệ thống.
const _kAppBackgroundColor = Color(0xFF2A241F);

class HistoQuestApp extends ConsumerStatefulWidget {
  const HistoQuestApp({super.key});

  @override
  ConsumerState<HistoQuestApp> createState() => _HistoQuestAppState();
}

class _HistoQuestAppState extends ConsumerState<HistoQuestApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Android tự động hiện lại thanh trạng thái/điều hướng mỗi khi app quay
    // lại foreground (mở lại từ recents, tắt/mở màn hình, đóng bàn phím...).
    // Phải set lại chế độ ẩn mỗi lần resume, nếu không thanh hệ thống sẽ bị
    // lộ lại vĩnh viễn cho tới khi hot restart.
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setEnabledSystemUIMode(_kImmersiveMode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider);

    // LƯU Ý: KHÔNG được bọc MaterialApp.router bên trong Scaffold/MediaQuery
    // ở đây. Scaffold cần một Directionality ancestor (do MaterialApp cung
    // cấp), nhưng ở vị trí này MaterialApp còn chưa được build nên chưa có
    // Directionality nào cả -> Scaffold ném lỗi "No Directionality widget
    // found" và app crash ngay khi khởi động. Toàn bộ style/padding cho
    // vùng system bar phải được áp dụng bên TRONG MaterialApp (qua
    // `builder`), tức là sau khi Directionality đã tồn tại.
    return MaterialApp.router(
      title: 'HistoQuest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: _kAppBackgroundColor,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      routerConfig: goRouter,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).removePadding(
            removeLeft: true,
            removeRight: true,
            removeBottom: true,
            removeTop: true,
          ),
          // Nền màu game hiển thị xuyên qua thanh trạng thái/điều hướng
          // trong suốt (transparent) đã set ở SystemUiOverlayStyle bên trên.
          child: ColoredBox(
            color: _kAppBackgroundColor,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
