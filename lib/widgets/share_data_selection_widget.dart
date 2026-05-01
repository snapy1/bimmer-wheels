import 'package:flutter/material.dart';

class ShareDataSelectionWidget extends StatefulWidget {
  final Function(String) onOptionSelected;
  const ShareDataSelectionWidget({super.key, required this.onOptionSelected});
  @override
  State<ShareDataSelectionWidget> createState() => _ShareDataSelectionWidgetState();
}

// a simple boolean widget that just lets people opt in or out of sharing their photos with us to further improve the dataset
class _ShareDataSelectionWidgetState extends State<ShareDataSelectionWidget> {
  bool shareData = false;

  void _showSharingInfo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => const _ShareDataInfoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Help Us Improve', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('Would you like to share your photos with us to help improve our dataset?'),
        SizedBox(height: 8),
        GestureDetector(
          onTap: _showSharingInfo,
          child: Text(
            'What am I sharing?',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SwitchListTile(
          title: Text('Share my photos'),
          value: shareData,
          onChanged: (value) {
            setState(() {
              shareData = value;
            });
            widget.onOptionSelected(value ? 'share' : 'dont_share');
          },
        ),
      ],
    );
  }
}

class _ShareDataInfoPage extends StatelessWidget {
  const _ShareDataInfoPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What Am I Sharing?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'The only thing you are sharing is your photo.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Your photos will only be used to help improve the dataset in the future. No other personal information is shared through this option.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}