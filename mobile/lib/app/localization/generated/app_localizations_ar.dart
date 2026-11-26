// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'Y';

  @override
  String get welcomeTitle => 'مساحة آمنة لتُسمَع';

  @override
  String get welcomeSubtitle => 'شارك دون الكشف عن هويتك، وتواصل مع من يفهمك، وتابع مشاعرك بلطف.';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get signIn => 'لدي حساب بالفعل';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get homePlaceholder => 'نجهّز مساحتك الآن. ستصل الميزات في المهام القادمة.';

  @override
  String homeGreeting(String username) {
    return 'مرحبًا، $username';
  }

  @override
  String get onboardingPurposeTitle => 'مساحة هادئة لنفسك';

  @override
  String get onboardingPurposeBody =>
      'يساعدك Y على التعبير عن نفسك، والشعور بأنك لست وحدك، وفهم حالتك النفسية. لا يُغني عن الرعاية المتخصصة.';

  @override
  String get onboardingAnonymousTitle => 'هويتك مخفية هنا';

  @override
  String get onboardingAnonymousBody =>
      'لا يرى الأعضاء الآخرون سوى اسم مستعار وصورة رمزية. بريدك الإلكتروني وهويتك الحقيقية لا يظهران أبدًا.';

  @override
  String get onboardingTrackingTitle => 'انتبه لحالك';

  @override
  String get onboardingTrackingBody =>
      'تابع مزاجك ونومك وأدويتك وأفكارك بشكل خاص، ولاحظ الأنماط مع مرور الوقت.';

  @override
  String get onboardingPrivacyTitle => 'بياناتك ملكك';

  @override
  String get onboardingPrivacyBody =>
      'معلوماتك الصحية خاصة افتراضيًا. لا يُشارك أي شيء إلا إذا اخترت ذلك.';

  @override
  String get onboardingGuidelinesTitle => 'اللطف أولًا';

  @override
  String get onboardingGuidelinesBody =>
      'كن داعمًا، واحترم خصوصية الآخرين، ولا تقدّم النصائح على أنها حقائق طبية. إذا كنت في خطر، فتواصل مع خدمات الطوارئ المحلية.';

  @override
  String get onboardingSkip => 'تخطٍّ';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingFinish => 'أنشئ مساحتي';

  @override
  String onboardingPage(int current, int total) {
    return 'صفحة $current من $total';
  }

  @override
  String get fieldEmail => 'البريد الإلكتروني';

  @override
  String get fieldPassword => 'كلمة المرور';

  @override
  String get fieldConfirmPassword => 'تأكيد كلمة المرور';

  @override
  String get fieldNewPassword => 'كلمة المرور الجديدة';

  @override
  String get passwordHint => '10 أحرف على الأقل، تتضمن حروفًا وأرقامًا';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get validationEmailRequired => 'يرجى إدخال بريدك الإلكتروني.';

  @override
  String get validationEmailInvalid => 'يرجى إدخال بريد إلكتروني صالح.';

  @override
  String get validationPasswordRequired => 'يرجى إدخال كلمة المرور.';

  @override
  String get validationPasswordRules => 'استخدم 10 أحرف على الأقل، تتضمن حروفًا وأرقامًا.';

  @override
  String get validationPasswordMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get validationAgeRequired => 'يجب أن يكون عمرك 18 عامًا أو أكثر لاستخدام Y.';

  @override
  String get validationTermsRequired => 'يرجى الموافقة للمتابعة.';

  @override
  String get registerTitle => 'أنشئ حسابك';

  @override
  String get registerSubtitle => 'يبقى بريدك الإلكتروني خاصًا — يُستخدم لتسجيل الدخول فقط.';

  @override
  String get ageConfirmLabel => 'عمري 18 عامًا أو أكثر';

  @override
  String get termsLabel => 'أوافق على شروط الاستخدام وسياسة الخصوصية';

  @override
  String get registerSubmit => 'إنشاء الحساب';

  @override
  String get haveAccountPrompt => 'لديك حساب بالفعل؟';

  @override
  String get signInLink => 'تسجيل الدخول';

  @override
  String get loginTitle => 'مرحبًا بعودتك';

  @override
  String get loginSubtitle => 'سجّل الدخول للمتابعة.';

  @override
  String get loginSubmit => 'تسجيل الدخول';

  @override
  String get forgotPasswordLink => 'نسيت كلمة المرور؟';

  @override
  String get noAccountPrompt => 'جديد هنا؟';

  @override
  String get createAccountLink => 'أنشئ حسابًا';

  @override
  String get forgotTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotSubtitle => 'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لاختيار كلمة مرور جديدة.';

  @override
  String get forgotSubmit => 'إرسال رابط إعادة التعيين';

  @override
  String get forgotSentTitle => 'تحقق من بريدك الإلكتروني';

  @override
  String forgotSentBody(String email) {
    return 'إذا كان هناك حساب مرتبط بـ $email، فرابط إعادة التعيين في طريقه إليك. افتحه على هذا الهاتف لاختيار كلمة مرور جديدة.';
  }

  @override
  String get backToSignIn => 'العودة لتسجيل الدخول';

  @override
  String get resetTitle => 'اختر كلمة مرور جديدة';

  @override
  String get resetSubtitle => 'اختر كلمة مرور لم تستخدمها من قبل.';

  @override
  String get resetSubmit => 'حفظ كلمة المرور الجديدة';

  @override
  String get resetDoneTitle => 'تم تحديث كلمة المرور';

  @override
  String get resetDoneBody => 'تم تسجيل خروجك من جميع الأجهزة. سجّل الدخول بكلمة المرور الجديدة.';

  @override
  String get resetInvalidLink => 'رابط إعادة التعيين غير مكتمل. يرجى طلب رابط جديد.';

  @override
  String get setupBadge => 'ملفك الشخصي';

  @override
  String setupStep(int current, int total) {
    return 'الخطوة $current من $total';
  }

  @override
  String get setupProfileTitle => 'كيف ستظهر للآخرين';

  @override
  String get setupProfileSubtitle =>
      'هذا فقط ما يراه الأعضاء الآخرون — وليس بريدك الإلكتروني أو اسمك الحقيقي.';

  @override
  String get fieldUsername => 'اسم المستخدم';

  @override
  String get usernameHelper => 'من 3 إلى 20 حرفًا إنجليزيًا أو رقمًا أو _';

  @override
  String get usernameChecking => 'جارٍ التحقق…';

  @override
  String get usernameAvailable => 'متاح';

  @override
  String get usernameTaken => 'مستخدم بالفعل';

  @override
  String get usernameReserved => 'غير متاح — يرجى اختيار اسم آخر';

  @override
  String get usernameInvalid => 'من 3 إلى 20 حرفًا: حروف إنجليزية وأرقام و _، ويبدأ بحرف';

  @override
  String get shuffleUsername => 'اقترح اسمًا آخر';

  @override
  String get fieldAvatar => 'الصورة الرمزية';

  @override
  String avatarOption(int number) {
    return 'صورة رمزية $number';
  }

  @override
  String get fieldBio => 'نبذة عنك (اختياري)';

  @override
  String get bioHint => 'بضع كلمات تشعر بالراحة لمشاركتها';

  @override
  String get setupNext => 'متابعة';

  @override
  String get setupPrivacyTitle => 'خصوصيتك';

  @override
  String get setupPrivacySubtitle => 'يمكنك تغيير هذه الإعدادات في أي وقت.';

  @override
  String get privacyVisibilityLabel => 'ظهور الملف الشخصي';

  @override
  String get privacyVisibilityPublic => 'عام';

  @override
  String get privacyVisibilityPublicDesc => 'يمكن للأعضاء رؤية نبذتك.';

  @override
  String get privacyVisibilityPrivate => 'خاص';

  @override
  String get privacyVisibilityPrivateDesc => 'يرى الأعضاء اسم المستخدم والصورة الرمزية فقط.';

  @override
  String get privacyFollowLabel => 'من يمكنه متابعتك';

  @override
  String get privacyFollowEveryone => 'الجميع';

  @override
  String get privacyFollowNobody => 'لا أحد';

  @override
  String get privacyAnalyticsLabel => 'مشاركة إحصاءات استخدام مجهولة';

  @override
  String get privacyAnalyticsDesc => 'تساعدنا على تحسين Y. لا تتضمن بياناتك الصحية أبدًا.';

  @override
  String get privacyHealthNote => 'مزاجك وأدويتك ومذكراتك خاصة دائمًا.';

  @override
  String get setupFinish => 'إنهاء';

  @override
  String get actionContinue => 'متابعة';

  @override
  String get actionRetry => 'حاول مرة أخرى';

  @override
  String get actionBack => 'رجوع';

  @override
  String get actionCancel => 'إلغاء';

  @override
  String get actionSave => 'حفظ';

  @override
  String get actionSignOut => 'تسجيل الخروج';

  @override
  String get loading => 'جارٍ التحميل…';

  @override
  String get emptyTitle => 'لا يوجد شيء هنا بعد';

  @override
  String get emptySubtitle => 'عندما يتوفر محتوى، ستجده هنا.';

  @override
  String get offlineBanner => 'أنت غير متصل بالإنترنت. قد لا تكون بعض المعلومات محدّثة.';

  @override
  String get errorNetwork => 'تعذّر الاتصال. يرجى التحقق من اتصالك بالإنترنت.';

  @override
  String get errorTimeout => 'يستغرق هذا وقتًا أطول من المعتاد. يرجى المحاولة مرة أخرى.';

  @override
  String get errorUnauthorized => 'انتهت جلستك. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get errorForbidden => 'ليس لديك صلاحية الوصول إلى هذا.';

  @override
  String get errorNotFound => 'لم نتمكن من العثور على ما تبحث عنه.';

  @override
  String get errorValidation => 'يرجى مراجعة الحقول المحددة.';

  @override
  String get errorRateLimited => 'تقوم بذلك بشكل متكرر قليلًا. يرجى الانتظار لحظة.';

  @override
  String get errorServer => 'حدث خطأ من جهتنا. يرجى المحاولة لاحقًا.';

  @override
  String get errorUnknown => 'حدث أمر غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get languageSystem => 'حسب النظام';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get themeSystem => 'حسب النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get navCommunity => 'المجتمع';

  @override
  String get navMe => 'أنا';

  @override
  String get meTitle => 'حسابي';

  @override
  String get mePlaceholder => 'ستجد هنا قريبًا ملفك الشخصي ومنشوراتك المحفوظة وإعداداتك.';

  @override
  String get communityTitle => 'المجتمع';

  @override
  String communityGreeting(String username) {
    return 'مرحبًا، $username';
  }

  @override
  String get communityDisclaimer => 'المنشورات تجارب شخصية وليست نصائح طبية.';

  @override
  String get feedRecent => 'الأحدث';

  @override
  String get feedPopular => 'الأكثر تفاعلًا';

  @override
  String get feedFollowing => 'المتابَعون';

  @override
  String get categoryAll => 'الكل';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get feedEmptyTitle => 'لا يوجد شيء هنا بعد';

  @override
  String get feedEmptySubtitle => 'كن أول من يشارك شيئًا لطيفًا.';

  @override
  String get feedFollowingEmpty => 'ستظهر هنا منشورات الأعضاء الذين تتابعهم.';

  @override
  String get loadMoreFailed => 'تعذّر تحميل المزيد. اضغط للمحاولة مرة أخرى.';

  @override
  String get postTitle => 'منشور';

  @override
  String get postOnlyMe => 'أنت فقط من يرى هذا المنشور';

  @override
  String get postUnderReview => 'قيد المراجعة — أنت فقط من يراه حاليًا';

  @override
  String get postHiddenByModeration => 'أخفاه المشرفون — أنت فقط من يراه';

  @override
  String get edited => 'معدّل';

  @override
  String contentWarningLabel(String label) {
    return 'تنبيه محتوى: $label';
  }

  @override
  String get contentWarningBody => 'يتناول هذا المنشور موضوعًا قد تكون قراءته صعبة.';

  @override
  String get contentWarningShow => 'عرض المنشور';

  @override
  String get cwSelfHarm => 'إيذاء النفس';

  @override
  String get cwSuicide => 'الانتحار';

  @override
  String get cwEatingDisorder => 'اضطرابات الأكل';

  @override
  String get cwSubstanceUse => 'تعاطي المواد';

  @override
  String get cwAbuseTrauma => 'الإساءة أو الصدمة';

  @override
  String get cwSensitive => 'موضوع حساس';

  @override
  String get cwNone => 'بدون';

  @override
  String get reactionUnderstand => 'أفهمك';

  @override
  String get reactionSupport => 'أرسل لك الدعم';

  @override
  String get reactionNotAlone => 'لست وحدك';

  @override
  String get reactionProud => 'فخور بك';

  @override
  String get reactionThankYou => 'شكرًا لمشاركتك';

  @override
  String get reactAction => 'تفاعل';

  @override
  String get reactionsTitle => 'أرسل تفاعلًا داعمًا';

  @override
  String get removeReaction => 'إزالة تفاعلي';

  @override
  String reactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تفاعل',
      many: '$count تفاعلًا',
      few: '$count تفاعلات',
      two: 'تفاعلان',
      one: 'تفاعل واحد',
      zero: 'لا تفاعلات بعد',
    );
    return '$_temp0';
  }

  @override
  String commentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تعليق',
      many: '$count تعليقًا',
      few: '$count تعليقات',
      two: 'تعليقان',
      one: 'تعليق واحد',
      zero: 'تعليق',
    );
    return '$_temp0';
  }

  @override
  String get savePost => 'حفظ المنشور';

  @override
  String get unsavePost => 'إزالة من المحفوظات';

  @override
  String get commentsTitle => 'التعليقات';

  @override
  String get commentsEmpty => 'لا توجد تعليقات بعد. شارك كلمة طيبة.';

  @override
  String get commentsDisabled => 'التعليقات مغلقة على هذا المنشور.';

  @override
  String get commentHint => 'اكتب تعليقًا داعمًا…';

  @override
  String replyingTo(String username) {
    return 'ردًا على $username';
  }

  @override
  String get replyAction => 'رد';

  @override
  String viewReplies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عرض $count رد',
      many: 'عرض $count ردًا',
      few: 'عرض $count ردود',
      two: 'عرض ردّين',
      one: 'عرض ردّ واحد',
    );
    return '$_temp0';
  }

  @override
  String get hideReplies => 'إخفاء الردود';

  @override
  String get moreReplies => 'عرض المزيد من الردود';

  @override
  String get moreComments => 'عرض المزيد من التعليقات';

  @override
  String get commentRemoved => 'هذا التعليق غير متاح.';

  @override
  String get postAuthorBadge => 'الكاتب';

  @override
  String get sendComment => 'إرسال';

  @override
  String get cancelReply => 'إلغاء الرد';

  @override
  String get editComment => 'تعديل التعليق';

  @override
  String get deleteComment => 'حذف التعليق';

  @override
  String get deleteCommentConfirm => 'هل تريد حذف هذا التعليق؟';

  @override
  String get commentOptions => 'خيارات التعليق';

  @override
  String get postOptions => 'خيارات المنشور';

  @override
  String get editPost => 'تعديل المنشور';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get deletePostConfirmTitle => 'هل تريد حذف هذا المنشور؟';

  @override
  String get deletePostConfirmBody => 'سيُحذف لدى الجميع مع تعليقاته، ولا يمكن التراجع عن ذلك.';

  @override
  String get actionDelete => 'حذف';

  @override
  String get postDeleted => 'تم حذف منشورك.';

  @override
  String get postUnavailable => 'هذا المنشور لم يعد متاحًا.';

  @override
  String get composerNewTitle => 'منشور جديد';

  @override
  String get composerEditTitle => 'تعديل المنشور';

  @override
  String get composerBadge => 'منشور في المجتمع';

  @override
  String composerSubtitle(String username) {
    return 'تنشر باسم $username. هويتك الحقيقية لا تظهر أبدًا.';
  }

  @override
  String get composerCategory => 'التصنيف';

  @override
  String get composerContent => 'منشورك';

  @override
  String get composerContentHint => 'شارك قصتك أو فكرة أو سؤالًا…';

  @override
  String get composerContentWarning => 'تنبيه المحتوى';

  @override
  String get composerContentWarningHelp =>
      'إذا تناول منشورك موضوعًا صعبًا فأضف تنبيهًا، وسيبقى مموّهًا حتى يختار القارئ عرضه.';

  @override
  String get composerAllowComments => 'السماح بالتعليقات';

  @override
  String get composerHideFromCommunity => 'إخفاء عن المجتمع';

  @override
  String get composerHideFromCommunityHelp => 'لن يرى هذا المنشور أحد غيرك.';

  @override
  String get composerPublish => 'نشر';

  @override
  String get composerSaveChanges => 'حفظ التغييرات';

  @override
  String get composerCategoryRequired => 'يرجى اختيار تصنيف.';

  @override
  String get composerContentRequired => 'يرجى كتابة شيء لمشاركته.';

  @override
  String get postShared => 'تمت مشاركة منشورك.';

  @override
  String get postUpdated => 'تم تحديث منشورك.';

  @override
  String get crisisHint =>
      'إذا كنت في خطر الآن، يرجى التواصل مع خدمات الطوارئ المحلية أو مع شخص تثق به.';

  @override
  String get timeJustNow => 'الآن';

  @override
  String timeMinutes(int count) {
    return '$count د';
  }

  @override
  String timeHours(int count) {
    return '$count س';
  }

  @override
  String timeDays(int count) {
    return '$count ي';
  }

  @override
  String profileJoined(String date) {
    return 'انضم في $date';
  }

  @override
  String profileFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count متابع',
      many: '$count متابعًا',
      few: '$count متابعين',
      two: 'متابعان',
      one: 'متابع واحد',
      zero: 'لا متابعين',
    );
    return '$_temp0';
  }

  @override
  String profileFollowingCount(int count) {
    return 'يتابع $count';
  }

  @override
  String get profilePrivate => 'يحتفظ هذا العضو بتفاصيل ملفه بشكل خاص.';

  @override
  String get profileThisIsYou => 'هكذا يرى الآخرون ملفك.';

  @override
  String get profileFollowsYou => 'يتابعك';

  @override
  String get profilePostsTitle => 'المنشورات';

  @override
  String get profileNoPosts => 'لا توجد منشورات بعد.';

  @override
  String get profileBlockedNotice =>
      'لقد حظرت هذا العضو. لن يرى أيٌّ منكما منشورات الآخر أو تعليقاته.';

  @override
  String get followAction => 'متابعة';

  @override
  String get unfollowAction => 'تتابعه';

  @override
  String get profileOptions => 'خيارات الملف';

  @override
  String get blockMember => 'حظر العضو';

  @override
  String get unblockMember => 'إلغاء الحظر';

  @override
  String blockConfirmTitle(String username) {
    return 'حظر $username؟';
  }

  @override
  String get blockConfirmBody =>
      'لن يرى أيٌّ منكما منشورات الآخر أو تعليقاته أو ملفه، وستنتهي أي متابعة بينكما. لن يتم إشعاره.';

  @override
  String get memberBlocked => 'تم حظر العضو.';

  @override
  String get memberUnblocked => 'تم إلغاء حظر العضو.';

  @override
  String get reportMember => 'الإبلاغ عن العضو';

  @override
  String get reportPost => 'الإبلاغ عن المنشور';

  @override
  String get reportComment => 'الإبلاغ عن التعليق';

  @override
  String get reportTitle => 'ما المشكلة؟';

  @override
  String get reportSubtitle => 'بلاغك مجهول الهوية، وسيراجعه فريق الإشراف.';

  @override
  String get reportHarassment => 'تحرش أو تنمّر';

  @override
  String get reportDangerousMedical => 'نصائح طبية خطرة';

  @override
  String get reportSpam => 'محتوى مزعج (سبام)';

  @override
  String get reportSelfHarm => 'يشجع على إيذاء النفس';

  @override
  String get reportSuicidal => 'قد يكون شخص ما معرضًا لخطر الانتحار';

  @override
  String get reportOther => 'سبب آخر';

  @override
  String get reportDetails => 'أخبرنا بالمزيد';

  @override
  String get reportDetailsRequired => 'يرجى وصف المشكلة.';

  @override
  String get reportSubmit => 'إرسال البلاغ';

  @override
  String get crisisTitle => 'شكرًا لاهتمامك بغيرك';

  @override
  String get crisisBody =>
      'سيراجع المشرفون هذا البلاغ بأولوية. إذا كان أحدهم في خطر مباشر، يرجى التواصل مع خدمات الطوارئ المحلية. وإذا كنت أنت من يمر بوقت صعب، فقد يساعدك التواصل مع شخص تثق به.';

  @override
  String get actionOk => 'حسنًا';

  @override
  String get meSaved => 'المنشورات المحفوظة';

  @override
  String get meFollowers => 'المتابِعون';

  @override
  String get meFollowing => 'تتابعهم';

  @override
  String get meBlocked => 'الأعضاء المحظورون';

  @override
  String get meViewProfile => 'عرض ملفي العام';

  @override
  String get savedEmpty => 'تظهر هنا المنشورات التي تحفظها، ولا يراها أحد غيرك.';

  @override
  String get followersEmpty => 'لا يوجد متابعون بعد.';

  @override
  String get followingEmpty => 'أنت لا تتابع أحدًا بعد.';

  @override
  String get blockedEmpty => 'لم تحظر أحدًا.';

  @override
  String get searchTitle => 'البحث';

  @override
  String get searchHint => 'ابحث في المنشورات أو الأشخاص أو #الوسوم';

  @override
  String get searchPosts => 'المنشورات';

  @override
  String get searchPeople => 'الأشخاص';

  @override
  String get searchHashtags => 'الوسوم';

  @override
  String get searchTooShort => 'اكتب حرفين على الأقل.';

  @override
  String get searchNoResults => 'لا توجد نتائج. جرّب كلمات أخرى.';

  @override
  String get trendingTitle => 'الأكثر تداولًا هذا الأسبوع';

  @override
  String get trendingEmpty => 'لا يوجد شيء رائج بعد.';

  @override
  String hashtagPostsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منشور',
      many: '$count منشورًا',
      few: '$count منشورات',
      two: 'منشوران',
      one: 'منشور واحد',
    );
    return '$_temp0';
  }

  @override
  String get navTrack => 'متابعتي';

  @override
  String get trackTitle => 'تسجيلاتك';

  @override
  String get trackPrivate => 'لا يراه أحد غيرك، ولا يُشارك مع المجتمع أبدًا.';

  @override
  String get checkInPrompt => 'كيف تشعر اليوم؟';

  @override
  String get checkInPromptBody => 'تسجيل سريع يساعدك على ملاحظة الأنماط مع الوقت.';

  @override
  String get checkInAction => 'سجّل الآن';

  @override
  String get checkInAgain => 'أضف تسجيلًا آخر';

  @override
  String todayYouFelt(String mood) {
    return 'آخر تسجيل: $mood';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count يوم متتالٍ',
      many: '$count يومًا متتاليًا',
      few: '$count أيام متتالية',
      two: 'يومان متتاليان',
      one: 'يوم واحد متتالٍ',
      zero: 'لا توجد سلسلة بعد',
    );
    return '$_temp0';
  }

  @override
  String totalCheckIns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تسجيل',
      many: '$count تسجيلًا',
      few: '$count تسجيلات',
      two: 'تسجيلان',
      one: 'تسجيل واحد',
      zero: 'لا تسجيلات',
    );
    return '$_temp0';
  }

  @override
  String get lastSevenDays => 'آخر 7 أيام';

  @override
  String get averagesTitle => 'متوسطات 7 أيام';

  @override
  String get avgMood => 'المزاج';

  @override
  String get avgStress => 'التوتر';

  @override
  String get avgSleep => 'النوم';

  @override
  String hoursShort(String hours) {
    return '$hours س';
  }

  @override
  String get noValue => '—';

  @override
  String get logSymptom => 'سجّل عَرَضًا';

  @override
  String get logSleep => 'سجّل نومك';

  @override
  String get historyTitle => 'السجل';

  @override
  String get seeHistory => 'عرض السجل';

  @override
  String get insightsTitle => 'ملاحظات';

  @override
  String get seeAllInsights => 'عرض كل الملاحظات';

  @override
  String get insightsEmpty => 'واصل التسجيل — ستظهر الملاحظات عندما تتوفر بيانات كافية.';

  @override
  String get insightsRefreshing => 'يجري تجهيز ملاحظاتك…';

  @override
  String get topSymptomsTitle => 'الأعراض الأكثر تسجيلًا (30 يومًا)';

  @override
  String get checkInTitle => 'تسجيل يومي';

  @override
  String get checkInEditTitle => 'تعديل التسجيل';

  @override
  String get checkInBadge => 'خاص';

  @override
  String get moodQuestion => 'بشكل عام، كيف تشعر؟';

  @override
  String get moodRequired => 'يرجى اختيار شعورك.';

  @override
  String get moodVerySad => 'حزين جدًا';

  @override
  String get moodSad => 'حزين';

  @override
  String get moodNeutral => 'محايد';

  @override
  String get moodGood => 'جيد';

  @override
  String get moodVeryGood => 'جيد جدًا';

  @override
  String get detailsOptional => 'تفاصيل إضافية (اختياري)';

  @override
  String get scaleMood => 'درجة المزاج';

  @override
  String get scaleAnxiety => 'القلق';

  @override
  String get scaleStress => 'التوتر';

  @override
  String get scaleEnergy => 'الطاقة';

  @override
  String get scaleSleepQuality => 'جودة النوم';

  @override
  String get scaleSeverity => 'ما مدى شدته؟';

  @override
  String get scaleAdd => 'إضافة';

  @override
  String scaleClear(String label) {
    return 'مسح $label';
  }

  @override
  String scaleValue(int value) {
    return '$value من 10';
  }

  @override
  String get privateNotes => 'ملاحظات خاصة';

  @override
  String get privateNotesHint => 'أي شيء تريد تذكّره (لا يراه أحد غيرك)';

  @override
  String get saveEntry => 'حفظ';

  @override
  String get entrySaved => 'تم الحفظ.';

  @override
  String get deleteEntry => 'حذف السجل';

  @override
  String get deleteEntryConfirm => 'هل تريد حذف هذا السجل؟ لا يمكن التراجع عن ذلك.';

  @override
  String get entryDeleted => 'تم حذف السجل.';

  @override
  String get symptomTitle => 'تسجيل عَرَض';

  @override
  String get symptomEditTitle => 'تعديل العَرَض';

  @override
  String get symptomWhich => 'ما الذي تلاحظه؟';

  @override
  String get symptomRequired => 'يرجى اختيار عَرَض.';

  @override
  String get durationTitle => 'كم استمر؟ (اختياري)';

  @override
  String durationMinutes(int count) {
    return '$count د';
  }

  @override
  String durationHours(int count) {
    return '$count س';
  }

  @override
  String get durationNotSure => 'لست متأكدًا';

  @override
  String get sleepTitle => 'تسجيل النوم';

  @override
  String get sleepEditTitle => 'تعديل النوم';

  @override
  String get sleepHowLong => 'كم ساعة نمت؟';

  @override
  String sleepHoursValue(String hours) {
    return '$hours ساعات';
  }

  @override
  String get historyMoods => 'المزاج';

  @override
  String get historySymptoms => 'الأعراض';

  @override
  String get historySleep => 'النوم';

  @override
  String get historyEmpty => 'لا يوجد تسجيل في هذا الشهر.';

  @override
  String get previousMonth => 'الشهر السابق';

  @override
  String get nextMonth => 'الشهر التالي';

  @override
  String severityValue(int value) {
    return 'الشدة $value/10';
  }

  @override
  String qualityValue(int value) {
    return 'الجودة $value/10';
  }
}
