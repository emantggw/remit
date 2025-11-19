import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remit/core/entity/UserAccount.dart';
import 'package:remit/presentation/_common/dimension.dart';
import 'package:remit/presentation/_common/icons.dart';
import 'package:remit/presentation/_common/utils/validators_utils.dart';
import 'package:remit/presentation/_common/widgets/app_bar_widget.dart';
import 'package:remit/presentation/_common/widgets/auth_button.dart';
import 'package:remit/presentation/_common/widgets/error_message_widget.dart';
import 'package:remit/presentation/_common/widgets/text_field_widget.dart'
    show TextFieldWidget;
import 'package:remit/presentation/_providers/auth_provider.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _firstName = '';
  String _password = '';
  // ignore: unused_field
  String _confirmPassword = '';
  bool _showPasswordOne = false;
  final bool _showPasswordTwo = false;

  void _onSignup() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(authProvider.notifier)
          .signupWithEmailAndPassword(
            userAccount: UserAccount(email: _email, firstName: _firstName),
            password: _password,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          const AppBarWidget(title: "Create account"),
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.all(kdPadding),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFieldWidget(
                        // initialValue: viewModel.savedPhoneNumber,
                        textInputType: TextInputType.emailAddress,
                        onChanged: (v) => _firstName = v ?? '',
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please enter first name';
                          }
                          return null;
                        },
                        prefixIcon: kiName,
                        hintText: "First name",
                      ),
                      kdSpaceLarge.height,
                      TextFieldWidget(
                        // initialValue: viewModel.savedPhoneNumber,
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
                        obscureText: !_showPasswordOne,
                        hintText: "Password",
                        suffixWidget: IconButton(
                          icon: Icon(_showPasswordOne ? kiEyeOff : kiEye),
                          onPressed: () => setState(
                            () => _showPasswordOne = !_showPasswordOne,
                          ),
                        ),
                      ),
                      kdSpaceLarge.height,
                      TextFieldWidget(
                        onChanged: (v) => _confirmPassword = v ?? '',
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Please retype password';
                          }
                          if (v != _password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        prefixIcon: kiPassword,
                        obscureText: !_showPasswordTwo,
                        hintText: "Retype password",
                        suffixWidget: IconButton(
                          icon: Icon(!_showPasswordTwo ? kiEyeOff : kiEye),
                          onPressed: () => setState(
                            () => _showPasswordOne = !_showPasswordOne,
                          ),
                        ),
                      ),
                      kdSpaceLarge.height,
                      if (ref.watch(authProvider).error != null) ...[
                        ErrorMessageWidget(
                          message: ref.read(authProvider).error!,
                        ),
                        kdSpaceXLarge.height,
                      ],
                      kdSpaceXLarge.height,
                      SizedBox(
                        width: kdScreenWidth(context),
                        child: AuthButton(
                          onPressed: _onSignup,
                          title: 'Create Account',
                          isBusy: ref.watch(authProvider).isLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
