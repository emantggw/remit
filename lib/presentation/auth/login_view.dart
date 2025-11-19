import 'package:remit/presentation/_common/app_colors.dart';
import 'package:remit/presentation/_common/dimension.dart';
import 'package:remit/presentation/_common/font.dart';
import 'package:remit/presentation/_common/icons.dart';
import 'package:remit/presentation/_common/utils/validators_utils.dart';
import 'package:remit/presentation/_common/widgets/app_image.dart';
import 'package:remit/presentation/_common/widgets/auth_button.dart';
import 'package:remit/presentation/_common/widgets/error_message_widget.dart';
import 'package:remit/presentation/_common/widgets/loading_indicator.dart';
import 'package:remit/presentation/_common/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:remit/presentation/_providers/auth_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _showPassword = false;

  void _toggleShowPassword() => setState(() => _showPassword = !_showPassword);

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(authProvider.notifier);
    final res = await notifier.loginWithEmail(_email, _password);
    if (res.isSuccessful) {
      // navigate to home
      if (mounted) context.go('/home');
    }
  }

  Future<void> _onLoginWithGoogle() async {
    final notifier = ref.read(authProvider.notifier);
    final res = await notifier.loginWithGoogle();
    if (res.isSuccessful) {
      if (mounted) context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: authState.isLoading
            ? Center(child: LoadingIndicator())
            : Padding(
                padding: const EdgeInsets.all(kdPaddingLarge),
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(
                      top: (kdScreenHeight(context) * 0.18),
                    ),
                    color: kcBackground(context),
                    child: Column(
                      children: [
                        Text(
                          "Welcome Back",
                          style: kfBrandStyle(
                            context,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                        kdSpaceXLarge.height,
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFieldWidget(
                                textInputType: TextInputType.emailAddress,
                                onChanged: (v) => _email = v ?? '',
                                validator: ValidatorUtils.emailValidator,
                                prefixIcon: kiEmail,
                                hintText: "Email",
                              ),
                              kdSpaceLarge.height,
                              TextFieldWidget(
                                onChanged: (v) => _password = v ?? '',
                                validator: ValidatorUtils.passwordValidator,
                                prefixIcon: kiPassword,
                                obscureText: !_showPassword,
                                hintText: "Password",
                                suffixWidget: IconButton(
                                  icon: Icon(!_showPassword ? kiEyeOff : kiEye),
                                  onPressed: _toggleShowPassword,
                                ),
                              ),
                              kdSpace.height,
                              if (authState.error != null) ...[
                                ErrorMessageWidget(message: authState.error!),
                                kdSpaceXLarge.height,
                              ],
                              kdSpaceXLarge.height,
                              SizedBox(
                                width: kdScreenWidth(context),
                                child: AuthButton(
                                  onPressed: _onLogin,
                                  title: 'Sign In',
                                ),
                              ),
                              kdSpace.height,
                              SizedBox(
                                width: kdScreenWidth(context),
                                child: AuthButton(
                                  outlineMode: true,
                                  onPressed: _onLoginWithGoogle,
                                  titleWidget: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const AppImageWidget(
                                        url: "assets/images/icon_google.png",
                                        width: kdSmallSquareAvatar,
                                        height: kdSmallSquareAvatar,
                                        isFromLocalAsset: true,
                                      ),
                                      kdSpaceTiny.width,
                                      const Text("Sign In with Google"),
                                    ],
                                  ),
                                ),
                              ),
                              kdSpaceLarge.height,
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () => context.go('/signup'),
                                  child: Text(
                                    "Create new account",
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      decorationColor: kcPrimary(context),
                                      color: kcPrimary(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
