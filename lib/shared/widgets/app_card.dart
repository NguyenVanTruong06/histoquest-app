import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget? child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? badge;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double borderRadius;
  final bool isActive;
  final double elevation;

  const AppCard({
    super.key,
    this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.badge,
    this.onTap,
    this.padding = const EdgeInsets.all(18.0),
    this.margin,
    this.backgroundColor,
    this.borderRadius = 24.0,
    this.isActive = false,
    this.elevation = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = backgroundColor ?? AppColors.surface;
    final borderColor = isActive ? AppColors.cardBorderActive : AppColors.cardBorder;
    final borderWidth = isActive ? 2.0 : 1.2;

    Widget cardBody = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null || badge != null || leading != null || trailing != null) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (title != null)
                          Expanded(
                            child: Text(
                              title!,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ?badge,
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
          if (child != null) const SizedBox(height: 14),
        ],
        ?child,
      ],
    );

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: const Color(0xFF2D2B2B).withValues(alpha: isActive ? 0.14 : 0.06),
                  offset: const Offset(0, 8),
                  blurRadius: isActive ? 24 : 16,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding,
            child: cardBody,
          ),
        ),
      ),
    );
  }
}
