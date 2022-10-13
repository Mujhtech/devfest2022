import 'package:devfest/app/app.dart';
import 'package:devfest/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DevfestPage extends StatelessWidget {
  const DevfestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Height20(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              width: 150,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      width: 2, color: Theme.of(context).iconTheme.color!)),
              child: SvgPicture.asset(AppVector.developersLogo,
                  width: 20, height: 20, semanticsLabel: AppString.devfest),
            ),
            const Height5(),
            Text(
              AppString.devfest,
              style: Theme.of(context)
                  .textTheme
                  .headline1!
                  .copyWith(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const Height5(),
            Text(
              AppString.aboutDevfest,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            const CustomHeight(
              height: 30,
            ),
            SecondaryButton(
              height: 56,
              foregroundColor: AppColor.primary1,
              textColor: AppColor.white,
              onPressed: () {},
              label: 'Learn more',
              width: 150,
            )
          ],
        ),
      ],
    );
  }
}
