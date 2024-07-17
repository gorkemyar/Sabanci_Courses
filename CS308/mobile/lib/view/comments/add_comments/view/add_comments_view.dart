import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile/core/base/state/base_state.dart';
import 'package:mobile/core/base/view/base_widget.dart';
import 'package:mobile/core/init/theme/color_theme.dart';
import 'package:mobile/core/widgets/ToastMessage.dart';
import 'package:mobile/locator.dart';
import 'package:mobile/view/comments/add_comments/viewmodel/add_comments_view_model.dart';

late int productRating;

class AddCommentsView extends StatefulWidget {
  const AddCommentsView({Key? key}) : super(key: key);

  @override
  State<AddCommentsView> createState() => _AddCommentsViewState();
}

class _AddCommentsViewState extends BaseState<AddCommentsView> {
  late AddCommentsViewModel viewModel;
  String _inputText = '';

  @override
  Widget build(BuildContext context) {
    return BaseView(
      viewModel: locator<AddCommentsViewModel>(),
      onModelReady: (dynamic model) async {
        model.setContext(context);
        model.init();
        viewModel = model;
      },
      onPageBuilder: (context, value) {
        return Scaffold(
          appBar: _appBar(),
          body: _body(),
        );
      },
    );
  }

  AppBar _appBar() => AppBar(
        title: const Text("Add Review"),
      );

  Center _body() => Center(
        child: Padding(
          padding: const EdgeInsets.all(12.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RatingBar.builder(
                minRating: 1,
                glow: true,
                glowColor: AppColors.primaryLight,
                allowHalfRating: false,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: AppColors.primary,
                ),
                onRatingUpdate: (rating) {
                  productRating = rating.toInt();
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Text(
                    "Write a comment (optional)",
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _inputText = value;
                        });
                      },
                      controller: viewModel.contentController,
                      maxLines: 10,
                      decoration: InputDecoration(
                          counterText:
                              "${_inputText.length.toString()} character(s)",
                          counterStyle: const TextStyle(
                            color: AppColors.tertiary,
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          fillColor: AppColors.gray,
                          focusColor: AppColors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: AppColors.primary,
                              ))),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              submitReview(),
            ],
          ),
        ),
      );

  OutlinedButton submitReview() => OutlinedButton(
        onPressed: () async {
          showToast(
              context: context,
              message: "Comment has been added",
              isSuccess: true);
          await viewModel.submit();
          Navigator.pop(context);
        },
        child: RichText(
            text: const TextSpan(children: [
          WidgetSpan(
            child: Icon(
              Icons.send,
              size: 18,
              color: AppColors.white,
            ),
          ),
          TextSpan(
            text: " Submit Review",
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
