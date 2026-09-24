import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controllers/app_controllers.dart';
import '../../../core/colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/app_models.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/auth/auth_text_field.dart';
import '../../../widgets/common/auth_message.dart';
import '../../../widgets/common/user_avatar.dart';

/// ترويسة الملف الشخصي داخل الإعدادات: الصورة والاسم والبريد والهاتف
/// مع تعديلها — بأسلوب البطاقات والحقول الحالية دون إعادة تصميم.
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  Future<void> _changeAvatar(BuildContext context, ImageSource source) async {
    final String? before = AppControllers.instance.profile?.avatarUrl;
    final String? error =
        await AppControllers.instance.profileController.changeAvatar(source);
    if (!context.mounted) return;
    if (error != null) {
      showAuthMessage(context, error);
      return;
    }
    final String? after = AppControllers.instance.profile?.avatarUrl;
    if (after != before) {
      showAuthMessage(
        context,
        AppLocalizations.of(context)!.profileAvatarUpdated,
        isError: false,
      );
    }
  }

  Future<void> _removeAvatar(BuildContext context) async {
    final String? before = AppControllers.instance.profile?.avatarUrl;
    final String? error =
        await AppControllers.instance.profileController.removeAvatar();
    if (!context.mounted) return;
    if (error != null) {
      showAuthMessage(context, error);
      return;
    }
    final String? after = AppControllers.instance.profile?.avatarUrl;
    if (after != before) {
      showAuthMessage(
        context,
        AppLocalizations.of(context)!.profileAvatarRemoved,
        isError: false,
      );
    }
  }

  void _showAvatarOptions(BuildContext context) {
    final bool hasAvatar =
        (AppControllers.instance.profile?.avatarUrl ?? '').isNotEmpty;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(sheetContext)!.profileAvatarSheetTitle,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                AppLocalizations.of(sheetContext)!.profileAvatarFromGallery,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _changeAvatar(context, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.photo_camera_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                AppLocalizations.of(sheetContext)!.profileAvatarTakePhoto,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                _changeAvatar(context, ImageSource.camera);
              },
            ),
            if (hasAvatar)
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                ),
                title: Text(
                  AppLocalizations.of(sheetContext)!.profileAvatarRemove,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _removeAvatar(context);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (_) => const _EditProfileDialog(),
    );
    if (!context.mounted) return;
    if (saved == true) {
      showAuthMessage(
        context,
        AppLocalizations.of(context)!.profileSaved,
        isError: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = AppControllers.instance.profileController;
    // استماع مباشر إلى الكونترولر: تُعيد بناء الترويسة مع كل تغيّر فيه،
    // فلا تعتمد على إعادة بناء الأب التي يتجاوزها `const` (تجمّد/دوران أبدي).
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => _buildBody(context, controller),
    );
  }

  Widget _buildBody(BuildContext context, ProfileController controller) {
    final UserProfile? profile = controller.profile;
    final String? firebaseName = AuthService.instance.currentUser?.displayName;
    final String name = ProfileController.resolveName(
      profile,
      fallback: firebaseName,
    );
    final String email = ProfileController.resolveEmail(
      profile,
      fallback: AuthService.instance.currentUser?.email,
    );
    final String? phone = profile?.phone;

    if (controller.isLoading && profile == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
            strokeWidth: 3,
          ),
        ),
      );
    }

    if (controller.error != null && profile == null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.error!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            TextButton(
              onPressed: () => AppControllers.instance.loadProfile(force: true),
              child: Text(
                AppLocalizations.of(context)!.profileRetry,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: controller.isSaving
                ? null
                : () => _showAvatarOptions(context),
            child: UserAvatar(
              radius: 30,
              profile: profile,
              fallbackName: firebaseName,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  email,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  (phone != null && phone.isNotEmpty)
                      ? phone
                      : AppLocalizations.of(context)!.profileNoPhone,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: controller.isSaving
                ? null
                : () => _showEditDialog(context),
            tooltip: AppLocalizations.of(context)!.profileEditTitle,
            icon: Icon(
              Icons.edit_outlined,
              color: Theme.of(context).colorScheme.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

/// نافذة تعديل الاسم ورقم الهاتف — بحقلَي `AuthTextField` الحاليين.
class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog();

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  bool _saving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final UserProfile? profile = AppControllers.instance.profile;
    _nameController = TextEditingController(text: profile?.fullName ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _saving = true;
      _errorText = null;
    });

    final ProfileController controller =
        AppControllers.instance.profileController;
    final String currentName = controller.profile?.fullName ?? '';
    final String currentPhone = controller.profile?.phone ?? '';
    final String newName = _nameController.text.trim();
    final String newPhone = _phoneController.text.trim();

    String? error;
    if (newName != currentName) {
      error = await controller.updateName(newName);
    }
    if (error == null && newPhone != currentPhone) {
      error = await controller.updatePhone(newPhone);
    }

    if (!mounted) return;
    if (error != null) {
      setState(() {
        _saving = false;
        _errorText = error;
      });
      return;
    }
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      title: Text(
        l10n.profileEditTitle,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AuthFormField(
                  controller: _nameController,
                  hintText: l10n.signUpNameHint,
                  fieldType: AuthFieldType.name,
                  prefixIcon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                AuthFormField(
                  controller: _phoneController,
                  hintText: l10n.addTenantPhoneHint,
                  fieldType: AuthFieldType.phone,
                  isRequired: false,
                  prefixIcon: Icons.phone_outlined,
                ),
                if (_errorText != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _errorText!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context, false),
          child: Text(
            l10n.cancel,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.white,
                  ),
                )
              : Text(l10n.save),
        ),
      ],
    );
  }
}
