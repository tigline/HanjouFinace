import 'package:flutter/material.dart';

import '../../../../app/localization/app_localizations_ext.dart';

class DiscussionBoardTabPage extends StatelessWidget {
  const DiscussionBoardTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ListView(
      key: const Key('discussion_tab_content'),
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  l10n.discussionTabHeadline,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(l10n.discussionTabSubtitle),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const _DiscussionPostCard(
          author: 'Yuki S.',
          title: 'SIT 项目收益分配日程讨论',
          body: '最近一次分配到账时间有延迟吗？我这边想确认和公告一致。',
          replies: 6,
        ),
        const SizedBox(height: 12),
        const _DiscussionPostCard(
          author: 'Aaron H.',
          title: '酒店会员权益能否和投资等级联动',
          body: '如果持仓等级提升，是否能同步提高订房折扣档位？',
          replies: 12,
        ),
      ],
    );
  }
}

class _DiscussionPostCard extends StatelessWidget {
  const _DiscussionPostCard({
    required this.author,
    required this.title,
    required this.body,
    required this.replies,
  });

  final String author;
  final String title;
  final String body;
  final int replies;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(author, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(body),
            const SizedBox(height: 12),
            Row(
              children: <Widget>[
                const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                const SizedBox(width: 6),
                Text('$replies'),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(context.l10n.discussionTabReplyAction),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
