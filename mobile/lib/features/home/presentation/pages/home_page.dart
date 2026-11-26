import 'package:flutter/material.dart';
import 'package:mindful/app/localization/generated/app_localizations.dart';
import 'package:mindful/core/widgets/app_background.dart';
import 'package:mindful/features/community/presentation/pages/community_page.dart';
import 'package:mindful/features/home/presentation/pages/me_page.dart';

/// Signed-in app shell: bottom navigation between the main areas. Tracking, journal
/// and medication tabs join in later phases.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          bottom: false,
          child: IndexedStack(index: _tab, children: const [CommunityPage(), MePage()]),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.forum_outlined),
            selectedIcon: const Icon(Icons.forum_rounded),
            label: l10n.navCommunity,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline_rounded),
            selectedIcon: const Icon(Icons.person_rounded),
            label: l10n.navMe,
          ),
        ],
      ),
    );
  }
}
