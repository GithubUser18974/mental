import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('ar'), Locale('en')];

  /// App display name. Do not translate.
  ///
  /// In en, this message translates to:
  /// **'Y'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'A safe space to be heard'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share anonymously, connect with people who understand, and gently track how you feel.'**
  String get welcomeSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'I already have an account'**
  String get signIn;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your space is being prepared. Features arrive in the next tasks.'**
  String get homePlaceholder;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {username}'**
  String homeGreeting(String username);

  /// No description provided for @onboardingPurposeTitle.
  ///
  /// In en, this message translates to:
  /// **'A gentle space for your mind'**
  String get onboardingPurposeTitle;

  /// No description provided for @onboardingPurposeBody.
  ///
  /// In en, this message translates to:
  /// **'Y helps you express yourself, feel less alone and understand your wellbeing. It doesn\'t replace professional care.'**
  String get onboardingPurposeBody;

  /// No description provided for @onboardingAnonymousTitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re anonymous here'**
  String get onboardingAnonymousTitle;

  /// No description provided for @onboardingAnonymousBody.
  ///
  /// In en, this message translates to:
  /// **'Other members only see a pseudonym and an avatar. Your email and real identity are never shown.'**
  String get onboardingAnonymousBody;

  /// No description provided for @onboardingTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Notice how you\'re doing'**
  String get onboardingTrackingTitle;

  /// No description provided for @onboardingTrackingBody.
  ///
  /// In en, this message translates to:
  /// **'Privately track your mood, sleep, medications and thoughts, and see patterns over time.'**
  String get onboardingTrackingBody;

  /// No description provided for @onboardingPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your data stays yours'**
  String get onboardingPrivacyTitle;

  /// No description provided for @onboardingPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Health information is private by default. Nothing is shared unless you choose to share it.'**
  String get onboardingPrivacyBody;

  /// No description provided for @onboardingGuidelinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Kindness first'**
  String get onboardingGuidelinesTitle;

  /// No description provided for @onboardingGuidelinesBody.
  ///
  /// In en, this message translates to:
  /// **'Be supportive, respect each other\'s privacy, and don\'t present advice as medical fact. If you\'re in danger, contact local emergency services.'**
  String get onboardingGuidelinesBody;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingFinish.
  ///
  /// In en, this message translates to:
  /// **'Create my space'**
  String get onboardingFinish;

  /// No description provided for @onboardingPage.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String onboardingPage(int current, int total);

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @fieldPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get fieldPassword;

  /// No description provided for @fieldConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get fieldConfirmPassword;

  /// No description provided for @fieldNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get fieldNewPassword;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 10 characters, with letters and numbers'**
  String get passwordHint;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @validationEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password.'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordRules.
  ///
  /// In en, this message translates to:
  /// **'Use at least 10 characters, including letters and numbers.'**
  String get validationPasswordRules;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match.'**
  String get validationPasswordMismatch;

  /// No description provided for @validationAgeRequired.
  ///
  /// In en, this message translates to:
  /// **'You must be 18 or older to use Y.'**
  String get validationAgeRequired;

  /// No description provided for @validationTermsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please accept to continue.'**
  String get validationTermsRequired;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your email stays private — it\'s only used to sign in.'**
  String get registerSubtitle;

  /// No description provided for @ageConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'I am 18 years or older'**
  String get ageConfirmLabel;

  /// No description provided for @termsLabel.
  ///
  /// In en, this message translates to:
  /// **'I accept the Terms of Use and the Privacy Policy'**
  String get termsLabel;

  /// No description provided for @registerSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerSubmit;

  /// No description provided for @haveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get haveAccountPrompt;

  /// No description provided for @signInLink.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInLink;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue.'**
  String get loginSubtitle;

  /// No description provided for @loginSubmit.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginSubmit;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordLink;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'New here?'**
  String get noAccountPrompt;

  /// No description provided for @createAccountLink.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccountLink;

  /// No description provided for @forgotTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get forgotTitle;

  /// No description provided for @forgotSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a link to choose a new password.'**
  String get forgotSubtitle;

  /// No description provided for @forgotSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send reset link'**
  String get forgotSubmit;

  /// No description provided for @forgotSentTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get forgotSentTitle;

  /// No description provided for @forgotSentBody.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for {email}, a reset link is on its way. Open it on this phone to choose a new password.'**
  String forgotSentBody(String email);

  /// No description provided for @backToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Back to sign in'**
  String get backToSignIn;

  /// No description provided for @resetTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password'**
  String get resetTitle;

  /// No description provided for @resetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick something you haven\'t used before.'**
  String get resetSubtitle;

  /// No description provided for @resetSubmit.
  ///
  /// In en, this message translates to:
  /// **'Save new password'**
  String get resetSubmit;

  /// No description provided for @resetDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Password updated'**
  String get resetDoneTitle;

  /// No description provided for @resetDoneBody.
  ///
  /// In en, this message translates to:
  /// **'You\'ve been signed out on all devices. Sign in with your new password.'**
  String get resetDoneBody;

  /// No description provided for @resetInvalidLink.
  ///
  /// In en, this message translates to:
  /// **'This reset link is incomplete. Please request a new one.'**
  String get resetInvalidLink;

  /// No description provided for @setupBadge.
  ///
  /// In en, this message translates to:
  /// **'Your profile'**
  String get setupBadge;

  /// No description provided for @setupStep.
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String setupStep(int current, int total);

  /// No description provided for @setupProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'How you\'ll appear'**
  String get setupProfileTitle;

  /// No description provided for @setupProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Other members only see this — never your email or real name.'**
  String get setupProfileSubtitle;

  /// No description provided for @fieldUsername.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get fieldUsername;

  /// No description provided for @usernameHelper.
  ///
  /// In en, this message translates to:
  /// **'3–20 letters, numbers or _'**
  String get usernameHelper;

  /// No description provided for @usernameChecking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get usernameChecking;

  /// No description provided for @usernameAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get usernameAvailable;

  /// No description provided for @usernameTaken.
  ///
  /// In en, this message translates to:
  /// **'Already taken'**
  String get usernameTaken;

  /// No description provided for @usernameReserved.
  ///
  /// In en, this message translates to:
  /// **'Not available — please choose another'**
  String get usernameReserved;

  /// No description provided for @usernameInvalid.
  ///
  /// In en, this message translates to:
  /// **'3–20 characters: letters, numbers and _, starting with a letter'**
  String get usernameInvalid;

  /// No description provided for @shuffleUsername.
  ///
  /// In en, this message translates to:
  /// **'Suggest another name'**
  String get shuffleUsername;

  /// No description provided for @fieldAvatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get fieldAvatar;

  /// No description provided for @avatarOption.
  ///
  /// In en, this message translates to:
  /// **'Avatar {number}'**
  String avatarOption(int number);

  /// No description provided for @fieldBio.
  ///
  /// In en, this message translates to:
  /// **'About you (optional)'**
  String get fieldBio;

  /// No description provided for @bioHint.
  ///
  /// In en, this message translates to:
  /// **'A few words you\'re comfortable sharing'**
  String get bioHint;

  /// No description provided for @setupNext.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get setupNext;

  /// No description provided for @setupPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your privacy'**
  String get setupPrivacyTitle;

  /// No description provided for @setupPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can change these anytime in settings.'**
  String get setupPrivacySubtitle;

  /// No description provided for @privacyVisibilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile visibility'**
  String get privacyVisibilityLabel;

  /// No description provided for @privacyVisibilityPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get privacyVisibilityPublic;

  /// No description provided for @privacyVisibilityPublicDesc.
  ///
  /// In en, this message translates to:
  /// **'Members can see your bio.'**
  String get privacyVisibilityPublicDesc;

  /// No description provided for @privacyVisibilityPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get privacyVisibilityPrivate;

  /// No description provided for @privacyVisibilityPrivateDesc.
  ///
  /// In en, this message translates to:
  /// **'Members only see your username and avatar.'**
  String get privacyVisibilityPrivateDesc;

  /// No description provided for @privacyFollowLabel.
  ///
  /// In en, this message translates to:
  /// **'Who can follow you'**
  String get privacyFollowLabel;

  /// No description provided for @privacyFollowEveryone.
  ///
  /// In en, this message translates to:
  /// **'Everyone'**
  String get privacyFollowEveryone;

  /// No description provided for @privacyFollowNobody.
  ///
  /// In en, this message translates to:
  /// **'No one'**
  String get privacyFollowNobody;

  /// No description provided for @privacyAnalyticsLabel.
  ///
  /// In en, this message translates to:
  /// **'Share anonymous usage statistics'**
  String get privacyAnalyticsLabel;

  /// No description provided for @privacyAnalyticsDesc.
  ///
  /// In en, this message translates to:
  /// **'Helps us improve Y. Never includes your health data.'**
  String get privacyAnalyticsDesc;

  /// No description provided for @privacyHealthNote.
  ///
  /// In en, this message translates to:
  /// **'Your moods, medications and journal are always private.'**
  String get privacyHealthNote;

  /// No description provided for @setupFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get setupFinish;

  /// No description provided for @actionContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get actionSignOut;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loading;

  /// No description provided for @emptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get emptyTitle;

  /// No description provided for @emptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'When there is something to show, you\'ll find it here.'**
  String get emptySubtitle;

  /// No description provided for @offlineBanner.
  ///
  /// In en, this message translates to:
  /// **'You\'re offline. Some things may not be up to date.'**
  String get offlineBanner;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t connect. Please check your internet connection.'**
  String get errorNetwork;

  /// No description provided for @errorTimeout.
  ///
  /// In en, this message translates to:
  /// **'This is taking longer than usual. Please try again.'**
  String get errorTimeout;

  /// No description provided for @errorUnauthorized.
  ///
  /// In en, this message translates to:
  /// **'Your session has ended. Please sign in again.'**
  String get errorUnauthorized;

  /// No description provided for @errorForbidden.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have access to this.'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find what you were looking for.'**
  String get errorNotFound;

  /// No description provided for @errorValidation.
  ///
  /// In en, this message translates to:
  /// **'Please check the highlighted fields.'**
  String get errorValidation;

  /// No description provided for @errorRateLimited.
  ///
  /// In en, this message translates to:
  /// **'You\'re doing that a little too often. Please wait a moment.'**
  String get errorRateLimited;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our side. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'Something unexpected happened. Please try again.'**
  String get errorUnknown;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsTheme;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get languageSystem;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @navCommunity.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get navCommunity;

  /// No description provided for @navMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get navMe;

  /// No description provided for @meTitle.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get meTitle;

  /// No description provided for @mePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your profile, saved posts and settings will live here soon.'**
  String get mePlaceholder;

  /// No description provided for @communityTitle.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get communityTitle;

  /// No description provided for @communityGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {username}'**
  String communityGreeting(String username);

  /// No description provided for @communityDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Posts share personal experiences, not medical advice.'**
  String get communityDisclaimer;

  /// No description provided for @feedRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get feedRecent;

  /// No description provided for @feedPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get feedPopular;

  /// No description provided for @feedFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get feedFollowing;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @createPost.
  ///
  /// In en, this message translates to:
  /// **'Create post'**
  String get createPost;

  /// No description provided for @feedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get feedEmptyTitle;

  /// No description provided for @feedEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Be the first to share something kind.'**
  String get feedEmptySubtitle;

  /// No description provided for @feedFollowingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Posts from members you follow will appear here.'**
  String get feedFollowingEmpty;

  /// No description provided for @loadMoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load more. Tap to try again.'**
  String get loadMoreFailed;

  /// No description provided for @postTitle.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get postTitle;

  /// No description provided for @postOnlyMe.
  ///
  /// In en, this message translates to:
  /// **'Only you can see this post'**
  String get postOnlyMe;

  /// No description provided for @postUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under review — only you can see it for now'**
  String get postUnderReview;

  /// No description provided for @postHiddenByModeration.
  ///
  /// In en, this message translates to:
  /// **'Hidden by moderators — only you can see it'**
  String get postHiddenByModeration;

  /// No description provided for @edited.
  ///
  /// In en, this message translates to:
  /// **'edited'**
  String get edited;

  /// No description provided for @contentWarningLabel.
  ///
  /// In en, this message translates to:
  /// **'Content warning: {label}'**
  String contentWarningLabel(String label);

  /// No description provided for @contentWarningBody.
  ///
  /// In en, this message translates to:
  /// **'This post mentions a topic that may be difficult to read.'**
  String get contentWarningBody;

  /// No description provided for @contentWarningShow.
  ///
  /// In en, this message translates to:
  /// **'Show post'**
  String get contentWarningShow;

  /// No description provided for @cwSelfHarm.
  ///
  /// In en, this message translates to:
  /// **'Self-harm'**
  String get cwSelfHarm;

  /// No description provided for @cwSuicide.
  ///
  /// In en, this message translates to:
  /// **'Suicide'**
  String get cwSuicide;

  /// No description provided for @cwEatingDisorder.
  ///
  /// In en, this message translates to:
  /// **'Eating disorders'**
  String get cwEatingDisorder;

  /// No description provided for @cwSubstanceUse.
  ///
  /// In en, this message translates to:
  /// **'Substance use'**
  String get cwSubstanceUse;

  /// No description provided for @cwAbuseTrauma.
  ///
  /// In en, this message translates to:
  /// **'Abuse or trauma'**
  String get cwAbuseTrauma;

  /// No description provided for @cwSensitive.
  ///
  /// In en, this message translates to:
  /// **'Sensitive topic'**
  String get cwSensitive;

  /// No description provided for @cwNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get cwNone;

  /// No description provided for @reactionUnderstand.
  ///
  /// In en, this message translates to:
  /// **'I understand you'**
  String get reactionUnderstand;

  /// No description provided for @reactionSupport.
  ///
  /// In en, this message translates to:
  /// **'Sending support'**
  String get reactionSupport;

  /// No description provided for @reactionNotAlone.
  ///
  /// In en, this message translates to:
  /// **'You\'re not alone'**
  String get reactionNotAlone;

  /// No description provided for @reactionProud.
  ///
  /// In en, this message translates to:
  /// **'Proud of you'**
  String get reactionProud;

  /// No description provided for @reactionThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for sharing'**
  String get reactionThankYou;

  /// No description provided for @reactAction.
  ///
  /// In en, this message translates to:
  /// **'React'**
  String get reactAction;

  /// No description provided for @reactionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Send a supportive reaction'**
  String get reactionsTitle;

  /// No description provided for @removeReaction.
  ///
  /// In en, this message translates to:
  /// **'Remove my reaction'**
  String get removeReaction;

  /// No description provided for @reactionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No reactions yet} =1{1 reaction} other{{count} reactions}}'**
  String reactionsCount(int count);

  /// No description provided for @commentsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Comment} =1{1 comment} other{{count} comments}}'**
  String commentsCount(int count);

  /// No description provided for @savePost.
  ///
  /// In en, this message translates to:
  /// **'Save post'**
  String get savePost;

  /// No description provided for @unsavePost.
  ///
  /// In en, this message translates to:
  /// **'Remove from saved'**
  String get unsavePost;

  /// No description provided for @commentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsTitle;

  /// No description provided for @commentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No comments yet. Offer a kind word.'**
  String get commentsEmpty;

  /// No description provided for @commentsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Comments are turned off for this post.'**
  String get commentsDisabled;

  /// No description provided for @commentHint.
  ///
  /// In en, this message translates to:
  /// **'Write a supportive comment…'**
  String get commentHint;

  /// No description provided for @replyingTo.
  ///
  /// In en, this message translates to:
  /// **'Replying to {username}'**
  String replyingTo(String username);

  /// No description provided for @replyAction.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get replyAction;

  /// No description provided for @viewReplies.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{View 1 reply} other{View {count} replies}}'**
  String viewReplies(int count);

  /// No description provided for @hideReplies.
  ///
  /// In en, this message translates to:
  /// **'Hide replies'**
  String get hideReplies;

  /// No description provided for @moreReplies.
  ///
  /// In en, this message translates to:
  /// **'Show more replies'**
  String get moreReplies;

  /// No description provided for @moreComments.
  ///
  /// In en, this message translates to:
  /// **'Show more comments'**
  String get moreComments;

  /// No description provided for @commentRemoved.
  ///
  /// In en, this message translates to:
  /// **'This comment isn\'t available.'**
  String get commentRemoved;

  /// No description provided for @postAuthorBadge.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get postAuthorBadge;

  /// No description provided for @sendComment.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendComment;

  /// No description provided for @cancelReply.
  ///
  /// In en, this message translates to:
  /// **'Cancel reply'**
  String get cancelReply;

  /// No description provided for @editComment.
  ///
  /// In en, this message translates to:
  /// **'Edit comment'**
  String get editComment;

  /// No description provided for @deleteComment.
  ///
  /// In en, this message translates to:
  /// **'Delete comment'**
  String get deleteComment;

  /// No description provided for @deleteCommentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this comment?'**
  String get deleteCommentConfirm;

  /// No description provided for @commentOptions.
  ///
  /// In en, this message translates to:
  /// **'Comment options'**
  String get commentOptions;

  /// No description provided for @postOptions.
  ///
  /// In en, this message translates to:
  /// **'Post options'**
  String get postOptions;

  /// No description provided for @editPost.
  ///
  /// In en, this message translates to:
  /// **'Edit post'**
  String get editPost;

  /// No description provided for @deletePost.
  ///
  /// In en, this message translates to:
  /// **'Delete post'**
  String get deletePost;

  /// No description provided for @deletePostConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this post?'**
  String get deletePostConfirmTitle;

  /// No description provided for @deletePostConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'It will be removed for everyone, together with its comments. This can\'t be undone.'**
  String get deletePostConfirmBody;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @postDeleted.
  ///
  /// In en, this message translates to:
  /// **'Your post was deleted.'**
  String get postDeleted;

  /// No description provided for @postUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This post isn\'t available anymore.'**
  String get postUnavailable;

  /// No description provided for @composerNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New post'**
  String get composerNewTitle;

  /// No description provided for @composerEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit post'**
  String get composerEditTitle;

  /// No description provided for @composerBadge.
  ///
  /// In en, this message translates to:
  /// **'Community post'**
  String get composerBadge;

  /// No description provided for @composerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re posting as {username}. Your real identity is never shown.'**
  String composerSubtitle(String username);

  /// No description provided for @composerCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get composerCategory;

  /// No description provided for @composerContent.
  ///
  /// In en, this message translates to:
  /// **'Your post'**
  String get composerContent;

  /// No description provided for @composerContentHint.
  ///
  /// In en, this message translates to:
  /// **'Share your story, a thought or a question…'**
  String get composerContentHint;

  /// No description provided for @composerContentWarning.
  ///
  /// In en, this message translates to:
  /// **'Content warning'**
  String get composerContentWarning;

  /// No description provided for @composerContentWarningHelp.
  ///
  /// In en, this message translates to:
  /// **'If your post mentions a difficult topic, add a warning. It stays blurred until someone chooses to read it.'**
  String get composerContentWarningHelp;

  /// No description provided for @composerAllowComments.
  ///
  /// In en, this message translates to:
  /// **'Allow comments'**
  String get composerAllowComments;

  /// No description provided for @composerHideFromCommunity.
  ///
  /// In en, this message translates to:
  /// **'Hide from community'**
  String get composerHideFromCommunity;

  /// No description provided for @composerHideFromCommunityHelp.
  ///
  /// In en, this message translates to:
  /// **'Only you will see this post.'**
  String get composerHideFromCommunityHelp;

  /// No description provided for @composerPublish.
  ///
  /// In en, this message translates to:
  /// **'Share post'**
  String get composerPublish;

  /// No description provided for @composerSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get composerSaveChanges;

  /// No description provided for @composerCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Please choose a category.'**
  String get composerCategoryRequired;

  /// No description provided for @composerContentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please write something to share.'**
  String get composerContentRequired;

  /// No description provided for @postShared.
  ///
  /// In en, this message translates to:
  /// **'Your post has been shared.'**
  String get postShared;

  /// No description provided for @postUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your post has been updated.'**
  String get postUpdated;

  /// No description provided for @crisisHint.
  ///
  /// In en, this message translates to:
  /// **'If you\'re in danger right now, please contact local emergency services or someone you trust.'**
  String get crisisHint;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeJustNow;

  /// No description provided for @timeMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count}m'**
  String timeMinutes(int count);

  /// No description provided for @timeHours.
  ///
  /// In en, this message translates to:
  /// **'{count}h'**
  String timeHours(int count);

  /// No description provided for @timeDays.
  ///
  /// In en, this message translates to:
  /// **'{count}d'**
  String timeDays(int count);

  /// No description provided for @profileJoined.
  ///
  /// In en, this message translates to:
  /// **'Joined {date}'**
  String profileJoined(String date);

  /// No description provided for @profileFollowers.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 follower} other{{count} followers}}'**
  String profileFollowers(int count);

  /// No description provided for @profileFollowingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} following'**
  String profileFollowingCount(int count);

  /// No description provided for @profilePrivate.
  ///
  /// In en, this message translates to:
  /// **'This member keeps their profile details private.'**
  String get profilePrivate;

  /// No description provided for @profileThisIsYou.
  ///
  /// In en, this message translates to:
  /// **'This is how others see your profile.'**
  String get profileThisIsYou;

  /// No description provided for @profileFollowsYou.
  ///
  /// In en, this message translates to:
  /// **'Follows you'**
  String get profileFollowsYou;

  /// No description provided for @profilePostsTitle.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get profilePostsTitle;

  /// No description provided for @profileNoPosts.
  ///
  /// In en, this message translates to:
  /// **'No posts yet.'**
  String get profileNoPosts;

  /// No description provided for @profileBlockedNotice.
  ///
  /// In en, this message translates to:
  /// **'You blocked this member. You won\'t see each other\'s posts or comments.'**
  String get profileBlockedNotice;

  /// No description provided for @followAction.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get followAction;

  /// No description provided for @unfollowAction.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get unfollowAction;

  /// No description provided for @profileOptions.
  ///
  /// In en, this message translates to:
  /// **'Profile options'**
  String get profileOptions;

  /// No description provided for @blockMember.
  ///
  /// In en, this message translates to:
  /// **'Block member'**
  String get blockMember;

  /// No description provided for @unblockMember.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblockMember;

  /// No description provided for @blockConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Block {username}?'**
  String blockConfirmTitle(String username);

  /// No description provided for @blockConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You won\'t see each other\'s posts, comments or profile, and any follows between you will end. They won\'t be notified.'**
  String get blockConfirmBody;

  /// No description provided for @memberBlocked.
  ///
  /// In en, this message translates to:
  /// **'Member blocked.'**
  String get memberBlocked;

  /// No description provided for @memberUnblocked.
  ///
  /// In en, this message translates to:
  /// **'Member unblocked.'**
  String get memberUnblocked;

  /// No description provided for @reportMember.
  ///
  /// In en, this message translates to:
  /// **'Report member'**
  String get reportMember;

  /// No description provided for @reportPost.
  ///
  /// In en, this message translates to:
  /// **'Report post'**
  String get reportPost;

  /// No description provided for @reportComment.
  ///
  /// In en, this message translates to:
  /// **'Report comment'**
  String get reportComment;

  /// No description provided for @reportTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s wrong?'**
  String get reportTitle;

  /// No description provided for @reportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your report is anonymous. Our moderators will review it.'**
  String get reportSubtitle;

  /// No description provided for @reportHarassment.
  ///
  /// In en, this message translates to:
  /// **'Harassment or bullying'**
  String get reportHarassment;

  /// No description provided for @reportDangerousMedical.
  ///
  /// In en, this message translates to:
  /// **'Dangerous medical advice'**
  String get reportDangerousMedical;

  /// No description provided for @reportSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam'**
  String get reportSpam;

  /// No description provided for @reportSelfHarm.
  ///
  /// In en, this message translates to:
  /// **'Encourages self-harm'**
  String get reportSelfHarm;

  /// No description provided for @reportSuicidal.
  ///
  /// In en, this message translates to:
  /// **'Someone may be at risk of suicide'**
  String get reportSuicidal;

  /// No description provided for @reportOther.
  ///
  /// In en, this message translates to:
  /// **'Something else'**
  String get reportOther;

  /// No description provided for @reportDetails.
  ///
  /// In en, this message translates to:
  /// **'Tell us more'**
  String get reportDetails;

  /// No description provided for @reportDetailsRequired.
  ///
  /// In en, this message translates to:
  /// **'Please describe the problem.'**
  String get reportDetailsRequired;

  /// No description provided for @reportSubmit.
  ///
  /// In en, this message translates to:
  /// **'Send report'**
  String get reportSubmit;

  /// No description provided for @crisisTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for looking out for someone'**
  String get crisisTitle;

  /// No description provided for @crisisBody.
  ///
  /// In en, this message translates to:
  /// **'Our moderators will review this as a priority. If someone is in immediate danger, please contact local emergency services. If it\'s you who is struggling, reaching out to someone you trust can help.'**
  String get crisisBody;

  /// No description provided for @actionOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get actionOk;

  /// No description provided for @meSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved posts'**
  String get meSaved;

  /// No description provided for @meFollowers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get meFollowers;

  /// No description provided for @meFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get meFollowing;

  /// No description provided for @meBlocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked members'**
  String get meBlocked;

  /// No description provided for @meViewProfile.
  ///
  /// In en, this message translates to:
  /// **'View my public profile'**
  String get meViewProfile;

  /// No description provided for @savedEmpty.
  ///
  /// In en, this message translates to:
  /// **'Posts you save appear here. Only you can see them.'**
  String get savedEmpty;

  /// No description provided for @followersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No followers yet.'**
  String get followersEmpty;

  /// No description provided for @followingEmpty.
  ///
  /// In en, this message translates to:
  /// **'You\'re not following anyone yet.'**
  String get followingEmpty;

  /// No description provided for @blockedEmpty.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t blocked anyone.'**
  String get blockedEmpty;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search posts, people or #hashtags'**
  String get searchHint;

  /// No description provided for @searchPosts.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get searchPosts;

  /// No description provided for @searchPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get searchPeople;

  /// No description provided for @searchHashtags.
  ///
  /// In en, this message translates to:
  /// **'Hashtags'**
  String get searchHashtags;

  /// No description provided for @searchTooShort.
  ///
  /// In en, this message translates to:
  /// **'Type at least 2 characters.'**
  String get searchTooShort;

  /// No description provided for @searchNoResults.
  ///
  /// In en, this message translates to:
  /// **'No results. Try different words.'**
  String get searchNoResults;

  /// No description provided for @trendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Trending this week'**
  String get trendingTitle;

  /// No description provided for @trendingEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing trending yet.'**
  String get trendingEmpty;

  /// No description provided for @hashtagPostsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 post} other{{count} posts}}'**
  String hashtagPostsCount(int count);
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
