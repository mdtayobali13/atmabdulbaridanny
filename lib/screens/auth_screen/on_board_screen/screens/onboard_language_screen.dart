import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/models/app_language_model.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/services/storage/storage_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/utils/languages/language_provider.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class OnboardLanguageScreen extends StatefulWidget {
  const OnboardLanguageScreen({super.key});

  @override
  State<OnboardLanguageScreen> createState() => _OnboardLanguageScreenState();
}

class _OnboardLanguageScreenState extends State<OnboardLanguageScreen> {
  StorageServices storageServices = StorageServices.instance;
  // List<AppLanguageModel> appLanguages = [
  //   AppLanguageModel(
  //     flag: "US",
  //     name: "English",
  //     value: "en_US",
  //     isSelected: true,
  //   ),
  //   AppLanguageModel(flag: "BD", name: "Bangla", value: "bn_BD"),
  //   AppLanguageModel(flag: "JP", name: "Japanese", value: "ja_JP"),
  //   AppLanguageModel(flag: "SA", name: "Arabic", value: "ar_SA"),
  //   AppLanguageModel(flag: "CN", name: "Chinese", value: "zh_CN",),
  // ];

  List<AppLanguageModel> result = [];
  void onSelected(int index) {
    try {
      result = result.map((e) => e.copyWith(isSelected: false)).toList();
      result[index] = result[index].copyWith(isSelected: true);
      setState(() {});
    } catch (e) {
      errorLog("onSelected", e);
    }
  }

  void onSearch(String value) {
    try {
      var newList = publicAppLanguagesList.where((e) => e.name.toLowerCase().contains(value.toLowerCase())).toList();
      newList.sort((a, b) => a.name.compareTo(b.name));
      result = newList;
      if (context.mounted) {
        setState(() {});
      }
    } catch (e) {
      errorLog("onSearch", e);
    }
  }

  Future<void> continueFunction(WidgetRef ref) async {
    try {
      var findIndex = result.indexWhere((element) => element.isSelected);
      if (findIndex.isNegative) {
        AppSnackBar.instance.message("Please First Selected Language");
        return;
      }
      var item = result[findIndex];
      await ref.read(languageProvider.notifier).setLanguage(item.value);
      await storageServices.setAppFirstTime();
      await Future.delayed(const Duration(milliseconds: 200));
      AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
    } catch (e) {
      errorLog("continueFunction", e);
    }
  }

  @override
  void initState() {
    super.initState();
    try {
      publicAppLanguagesList.sort((a, b) => a.name.compareTo(b.name));
      result = publicAppLanguagesList;
    } catch (e) {
      errorLog("initState", e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Center(child: AppText(text: countryCodeToEmoji("BD"))),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Align(
                child: AppImage(width: AppSize.size.width * 0.6, path: AppAssertsImagePath.instance.logo),
              ),
            ),
            SliverAppBar(
              floating: true,
              pinned: true,
              title: AppInputWidget(
                hintText: "Search Languages",
                prefix: Center(child: Icon(Icons.search)),
                textColor: AppColors.instance.dark500,
                onChanged: (value) {
                  onSearch(value);
                },
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.05, vertical: AppSize.size.width * 0.035),
                child: AppText(text: "All Languages", fontWeight: FontWeight.w600, fontSize: AppSize.size.width * 0.05),
              ),
            ),

            SliverPadding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: AppSize.size.width * 0.05),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  var item = result[index];
                  return InkWell(
                    onTap: () {
                      onSelected(index);
                    },
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: AppSize.size.width * 0.035, horizontal: AppSize.size.width * 0.025),
                      margin: EdgeInsets.only(bottom: AppSize.size.width * 0.035),
                      decoration: BoxDecoration(
                        border: Border.all(color: item.isSelected ? AppColors.instance.blue400 : AppColors.instance.dark200, width: 2),
                        borderRadius: BorderRadius.circular(AppSize.width(value: 8)),
                      ),
                      child: Row(
                        children: [
                          AppText(text: countryCodeToEmoji(item.flag), fontWeight: FontWeight.w700, fontSize: AppSize.size.width * 0.05),
                          Gap(width: 10),
                          Expanded(
                            child: AppText(text: item.name, fontWeight: FontWeight.w700, fontSize: AppSize.size.width * 0.05),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: result.length),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            return AppButton(
              onTap: () {
                continueFunction(ref);
              },
              title: "Continue",
              height: AppSize.size.width * 0.15,
              backgroundColor: AppColors.instance.success,
              borderColor: AppColors.instance.success,
              loaderColor: AppColors.instance.white50,
              margin: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.1, vertical: AppSize.size.width * 0.05),
            );
          },
        ),
      ),
    );
  }
}

String countryCodeToEmoji(String countryCode) {
  return countryCode.toUpperCase().codeUnits.map((codeUnit) {
    return String.fromCharCode(codeUnit + 127397);
  }).join();
}
