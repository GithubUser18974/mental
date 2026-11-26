// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Y';

  @override
  String get welcomeTitle => 'A safe space to be heard';

  @override
  String get welcomeSubtitle =>
      'Share anonymously, connect with people who understand, and gently track how you feel.';

  @override
  String get getStarted => 'Get started';

  @override
  String get signIn => 'I already have an account';

  @override
  String get homeTitle => 'Home';

  @override
  String get homePlaceholder => 'Your space is being prepared. Features arrive in the next tasks.';

  @override
  String homeGreeting(String username) {
    return 'Hi, $username';
  }

  @override
  String get onboardingPurposeTitle => 'A gentle space for your mind';

  @override
  String get onboardingPurposeBody =>
      'Y helps you express yourself, feel less alone and understand your wellbeing. It doesn\'t replace professional care.';

  @override
  String get onboardingAnonymousTitle => 'You\'re anonymous here';

  @override
  String get onboardingAnonymousBody =>
      'Other members only see a pseudonym and an avatar. Your email and real identity are never shown.';

  @override
  String get onboardingTrackingTitle => 'Notice how you\'re doing';

  @override
  String get onboardingTrackingBody =>
      'Privately track your mood, sleep, medications and thoughts, and see patterns over time.';

  @override
  String get onboardingPrivacyTitle => 'Your data stays yours';

  @override
  String get onboardingPrivacyBody =>
      'Health information is private by default. Nothing is shared unless you choose to share it.';

  @override
  String get onboardingGuidelinesTitle => 'Kindness first';

  @override
  String get onboardingGuidelinesBody =>
      'Be supportive, respect each other\'s privacy, and don\'t present advice as medical fact. If you\'re in danger, contact local emergency services.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingFinish => 'Create my space';

  @override
  String onboardingPage(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldConfirmPassword => 'Confirm password';

  @override
  String get fieldNewPassword => 'New password';

  @override
  String get passwordHint => 'At least 10 characters, with letters and numbers';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get validationEmailRequired => 'Please enter your email.';

  @override
  String get validationEmailInvalid => 'Please enter a valid email address.';

  @override
  String get validationPasswordRequired => 'Please enter your password.';

  @override
  String get validationPasswordRules =>
      'Use at least 10 characters, including letters and numbers.';

  @override
  String get validationPasswordMismatch => 'Passwords don\'t match.';

  @override
  String get validationAgeRequired => 'You must be 18 or older to use Y.';

  @override
  String get validationTermsRequired => 'Please accept to continue.';

  @override
  String get registerTitle => 'Create your account';

  @override
  String get registerSubtitle => 'Your email stays private — it\'s only used to sign in.';

  @override
  String get ageConfirmLabel => 'I am 18 years or older';

  @override
  String get termsLabel => 'I accept the Terms of Use and the Privacy Policy';

  @override
  String get registerSubmit => 'Create account';

  @override
  String get haveAccountPrompt => 'Already have an account?';

  @override
  String get signInLink => 'Sign in';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue.';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get forgotPasswordLink => 'Forgot password?';

  @override
  String get noAccountPrompt => 'New here?';

  @override
  String get createAccountLink => 'Create an account';

  @override
  String get forgotTitle => 'Reset your password';

  @override
  String get forgotSubtitle =>
      'Enter your email and we\'ll send you a link to choose a new password.';

  @override
  String get forgotSubmit => 'Send reset link';

  @override
  String get forgotSentTitle => 'Check your email';

  @override
  String forgotSentBody(String email) {
    return 'If an account exists for $email, a reset link is on its way. Open it on this phone to choose a new password.';
  }

  @override
  String get backToSignIn => 'Back to sign in';

  @override
  String get resetTitle => 'Choose a new password';

  @override
  String get resetSubtitle => 'Pick something you haven\'t used before.';

  @override
  String get resetSubmit => 'Save new password';

  @override
  String get resetDoneTitle => 'Password updated';

  @override
  String get resetDoneBody =>
      'You\'ve been signed out on all devices. Sign in with your new password.';

  @override
  String get resetInvalidLink => 'This reset link is incomplete. Please request a new one.';

  @override
  String get setupBadge => 'Your profile';

  @override
  String setupStep(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get setupProfileTitle => 'How you\'ll appear';

  @override
  String get setupProfileSubtitle => 'Other members only see this — never your email or real name.';

  @override
  String get fieldUsername => 'Username';

  @override
  String get usernameHelper => '3–20 letters, numbers or _';

  @override
  String get usernameChecking => 'Checking…';

  @override
  String get usernameAvailable => 'Available';

  @override
  String get usernameTaken => 'Already taken';

  @override
  String get usernameReserved => 'Not available — please choose another';

  @override
  String get usernameInvalid => '3–20 characters: letters, numbers and _, starting with a letter';

  @override
  String get shuffleUsername => 'Suggest another name';

  @override
  String get fieldAvatar => 'Avatar';

  @override
  String avatarOption(int number) {
    return 'Avatar $number';
  }

  @override
  String get fieldBio => 'About you (optional)';

  @override
  String get bioHint => 'A few words you\'re comfortable sharing';

  @override
  String get setupNext => 'Continue';

  @override
  String get setupPrivacyTitle => 'Your privacy';

  @override
  String get setupPrivacySubtitle => 'You can change these anytime in settings.';

  @override
  String get privacyVisibilityLabel => 'Profile visibility';

  @override
  String get privacyVisibilityPublic => 'Public';

  @override
  String get privacyVisibilityPublicDesc => 'Members can see your bio.';

  @override
  String get privacyVisibilityPrivate => 'Private';

  @override
  String get privacyVisibilityPrivateDesc => 'Members only see your username and avatar.';

  @override
  String get privacyFollowLabel => 'Who can follow you';

  @override
  String get privacyFollowEveryone => 'Everyone';

  @override
  String get privacyFollowNobody => 'No one';

  @override
  String get privacyAnalyticsLabel => 'Share anonymous usage statistics';

  @override
  String get privacyAnalyticsDesc => 'Helps us improve Y. Never includes your health data.';

  @override
  String get privacyHealthNote => 'Your moods, medications and journal are always private.';

  @override
  String get setupFinish => 'Finish';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionBack => 'Back';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionSave => 'Save';

  @override
  String get actionSignOut => 'Sign out';

  @override
  String get loading => 'Loading…';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get emptySubtitle => 'When there is something to show, you\'ll find it here.';

  @override
  String get offlineBanner => 'You\'re offline. Some things may not be up to date.';

  @override
  String get errorNetwork => 'We couldn\'t connect. Please check your internet connection.';

  @override
  String get errorTimeout => 'This is taking longer than usual. Please try again.';

  @override
  String get errorUnauthorized => 'Your session has ended. Please sign in again.';

  @override
  String get errorForbidden => 'You don\'t have access to this.';

  @override
  String get errorNotFound => 'We couldn\'t find what you were looking for.';

  @override
  String get errorValidation => 'Please check the highlighted fields.';

  @override
  String get errorRateLimited => 'You\'re doing that a little too often. Please wait a moment.';

  @override
  String get errorServer => 'Something went wrong on our side. Please try again later.';

  @override
  String get errorUnknown => 'Something unexpected happened. Please try again.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Appearance';

  @override
  String get languageSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'العربية';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get navCommunity => 'Community';

  @override
  String get navMe => 'Me';

  @override
  String get meTitle => 'Me';

  @override
  String get mePlaceholder => 'Your profile, saved posts and settings will live here soon.';

  @override
  String get communityTitle => 'Community';

  @override
  String communityGreeting(String username) {
    return 'Hi, $username';
  }

  @override
  String get communityDisclaimer => 'Posts share personal experiences, not medical advice.';

  @override
  String get feedRecent => 'Recent';

  @override
  String get feedPopular => 'Popular';

  @override
  String get feedFollowing => 'Following';

  @override
  String get categoryAll => 'All';

  @override
  String get createPost => 'Create post';

  @override
  String get feedEmptyTitle => 'Nothing here yet';

  @override
  String get feedEmptySubtitle => 'Be the first to share something kind.';

  @override
  String get feedFollowingEmpty => 'Posts from members you follow will appear here.';

  @override
  String get loadMoreFailed => 'Couldn\'t load more. Tap to try again.';

  @override
  String get postTitle => 'Post';

  @override
  String get postOnlyMe => 'Only you can see this post';

  @override
  String get postUnderReview => 'Under review — only you can see it for now';

  @override
  String get postHiddenByModeration => 'Hidden by moderators — only you can see it';

  @override
  String get edited => 'edited';

  @override
  String contentWarningLabel(String label) {
    return 'Content warning: $label';
  }

  @override
  String get contentWarningBody => 'This post mentions a topic that may be difficult to read.';

  @override
  String get contentWarningShow => 'Show post';

  @override
  String get cwSelfHarm => 'Self-harm';

  @override
  String get cwSuicide => 'Suicide';

  @override
  String get cwEatingDisorder => 'Eating disorders';

  @override
  String get cwSubstanceUse => 'Substance use';

  @override
  String get cwAbuseTrauma => 'Abuse or trauma';

  @override
  String get cwSensitive => 'Sensitive topic';

  @override
  String get cwNone => 'None';

  @override
  String get reactionUnderstand => 'I understand you';

  @override
  String get reactionSupport => 'Sending support';

  @override
  String get reactionNotAlone => 'You\'re not alone';

  @override
  String get reactionProud => 'Proud of you';

  @override
  String get reactionThankYou => 'Thank you for sharing';

  @override
  String get reactAction => 'React';

  @override
  String get reactionsTitle => 'Send a supportive reaction';

  @override
  String get removeReaction => 'Remove my reaction';

  @override
  String reactionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reactions',
      one: '1 reaction',
      zero: 'No reactions yet',
    );
    return '$_temp0';
  }

  @override
  String commentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comments',
      one: '1 comment',
      zero: 'Comment',
    );
    return '$_temp0';
  }

  @override
  String get savePost => 'Save post';

  @override
  String get unsavePost => 'Remove from saved';

  @override
  String get commentsTitle => 'Comments';

  @override
  String get commentsEmpty => 'No comments yet. Offer a kind word.';

  @override
  String get commentsDisabled => 'Comments are turned off for this post.';

  @override
  String get commentHint => 'Write a supportive comment…';

  @override
  String replyingTo(String username) {
    return 'Replying to $username';
  }

  @override
  String get replyAction => 'Reply';

  @override
  String viewReplies(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'View $count replies',
      one: 'View 1 reply',
    );
    return '$_temp0';
  }

  @override
  String get hideReplies => 'Hide replies';

  @override
  String get moreReplies => 'Show more replies';

  @override
  String get moreComments => 'Show more comments';

  @override
  String get commentRemoved => 'This comment isn\'t available.';

  @override
  String get postAuthorBadge => 'Author';

  @override
  String get sendComment => 'Send';

  @override
  String get cancelReply => 'Cancel reply';

  @override
  String get editComment => 'Edit comment';

  @override
  String get deleteComment => 'Delete comment';

  @override
  String get deleteCommentConfirm => 'Delete this comment?';

  @override
  String get commentOptions => 'Comment options';

  @override
  String get postOptions => 'Post options';

  @override
  String get editPost => 'Edit post';

  @override
  String get deletePost => 'Delete post';

  @override
  String get deletePostConfirmTitle => 'Delete this post?';

  @override
  String get deletePostConfirmBody =>
      'It will be removed for everyone, together with its comments. This can\'t be undone.';

  @override
  String get actionDelete => 'Delete';

  @override
  String get postDeleted => 'Your post was deleted.';

  @override
  String get postUnavailable => 'This post isn\'t available anymore.';

  @override
  String get composerNewTitle => 'New post';

  @override
  String get composerEditTitle => 'Edit post';

  @override
  String get composerBadge => 'Community post';

  @override
  String composerSubtitle(String username) {
    return 'You\'re posting as $username. Your real identity is never shown.';
  }

  @override
  String get composerCategory => 'Category';

  @override
  String get composerContent => 'Your post';

  @override
  String get composerContentHint => 'Share your story, a thought or a question…';

  @override
  String get composerContentWarning => 'Content warning';

  @override
  String get composerContentWarningHelp =>
      'If your post mentions a difficult topic, add a warning. It stays blurred until someone chooses to read it.';

  @override
  String get composerAllowComments => 'Allow comments';

  @override
  String get composerHideFromCommunity => 'Hide from community';

  @override
  String get composerHideFromCommunityHelp => 'Only you will see this post.';

  @override
  String get composerPublish => 'Share post';

  @override
  String get composerSaveChanges => 'Save changes';

  @override
  String get composerCategoryRequired => 'Please choose a category.';

  @override
  String get composerContentRequired => 'Please write something to share.';

  @override
  String get postShared => 'Your post has been shared.';

  @override
  String get postUpdated => 'Your post has been updated.';

  @override
  String get crisisHint =>
      'If you\'re in danger right now, please contact local emergency services or someone you trust.';

  @override
  String get timeJustNow => 'just now';

  @override
  String timeMinutes(int count) {
    return '${count}m';
  }

  @override
  String timeHours(int count) {
    return '${count}h';
  }

  @override
  String timeDays(int count) {
    return '${count}d';
  }

  @override
  String profileJoined(String date) {
    return 'Joined $date';
  }

  @override
  String profileFollowers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count followers',
      one: '1 follower',
    );
    return '$_temp0';
  }

  @override
  String profileFollowingCount(int count) {
    return '$count following';
  }

  @override
  String get profilePrivate => 'This member keeps their profile details private.';

  @override
  String get profileThisIsYou => 'This is how others see your profile.';

  @override
  String get profileFollowsYou => 'Follows you';

  @override
  String get profilePostsTitle => 'Posts';

  @override
  String get profileNoPosts => 'No posts yet.';

  @override
  String get profileBlockedNotice =>
      'You blocked this member. You won\'t see each other\'s posts or comments.';

  @override
  String get followAction => 'Follow';

  @override
  String get unfollowAction => 'Following';

  @override
  String get profileOptions => 'Profile options';

  @override
  String get blockMember => 'Block member';

  @override
  String get unblockMember => 'Unblock';

  @override
  String blockConfirmTitle(String username) {
    return 'Block $username?';
  }

  @override
  String get blockConfirmBody =>
      'You won\'t see each other\'s posts, comments or profile, and any follows between you will end. They won\'t be notified.';

  @override
  String get memberBlocked => 'Member blocked.';

  @override
  String get memberUnblocked => 'Member unblocked.';

  @override
  String get reportMember => 'Report member';

  @override
  String get reportPost => 'Report post';

  @override
  String get reportComment => 'Report comment';

  @override
  String get reportTitle => 'What\'s wrong?';

  @override
  String get reportSubtitle => 'Your report is anonymous. Our moderators will review it.';

  @override
  String get reportHarassment => 'Harassment or bullying';

  @override
  String get reportDangerousMedical => 'Dangerous medical advice';

  @override
  String get reportSpam => 'Spam';

  @override
  String get reportSelfHarm => 'Encourages self-harm';

  @override
  String get reportSuicidal => 'Someone may be at risk of suicide';

  @override
  String get reportOther => 'Something else';

  @override
  String get reportDetails => 'Tell us more';

  @override
  String get reportDetailsRequired => 'Please describe the problem.';

  @override
  String get reportSubmit => 'Send report';

  @override
  String get crisisTitle => 'Thank you for looking out for someone';

  @override
  String get crisisBody =>
      'Our moderators will review this as a priority. If someone is in immediate danger, please contact local emergency services. If it\'s you who is struggling, reaching out to someone you trust can help.';

  @override
  String get actionOk => 'OK';

  @override
  String get meSaved => 'Saved posts';

  @override
  String get meFollowers => 'Followers';

  @override
  String get meFollowing => 'Following';

  @override
  String get meBlocked => 'Blocked members';

  @override
  String get meViewProfile => 'View my public profile';

  @override
  String get savedEmpty => 'Posts you save appear here. Only you can see them.';

  @override
  String get followersEmpty => 'No followers yet.';

  @override
  String get followingEmpty => 'You\'re not following anyone yet.';

  @override
  String get blockedEmpty => 'You haven\'t blocked anyone.';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search posts, people or #hashtags';

  @override
  String get searchPosts => 'Posts';

  @override
  String get searchPeople => 'People';

  @override
  String get searchHashtags => 'Hashtags';

  @override
  String get searchTooShort => 'Type at least 2 characters.';

  @override
  String get searchNoResults => 'No results. Try different words.';

  @override
  String get trendingTitle => 'Trending this week';

  @override
  String get trendingEmpty => 'Nothing trending yet.';

  @override
  String hashtagPostsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count posts',
      one: '1 post',
    );
    return '$_temp0';
  }
}
