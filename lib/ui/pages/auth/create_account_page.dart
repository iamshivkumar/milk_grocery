import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grocery_app/ui/pages/auth/widgets/update_display_name_sheet.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      bottomSheet: UpdateDisplayNameSheet(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset("assets/undraw_Account.svg"),
      ),
    );
  }
}
