import 'package:devfest/app/app.dart';
import 'package:devfest/common/common.dart';
import 'package:devfest/data/data.dart';
import 'package:devfest/data/product_list.dart';
import 'package:devfest/home/widgets/widgets.dart';
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
              height: 110,
              width: 110,
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
            ),
          ],
        ),
        const Height20(),
        Text(
          'Area of topic from Devfest speakers',
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 10, bottom: 20, left: 5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 100 / 100,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            shrinkWrap: true,
            //clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              final product = productLists[index];
              return ProductCard(
                key: Key(product.toString()),
                product: product,
                index: index,
              );
            },
            itemCount: productLists.length),
        const Height20(),
        Text(
          'Find GDG near you',
          style: Theme.of(context)
              .textTheme
              .headline4!
              .copyWith(fontWeight: FontWeight.w700),
        ),
        GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 10, bottom: 20, left: 5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 100 / 100,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            shrinkWrap: true,
            //clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              final gdg = gdgLists[index];
              return GDGCard(
                key: Key(gdg.toString()),
                gdg: gdg,
                index: index,
              );
            },
            itemCount: gdgLists.length),
        const Height20(),
        Center(
          child: Text(
            'Built with 💙 for developers.',
            style: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
