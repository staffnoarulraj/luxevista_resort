import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EditableFieldWidget extends StatefulWidget {
  final String label;
  final String value;
  final Function(String) onSave;

  const EditableFieldWidget({
    super.key,
    required this.label,
    required this.value,
    required this.onSave,
  });

  @override
  State<EditableFieldWidget> createState() => _EditableFieldWidgetState();
}

class _EditableFieldWidgetState extends State<EditableFieldWidget> {
  bool isEditing = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  Future<void> _handleSave() async {
    try {
      await widget.onSave(controller.text);
      setState(() => isEditing = false);
      if (mounted) {
        Fluttertoast.showToast(msg: "${widget.label} updated successfully");
      }
    } catch (e) {
      if (mounted) {
        Fluttertoast.showToast(msg: "Failed to update ${widget.label}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: const Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                if (isEditing)
                  TextField(
                    controller: controller,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: const Color(0xFF1A1A1A),
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF8B7355)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                    ),
                  )
                else
                  Text(
                    widget.value.isEmpty ? 'Not set' : widget.value,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: widget.value.isEmpty
                          ? const Color(0xFF999999)
                          : const Color(0xFF1A1A1A),
                    ),
                  ),
              ],
            ),
          ),
          if (isEditing) ...[
            IconButton(
              onPressed: () {
                setState(() => isEditing = false);
                controller.text = widget.value;
              },
              icon: const Icon(Icons.close, color: Color(0xFF666666)),
            ),
            IconButton(
              onPressed: _handleSave,
              icon: const Icon(Icons.check, color: Color(0xFF8B7355)),
            ),
          ] else
            IconButton(
              onPressed: () => setState(() => isEditing = true),
              icon: const Icon(Icons.edit_outlined, color: Color(0xFF8B7355)),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}