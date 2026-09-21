import 'dart:math' as math;
import 'dart:ui' show DisplayFeatureType;

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

  // Khóa toàn bộ app ở chế độ màn hình dọc (portrait).
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
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
        final base = MediaQuery.of(context);

        // Ở chế độ immersive Android báo padding.top = 0 nên nội dung bị
        // camera / tai thỏ (display cutout) đè lên. Ta tự tính lại inset phía
        // trên từ padding gốc của View (đã gồm cutout) và từ displayFeatures,
        // rồi đưa lại vào MediaQuery để SafeArea / MediaQuery.padding trên MỌI
        // màn hình tự né camera. Các cạnh khác vẫn giữ = 0 như cũ.
        final view = View.of(context);
        final rawTop = view.padding.top / view.devicePixelRatio;
        // Hình chữ nhật cutout mà Android báo luôn "rộng rãi" hơn lỗ camera thật
        // (kèm vùng đệm an toàn), nên nếu lấy nguyên đáy của nó thì dư một
        // đoạn. Với camera đục lỗ (rect gần vuông) ta ước lượng đáy lỗ thật từ
        // tâm + bán kính; với tai thỏ (rect dẹt, rộng) lấy nguyên đáy. Mọi số
        // đều suy ra từ hình học do máy báo nên tự co giãn theo từng dòng máy.
        double cutoutBottom = 0;
        for (final f in base.displayFeatures) {
          if (f.type != DisplayFeatureType.cutout || f.bounds.top > 1) continue;
          final r = f.bounds;
          final isPunchHole = r.width <= r.height * 1.6;
          final bottom = isPunchHole
              ? math.min(
                  r.bottom,
                  r.center.dy + math.min(r.width, r.height) * 0.35,
                )
              : r.bottom;
          cutoutBottom = math.max(cutoutBottom, bottom);
        }
        // Lỗ camera nằm TRONG thanh trạng thái nên đáy lỗ luôn nhỏ hơn chiều
        // cao thanh trạng thái (~75%). Lấy giá trị nhỏ nhất trong các ước lượng
        // khả dụng để khoảng đệm chỉ vừa hết camera, tự co giãn theo từng máy.
        final candidates = <double>[
          if (cutoutBottom > 0) cutoutBottom,
          if (rawTop > 0) rawTop * 0.75,
        ];
        final topInset = candidates.isEmpty ? 0.0 : candidates.reduce(math.min);
        assert(() {
          debugPrint('[CutoutInset] rawTop=$rawTop cutoutBottom=$cutoutBottom '
              'features=${base.displayFeatures} -> topInset=$topInset');
          return true;
        }());

        return MediaQuery(
          data: base
              .removePadding(
                removeLeft: true,
                removeRight: true,
                removeBottom: true,
                removeTop: true,
              )
              .copyWith(
                padding: EdgeInsets.only(top: topInset),
                viewPadding: EdgeInsets.only(top: topInset),
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
