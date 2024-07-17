import 'package:flutter/material.dart';
import 'package:mobile/core/widgets/shimmer_widget.dart';

class CategoryShimmerView extends StatelessWidget {
  const CategoryShimmerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: ShimmerWidget.rectangular(
        height: 20,
        width: 64,
        radius: 4,
      ),
    );
  }

  Column _body() => Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: ShimmerWidget.rectangular(
              height: 48,
              width: double.infinity,
              radius: 8,
            ),
          ),
          GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: 24 / 37,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              ShimmerWidget.rectangular(
                height: 48,
                width: double.infinity,
                radius: 8,
              ),
              ShimmerWidget.rectangular(
                height: 48,
                width: double.infinity,
                radius: 8,
              ),
              ShimmerWidget.rectangular(
                height: 48,
                width: double.infinity,
                radius: 8,
              ),
              ShimmerWidget.rectangular(
                height: 48,
                width: double.infinity,
                radius: 8,
              ),
            ],
          ),
        ],
      );
}
