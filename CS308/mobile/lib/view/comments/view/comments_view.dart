import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/core/widgets/productItems/comment_widget.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/comments/viewmodel/comments_view_model.dart';

late int productId;

class CommentsView extends StatefulWidget {
  final int productId;
  const CommentsView({Key? key, required this.productId}) : super(key: key);

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  late CommentsViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return BaseView(
        viewModel: locator<CommentsViewModel>(),
        onModelReady: (dynamic model) async {
          model.setContext(context);
          model.init();
          viewModel = model;
          viewModel.productId = widget.productId;
        },
        onPageBuilder: (context, value) {
          debugPrint(viewModel.productId.toString());
          return FutureBuilder(
            future: viewModel.getData(),
            builder: ((context, snapshot) => !snapshot.hasData
                ? const Scaffold(
                    body: Center(child: CircularProgressIndicator()))
                : Scaffold(
                    appBar: _appBar(),
                    body: _body(),
                  )),
          );
        });
  }

  AppBar _appBar() => AppBar(
        title: const Text("All Comments"),
      );

  RefreshIndicator _body() => RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
            () {
              setState(() {
                viewModel.init();
              });
              viewModel.getData();
            },
          );
        },
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Observer(builder: (_) {
                        return Text(
                          "There are ${viewModel.comments.length} comments about this product",
                          style: const TextStyle(
                            color: AppColors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        );
                      })
                    ],
                  ),
                  Observer(builder: (_) {
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: ((context, index) =>
                            CommentWidget(comment: viewModel.comments[index])),
                        itemCount: viewModel.comments.length);
                  }),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                  addComment(),
                ],
              ),
            ),
          ],
        ),
      );

  OutlinedButton addComment() => OutlinedButton(
        onPressed: () {
          productId = widget.productId;
          viewModel.navigateToAddCommentsView(context);
        },
        child: RichText(
            text: const TextSpan(children: [
          WidgetSpan(
            child: Icon(
              Icons.chat_bubble,
              size: 18,
              color: AppColors.white,
            ),
          ),
          TextSpan(
            text: " Add Review",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          )
        ])),
        style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.primary,
            primary: AppColors.primary,
            fixedSize: const Size(360, 60),
            side: const BorderSide(width: 1.0, color: AppColors.primary)),
      );
}
