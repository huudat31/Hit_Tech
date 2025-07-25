import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectionItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? icon;
  final SelectionItemType type;

  const SelectionItemWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.type = SelectionItemType.list,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SelectionItemType.list:
        return _buildListItem();
      case SelectionItemType.grid:
        return _buildGridItem();
      case SelectionItemType.card:
        return _buildCardItem();
    }
  }

  Widget _buildListItem() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected 
                  ? const Color(0xFF4A90E2) 
                  : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12.r),
            color: isSelected 
                ? const Color(0xFF4A90E2).withOpacity(0.1)
                : Colors.white,
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                icon!,
                SizedBox(width: 16.w),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: isSelected 
                            ? const Color(0xFF4A90E2)
                            : Colors.black87,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: const Color(0xFF4A90E2),
                  size: 24.r,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem() {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF4A90E2) 
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected 
              ? const Color(0xFF4A90E2).withOpacity(0.1)
              : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            if (icon != null) SizedBox(height: 8.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isSelected 
                    ? const Color(0xFF4A90E2)
                    : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 4.h),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 8.h),
                child: Icon(
                  Icons.check_circle,
                  color: const Color(0xFF4A90E2),
                  size: 20.r,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardItem() {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF4A90E2) 
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected 
              ? const Color(0xFF4A90E2).withOpacity(0.1)
              : Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              SizedBox(height: 12.h),
            ],
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: isSelected 
                    ? const Color(0xFF4A90E2)
                    : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: 4.h),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 8.h),
                child: Icon(
                  Icons.check_circle,
                  color: const Color(0xFF4A90E2),
                  size: 20.r,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

enum SelectionItemType {
  list,
  grid,
  card,
}
