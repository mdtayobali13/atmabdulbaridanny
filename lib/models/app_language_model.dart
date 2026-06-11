class AppLanguageModel {
  final String flag;
  final String name;
  final String value;
  final bool isSelected;
  AppLanguageModel({required this.flag, required this.name, required this.value, this.isSelected = false});

  AppLanguageModel copyWith({final String? flag, final String? name, final String? value, final bool? isSelected}) {
    return AppLanguageModel(flag: flag ?? this.flag, name: name ?? this.name, value: value ?? this.value, isSelected: isSelected ?? this.isSelected);
  }
}

List<AppLanguageModel> publicAppLanguagesList = [
  AppLanguageModel(flag: "US", name: "English", value: "en_US", isSelected: true),

  AppLanguageModel(flag: "CN", name: "Chinese", value: "zh-cn_CN"),

  AppLanguageModel(flag: "VN", name: "Vietnamese", value: "vi_VN"),

  AppLanguageModel(flag: "KR", name: "Korean", value: "ko_KR"),

  AppLanguageModel(flag: "PH", name: "Philippines", value: "fil_PH"),

  AppLanguageModel(flag: "NP", name: "Nepalese", value: "ne_NP"),

  AppLanguageModel(flag: "IN", name: "Indian", value: "hi_IN"),

  AppLanguageModel(flag: "ID", name: "Indonesian", value: "id_ID"),

  AppLanguageModel(flag: "MM", name: "Myanmar", value: "my_MM"),

  AppLanguageModel(flag: "TW", name: "Taiwanese", value: "zh-tw_TW"),

  AppLanguageModel(flag: "JP", name: "Japanese", value: "ja_JP"),

  AppLanguageModel(flag: "TH", name: "Thailand", value: "th_TH"),

  AppLanguageModel(flag: "BD", name: "Bangladesh", value: "bn_BD"),

  AppLanguageModel(flag: "LK", name: "Sri Lanka", value: "si_LK"),

  AppLanguageModel(flag: "SA", name: "Arabic", value: "ar_SA"),
];
