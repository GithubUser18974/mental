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

  @override
  String get navTrack => 'Track';

  @override
  String get trackTitle => 'Your check-ins';

  @override
  String get trackPrivate => 'Only you can see this. It\'s never shared with the community.';

  @override
  String get checkInPrompt => 'How are you feeling today?';

  @override
  String get checkInPromptBody => 'A quick check-in helps you notice patterns over time.';

  @override
  String get checkInAction => 'Check in';

  @override
  String get checkInAgain => 'Add another check-in';

  @override
  String todayYouFelt(String mood) {
    return 'Latest: $mood';
  }

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count-day streak',
      one: '1-day streak',
      zero: 'No streak yet',
    );
    return '$_temp0';
  }

  @override
  String totalCheckIns(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count check-ins',
      one: '1 check-in',
    );
    return '$_temp0';
  }

  @override
  String get lastSevenDays => 'Last 7 days';

  @override
  String get averagesTitle => '7-day averages';

  @override
  String get avgMood => 'Mood';

  @override
  String get avgStress => 'Stress';

  @override
  String get avgSleep => 'Sleep';

  @override
  String hoursShort(String hours) {
    return '$hours h';
  }

  @override
  String get noValue => '—';

  @override
  String get logSymptom => 'Log a symptom';

  @override
  String get logSleep => 'Log sleep';

  @override
  String get historyTitle => 'History';

  @override
  String get seeHistory => 'See history';

  @override
  String get insightsTitle => 'Insights';

  @override
  String get seeAllInsights => 'See all insights';

  @override
  String get insightsEmpty =>
      'Keep checking in — observations appear once there\'s enough to notice.';

  @override
  String get insightsRefreshing => 'Your insights are being prepared…';

  @override
  String get topSymptomsTitle => 'Most recorded symptoms (30 days)';

  @override
  String get checkInTitle => 'Check-in';

  @override
  String get checkInEditTitle => 'Edit check-in';

  @override
  String get checkInBadge => 'Private';

  @override
  String get moodQuestion => 'Overall, how do you feel?';

  @override
  String get moodRequired => 'Please choose how you feel.';

  @override
  String get moodVerySad => 'Very sad';

  @override
  String get moodSad => 'Sad';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get moodGood => 'Good';

  @override
  String get moodVeryGood => 'Very good';

  @override
  String get detailsOptional => 'More detail (optional)';

  @override
  String get scaleMood => 'Mood score';

  @override
  String get scaleAnxiety => 'Anxiety';

  @override
  String get scaleStress => 'Stress';

  @override
  String get scaleEnergy => 'Energy';

  @override
  String get scaleSleepQuality => 'Sleep quality';

  @override
  String get scaleSeverity => 'How strong was it?';

  @override
  String get scaleAdd => 'Add';

  @override
  String scaleClear(String label) {
    return 'Clear $label';
  }

  @override
  String scaleValue(int value) {
    return '$value of 10';
  }

  @override
  String get privateNotes => 'Private notes';

  @override
  String get privateNotesHint => 'Anything you want to remember (only you can see this)';

  @override
  String get saveEntry => 'Save';

  @override
  String get entrySaved => 'Saved.';

  @override
  String get deleteEntry => 'Delete entry';

  @override
  String get deleteEntryConfirm => 'Delete this entry? This can\'t be undone.';

  @override
  String get entryDeleted => 'Entry deleted.';

  @override
  String get symptomTitle => 'Log a symptom';

  @override
  String get symptomEditTitle => 'Edit symptom';

  @override
  String get symptomWhich => 'What are you noticing?';

  @override
  String get symptomRequired => 'Please choose a symptom.';

  @override
  String get durationTitle => 'How long did it last? (optional)';

  @override
  String durationMinutes(int count) {
    return '$count min';
  }

  @override
  String durationHours(int count) {
    return '$count h';
  }

  @override
  String get durationNotSure => 'Not sure';

  @override
  String get sleepTitle => 'Log sleep';

  @override
  String get sleepEditTitle => 'Edit sleep';

  @override
  String get sleepHowLong => 'How long did you sleep?';

  @override
  String sleepHoursValue(String hours) {
    return '$hours hours';
  }

  @override
  String get historyMoods => 'Moods';

  @override
  String get historySymptoms => 'Symptoms';

  @override
  String get historySleep => 'Sleep';

  @override
  String get historyEmpty => 'Nothing recorded this month.';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String severityValue(int value) {
    return 'Severity $value/10';
  }

  @override
  String qualityValue(int value) {
    return 'Quality $value/10';
  }

  @override
  String get reminderBody => 'It\'s time for your reminder.';

  @override
  String get navMeds => 'Meds';

  @override
  String get medsTitle => 'Your medications';

  @override
  String get medsDisclaimer =>
      'Your own records, not medical advice. Talk to your clinician before changing anything.';

  @override
  String get todayDoses => 'Today';

  @override
  String get noDosesToday => 'No scheduled doses today.';

  @override
  String get doseTaken => 'Taken';

  @override
  String get doseSkip => 'Skip';

  @override
  String get doseStatusTaken => 'Taken';

  @override
  String get doseStatusSkipped => 'Skipped';

  @override
  String get doseStatusMissed => 'Missed';

  @override
  String get doseStatusDelayed => 'Taken late';

  @override
  String markTaken(String name, String time) {
    return 'Mark $name at $time as taken';
  }

  @override
  String markSkipped(String name, String time) {
    return 'Skip $name at $time';
  }

  @override
  String get currentMeds => 'Current';

  @override
  String get pastMeds => 'Past medications';

  @override
  String get noMeds => 'Add a medication to keep track of doses and how you feel.';

  @override
  String get noPastMeds => 'No past medications.';

  @override
  String get addMedication => 'Add medication';

  @override
  String get medPaused => 'Paused';

  @override
  String get medDiscontinued => 'Stopped';

  @override
  String get remindersOff => 'Reminders off';

  @override
  String get scheduleDaily => 'Every day';

  @override
  String get scheduleWeekly => 'Some days';

  @override
  String get scheduleInterval => 'Every few days';

  @override
  String get scheduleAsNeeded => 'As needed';

  @override
  String scheduleEveryNDays(int count) {
    return 'Every $count days';
  }

  @override
  String scheduleAt(String times) {
    return 'at $times';
  }

  @override
  String get medFormNew => 'Add medication';

  @override
  String get medFormEdit => 'Edit medication';

  @override
  String get medFormSubtitle =>
      'Only you can see this. It\'s a personal record, not a prescription.';

  @override
  String get medName => 'Medication name';

  @override
  String get medNameRequired => 'Please enter a name.';

  @override
  String get medDosage => 'Dosage';

  @override
  String get medDosageInvalid => 'Use a number, like 50 or 0.5.';

  @override
  String get medUnit => 'Unit';

  @override
  String get medStartDate => 'Start date';

  @override
  String get medEndDate => 'End date (optional)';

  @override
  String get medNoEndDate => 'No end date';

  @override
  String get medSchedule => 'When do you take it?';

  @override
  String get medTimes => 'Times';

  @override
  String get medAddTime => 'Add a time';

  @override
  String medRemoveTime(String time) {
    return 'Remove $time';
  }

  @override
  String get medTimesRequired => 'Add at least one time.';

  @override
  String get medDays => 'Days';

  @override
  String get medDaysRequired => 'Choose at least one day.';

  @override
  String medIntervalDays(int count) {
    return 'Every $count days';
  }

  @override
  String get medReminders => 'Reminders';

  @override
  String get medRemindersHelp =>
      'Notifications only say “It\'s time for your reminder” — never the medication name.';

  @override
  String get medInstructions => 'Instructions (optional)';

  @override
  String get medInstructionsHint => 'e.g. with food';

  @override
  String get medClinician => 'Clinician (optional)';

  @override
  String get medNotes => 'Personal notes (optional)';

  @override
  String get medDetailsTitle => 'Medication';

  @override
  String medStarted(String date) {
    return 'Since $date';
  }

  @override
  String medUntil(String date) {
    return 'Until $date';
  }

  @override
  String get medPause => 'Pause';

  @override
  String get medResume => 'Resume';

  @override
  String get medStop => 'Mark as stopped';

  @override
  String get medStopConfirm =>
      'Mark this medication as stopped? Its reminders will end. Your history stays.';

  @override
  String get medDelete => 'Delete medication';

  @override
  String get medDeleteConfirm =>
      'Delete this medication and everything recorded for it? This can\'t be undone.';

  @override
  String get medLogAsNeeded => 'I took a dose';

  @override
  String get medHistory => 'Recent doses';

  @override
  String get medHistoryEmpty => 'No doses recorded yet.';

  @override
  String get medExperiences => 'How it\'s going';

  @override
  String get medExperiencesEmpty =>
      'Note benefits, side effects or changes you notice. Only you can see them.';

  @override
  String get medAddExperience => 'Add a note';

  @override
  String get expBenefit => 'Benefit';

  @override
  String get expSideEffect => 'Side effect';

  @override
  String get expChange => 'Change I noticed';

  @override
  String get expGeneral => 'General';

  @override
  String get expDescription => 'What did you notice?';

  @override
  String get expDelete => 'Delete note';

  @override
  String get unitOther => 'other';
}
