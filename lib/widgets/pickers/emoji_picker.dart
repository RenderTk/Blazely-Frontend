import 'package:flutter/material.dart';

class EmojiPicker extends StatefulWidget {
  const EmojiPicker({super.key, required this.emojiController});

  final TextEditingController emojiController;

  @override
  State<EmojiPicker> createState() => _EmojiPickerState();
}

class _EmojiPickerState extends State<EmojiPicker> {
  EmojiCategory selectedEmojiCategory = EmojiCategory.smileysEmotion;

  List<String> getEmojiList(EmojiCategory emojiCategory) {
    final emojis = emojiMap[emojiCategory];
    return emojis!;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final availableHeight = constraints.maxHeight;
        double maxHeight = 0;
        if (availableHeight <= 150) {
          maxHeight = 100;
        } else if (availableHeight <= 300) {
          maxHeight = 200;
        } else {
          maxHeight = 240;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SegmentedButton<EmojiCategory>(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        side: WidgetStateProperty.resolveWith<BorderSide>(
                          (states) => BorderSide(
                            color:
                                states.contains(WidgetState.selected)
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).dividerColor,
                            width: 1.5,
                          ),
                        ),
                        backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) =>
                              states.contains(WidgetState.selected)
                                  ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.2)
                                  : Theme.of(context).colorScheme.surface,
                        ),
                        foregroundColor: WidgetStateProperty.resolveWith<Color>(
                          (states) =>
                              states.contains(WidgetState.selected)
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      segments: const [
                        ButtonSegment(
                          value: EmojiCategory.smileysEmotion,
                          label: Text("😊"),
                          tooltip: 'Smileys & Emotion',
                        ),
                        ButtonSegment(
                          value: EmojiCategory.peopleBody,
                          label: Text("🧍"),
                          tooltip: 'People & Body',
                        ),
                        ButtonSegment(
                          value: EmojiCategory.animalsNature,
                          label: Text("🐶"),
                          tooltip: 'Animals & Nature',
                        ),
                        ButtonSegment(
                          value: EmojiCategory.foodDrink,
                          label: Text("🍔"),
                          tooltip: 'Food & Drink',
                        ),
                        ButtonSegment(
                          value: EmojiCategory.travelPlaces,
                          label: Text("✈️"),
                          tooltip: 'Travel & Places',
                        ),
                        ButtonSegment(
                          value: EmojiCategory.activities,
                          label: Text("⚽"),
                          tooltip: 'Activities',
                        ),
                        ButtonSegment(
                          value: EmojiCategory.objects,
                          label: Text("💡"),
                          tooltip: 'Objects',
                        ),
                        ButtonSegment(
                          value: EmojiCategory.symbols,
                          label: Text("🔣"),
                          tooltip: 'Symbols',
                        ),
                        ButtonSegment(
                          value: EmojiCategory.flags,
                          label: Text("🏁"),
                          tooltip: 'Flags',
                        ),
                      ],
                      selected: {selectedEmojiCategory},
                      onSelectionChanged: (Set<EmojiCategory> newSelection) {
                        setState(() {
                          selectedEmojiCategory = newSelection.first;
                        });
                      },
                      showSelectedIcon: false,
                    ),
                    Divider(thickness: 0.2),
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 20,
                      runSpacing: 20,
                      children: [
                        for (final emoji in emojiMap[selectedEmojiCategory]!)
                          SizedBox(
                            width: 30,
                            height: 30,
                            child: TextButton(
                              onPressed:
                                  () => widget.emojiController.text = emoji,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                              child: Text(
                                emoji,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(10, 10),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () => widget.emojiController.clear(),
                  child: const Text("Remove emoji"),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

final emojiList = [
  "😀",
  "😎",
  "🥹",
  "😴",
  "😂",
  "🥰",
  "😡",
  "😇",
  "🤯",
  "🤠",
  "🐶",
  "🐱",
  "💩",
  "🦊",
  "🐻",
  "🐼",
  "🐨",
  "🐸",
  "🦁",
  "🐷",
  "🐵",
  "🍕",
  "🍔",
  "🍟",
  "🌮",
  "🌯",
  "🍣",
  "🍩",
  "🍪",
  "🍓",
  "🍉",
  "🍇",
  "🍍",
  "🍌",
  "🍎",
  "🥝",
  "🥑",
  "🥦",
  "🧄",
  "🌶️",
  "🧀",
  "🚀",
  "✈️",
  "🚗",
  "🚌",
  "🚓",
  "🏍️",
  "🚲",
  "🚤",
  "🛳️",
  "🛸",
  "🎉",
  "🎊",
  "🎂",
  "🎁",
  "🎈",
  "🪅",
  "🎃",
  "🎄",
  "🧨",
  "🪩",
  "🌈",
  "☀️",
  "🌙",
  "🌟",
  "⚡",
  "🔥",
  "💧",
  "❄️",
  "🌪️",
  "🌊",
  "👾",
  "🤖",
  "👽",
  "🧠",
  "🦾",
  "🦿",
  "🧬",
  "💻",
  "🖥️",
  "🖱️",
  "⚽",
  "🏀",
  "🏈",
  "⚾",
  "🎾",
  "🏐",
  "🥏",
  "🏓",
  "🥊",
  "🏸",
  "📱",
  "📲",
  "💻",
  "🖥️",
  "⌚",
  "📷",
  "🎥",
  "📺",
  "🕹️",
  "🎮",
  "🎧",
  "🎼",
  "🎹",
  "🥁",
  "🎷",
  "🎺",
  "🎸",
  "🪕",
  "📻",
  "🎤",
  "🏝️",
  "🏔️",
  "🌋",
  "🏜️",
  "🏕️",
  "🗻",
  "🏞️",
  "🌅",
  "🌃",
  "🌌",
  "🛐",
  "⚰️",
  "⚱️",
  "🪦",
  "🏰",
  "🗽",
  "🗼",
  "🏯",
  "🏟️",
  "🏛️",
  "💡",
  "🔦",
  "🔋",
  "🔌",
  "💾",
  "💿",
  "📀",
  "🧮",
  "📡",
  "🧲",
  "📚",
  "📖",
  "📓",
  "📒",
  "📕",
  "📗",
  "📘",
  "📙",
  "📔",
  "📝",
  "✏️",
  "🖊️",
  "🖋️",
  "✒️",
  "📐",
  "📏",
  "📎",
  "🖇️",
  "📌",
  "📍",
  "🧷",
  "🧵",
  "🧶",
  "🪡",
  "🪢",
  "🔒",
  "🔓",
  "🔑",
  "🗝️",
  "🛡️",
];

enum EmojiCategory {
  smileysEmotion,
  peopleBody,
  animalsNature,
  foodDrink,
  travelPlaces,
  activities,
  objects,
  symbols,
  flags,
}

final Map<EmojiCategory, List<String>> emojiMap = {
  EmojiCategory.smileysEmotion: [
    // Happy faces
    '😀',
    '😃',
    '😄',
    '😁',
    '😆',
    '😅',
    '🤣',
    '😂',
    '🙂',
    '🙃',
    '😉',
    '😊',
    '😇',
    // Love and affection
    '🥰', '😍', '🤩', '😘', '😗', '☺️', '😚', '😙', '🥲',
    // Neutral and thoughtful
    '😐', '😑', '😶', '😏', '😒', '🙄', '😬', '🤐', '🤨', '😮‍💨', '😤',
    // Sad and worried
    '😔',
    '😕',
    '🙁',
    '☹️',
    '😣',
    '😖',
    '😫',
    '😩',
    '🥺',
    '😢',
    '😭',
    '😤',
    '😠',
    '😡',
    // Surprised and confused
    '😳',
    '🥵',
    '🥶',
    '😱',
    '😨',
    '😰',
    '😥',
    '😓',
    '🤗',
    '🤔',
    '😯',
    '😦',
    '😧',
    '😮',
    '😲',
    // Sick and tired
    '🤒', '🤕', '🤢', '🤮', '🤧', '🥴', '😵', '😵‍💫', '🤯', '🤠', '🥳', '🥸',
    // Faces with accessories
    '😎', '🤓', '🧐',
    // Other expressions
    '😴', '😪', '🤤', '😋', '😛', '😝', '😜', '🤪', '🥱', '🤭', '🤫', '🤥',
    // Non-human faces
    '👹', '👺', '🤡', '💩', '👻', '💀', '☠️', '👽', '👾', '🤖', '💩',
    // Emotions and symbols
    '❤️',
    '🧡',
    '💛',
    '💚',
    '💙',
    '💜',
    '🖤',
    '🤍',
    '🤎',
    '💔',
    '❣️',
    '💕',
    '💞',
    '💓',
    '💗',
    '💖',
    '💘',
    '💝',
    '💋',
    '💯',
    '💢',
    '💥',
    '💫',
    '💦',
    '💨',
    '🕳️',
    '💣',
    '💬',
    '👁️‍🗨️',
    '🗨️',
    '🗯️',
    '💭',
    '💤',
  ],

  EmojiCategory.peopleBody: [
    // Hand gestures
    '👋',
    '🤚',
    '🖐️',
    '✋',
    '🖖',
    '👌',
    '🤌',
    '🤏',
    '✌️',
    '🤞',
    '🤟',
    '🤘',
    '🤙',
    '👈',
    '👉',
    '👆',
    '🖕',
    '👇',
    '☝️',
    '👍',
    '👎',
    '👊',
    '✊',
    '🤛',
    '🤜',
    '👏',
    '🙌',
    '👐',
    '🤲',
    '🤝',
    '🙏',
    // Body parts
    '✍️',
    '💅',
    '🤳',
    '💪',
    '🦾',
    '🦿',
    '🦵',
    '🦶',
    '👂',
    '🦻',
    '👃',
    '🧠',
    '🫀',
    '🫁',
    '🦷',
    '🦴',
    '👀',
    '👁️',
    '👅',
    '👄',
    // People faces and hair
    '👶',
    '🧒',
    '👦',
    '👧',
    '🧑',
    '👱',
    '👨',
    '🧔',
    '👨‍🦰',
    '👨‍🦱',
    '👨‍🦳',
    '👨‍🦲',
    '👩',
    '👩‍🦰',
    '🧑‍🦰',
    '👩‍🦱',
    '🧑‍🦱',
    '👩‍🦳',
    '🧑‍🦳',
    '👩‍🦲',
    '🧑‍🦲',
    '👱‍♀️',
    '👱‍♂️',
    '🧓',
    '👴',
    '👵',
    // People with roles and activities
    '🙍',
    '🙍‍♂️',
    '🙍‍♀️',
    '🙎',
    '🙎‍♂️',
    '🙎‍♀️',
    '🙅',
    '🙅‍♂️',
    '🙅‍♀️',
    '🙆',
    '🙆‍♂️',
    '🙆‍♀️',
    '💁',
    '💁‍♂️',
    '💁‍♀️',
    '🙋',
    '🙋‍♂️',
    '🙋‍♀️',
    '🧏',
    '🧏‍♂️',
    '🧏‍♀️',
    '🙇',
    '🙇‍♂️',
    '🙇‍♀️',
    '🤦',
    '🤦‍♂️',
    '🤦‍♀️',
    '🤷',
    '🤷‍♂️',
    '🤷‍♀️',
    // Health and care workers
    '🧑‍⚕️',
    '👨‍⚕️',
    '👩‍⚕️',
    '🧑‍🎓',
    '👨‍🎓',
    '👩‍🎓',
    '🧑‍🏫',
    '👨‍🏫',
    '👩‍🏫',
    '🧑‍⚖️',
    '👨‍⚖️',
    '👩‍⚖️',
    '🧑‍🌾',
    '👨‍🌾',
    '👩‍🌾',
    '🧑‍🍳',
    '👨‍🍳',
    '👩‍🍳',
    '🧑‍🔧',
    '👨‍🔧',
    '👩‍🔧',
    '🧑‍🏭',
    '👨‍🏭',
    '👩‍🏭',
    '🧑‍💼',
    '👨‍💼',
    '👩‍💼',
    '🧑‍🔬',
    '👨‍🔬',
    '👩‍🔬',
    '🧑‍💻',
    '👨‍💻',
    '👩‍💻',
    '🧑‍🎤',
    '👨‍🎤',
    '👩‍🎤',
    '🧑‍🎨',
    '👨‍🎨',
    '👩‍🎨',
    '🧑‍✈️',
    '👨‍✈️',
    '👩‍✈️',
    '🧑‍🚀',
    '👨‍🚀',
    '👩‍🚀',
    '🧑‍🚒',
    '👨‍🚒',
    '👩‍🚒',
    '👮',
    '👮‍♂️',
    '👮‍♀️',
    '🕵️',
    '🕵️‍♂️',
    '🕵️‍♀️',
    '💂',
    '💂‍♂️',
    '💂‍♀️',
    '🥷',
    '👷',
    '👷‍♂️',
    '👷‍♀️',
    // Fantasy and costumes
    '🤴',
    '👸',
    '👳',
    '👳‍♂️',
    '👳‍♀️',
    '👲',
    '🧕',
    '🤵',
    '🤵‍♂️',
    '🤵‍♀️',
    '👰',
    '👰‍♂️',
    '👰‍♀️',
    '🤱',
    '🤰',
    '👼',
    '🎅',
    '🤶',
    '🧑‍🎄',
    '🦸',
    '🦸‍♂️',
    '🦸‍♀️',
    '🦹',
    '🦹‍♂️',
    '🦹‍♀️',
    '🧙',
    '🧙‍♂️',
    '🧙‍♀️',
    '🧚',
    '🧚‍♂️',
    '🧚‍♀️',
    '🧛',
    '🧛‍♂️',
    '🧛‍♀️',
    '🧜',
    '🧜‍♂️',
    '🧜‍♀️',
    '🧝',
    '🧝‍♂️',
    '🧝‍♀️',
    '🧞',
    '🧞‍♂️',
    '🧞‍♀️',
    '🧟',
    '🧟‍♂️',
    '🧟‍♀️',
    // People activities
    '💆',
    '💆‍♂️',
    '💆‍♀️',
    '💇',
    '💇‍♂️',
    '💇‍♀️',
    '🚶',
    '🚶‍♂️',
    '🚶‍♀️',
    '🧑‍🦯',
    '👨‍🦯',
    '👩‍🦯',
    '🧑‍🦼',
    '👨‍🦼',
    '👩‍🦼',
    '🧑‍🦽',
    '👨‍🦽',
    '👩‍🦽',
    '🏃',
    '🏃‍♂️',
    '🏃‍♀️',
    '💃',
    '🕺',
    '🕴️',
    '👯',
    '👯‍♂️',
    '👯‍♀️',
    '🧖',
    '🧖‍♂️',
    '🧖‍♀️',
    // Family
    '👪',
    '👨‍👩‍👧',
    '👨‍👩‍👧‍👦',
    '👨‍👩‍👦‍👦',
    '👨‍👩‍👧‍👧',
    '👨‍👨‍👦',
    '👨‍👨‍👧',
    '👨‍👨‍👧‍👦',
    '👨‍👨‍👦‍👦',
    '👨‍👨‍👧‍👧',
    '👩‍👩‍👦',
    '👩‍👩‍👧',
    '👩‍👩‍👧‍👦',
    '👩‍👩‍👦‍👦',
    '👩‍👩‍👧‍👧',
    '👨‍👦',
    '👨‍👦‍👦',
    '👨‍👧',
    '👨‍👧‍👦',
    '👨‍👧‍👧',
    '👩‍👦',
    '👩‍👦‍👦',
    '👩‍👧',
    '👩‍👧‍👦',
    '👩‍👧‍👧',
    // Couple
    '💏', '👨‍❤️‍💋‍👨', '👩‍❤️‍💋‍👩', '💑', '👨‍❤️‍👨', '👩‍❤️‍👩',
    // Clothing
    '🗣️', '👤', '👥', '🫂', '👣', '🦰', '🦱', '🦳', '🦲',
  ],

  EmojiCategory.animalsNature: [
    // Mammals
    '🐵',
    '🐒',
    '🦍',
    '🦧',
    '🐶',
    '🐕',
    '🦮',
    '🐕‍🦺',
    '🐩',
    '🐺',
    '🦊',
    '🦝',
    '🐱',
    '🐈',
    '🐈‍⬛',
    '🦁',
    '🐯',
    '🐅',
    '🐆',
    '🐴',
    '🐎',
    '🦄',
    '🦓',
    '🦌',
    '🦬',
    '🐮',
    '🐂',
    '🐃',
    '🐄',
    '🐷',
    '🐖',
    '🐗',
    '🐽',
    '🐏',
    '🐑',
    '🐐',
    '🐪',
    '🐫',
    '🦙',
    '🦒',
    '🐘',
    '🦣',
    '🦏',
    '🦛',
    '🐭',
    '🐁',
    '🐀',
    '🐹',
    '🐰',
    '🐇',
    '🐿️',
    '🦫',
    '🦔',
    '🦇',
    '🐻',
    '🐻‍❄️',
    '🐨',
    '🐼',
    '🦥',
    '🦦',
    '🦨',
    '🦘',
    '🦡',
    // Birds
    '🐾',
    '🦃',
    '🐔',
    '🐓',
    '🐣',
    '🐤',
    '🐥',
    '🐦',
    '🐧',
    '🕊️',
    '🦅',
    '🦆',
    '🦢',
    '🦉',
    '🦤',
    '🪶',
    '🦩',
    '🦚',
    '🦜',
    // Marine life
    '🐸',
    '🐊',
    '🐢',
    '🦎',
    '🐍',
    '🐲',
    '🐉',
    '🦕',
    '🦖',
    '🐳',
    '🐋',
    '🐬',
    '🦭',
    '🐟',
    '🐠',
    '🐡',
    '🦈',
    '🐙',
    '🐚',
    '🦀',
    '🦞',
    '🦐',
    '🦑',
    '🐌',
    '🦋',
    '🐛',
    '🐜',
    '🐝',
    '🪲',
    '🐞',
    '🦗',
    '🕷️',
    '🕸️',
    '🦂',
    '🦟',
    '🪰',
    '🪱',
    '🦠',
    // Plants
    '💐',
    '🌸',
    '💮',
    '🏵️',
    '🌹',
    '🥀',
    '🌺',
    '🌻',
    '🌼',
    '🌷',
    '🌱',
    '🪴',
    '🌲',
    '🌳',
    '🌴',
    '🌵',
    '🌶️',
    '🌾',
    '🌿',
    '☘️',
    '🍀',
    '🍁',
    '🍂',
    '🍃',
    '🪹',
    '🪺',
    // Weather and sky
    '🌍',
    '🌎',
    '🌏',
    '🌐',
    '🌑',
    '🌒',
    '🌓',
    '🌔',
    '🌕',
    '🌖',
    '🌗',
    '🌘',
    '🌙',
    '🌚',
    '🌛',
    '🌜',
    '🌝',
    '🌞',
    '🪐',
    '⭐',
    '🌟',
    '✨',
    '⚡',
    '☄️',
    '💫',
    '🔥',
    '🌪️',
    '🌈',
    '☀️',
    '🌤️',
    '⛅',
    '🌦️',
    '🌧️',
    '⛈️',
    '🌩️',
    '🌨️',
    '❄️',
    '☃️',
    '⛄',
    '🌬️',
    '💨',
    '💧',
    '💦',
    '☔',
  ],

  EmojiCategory.foodDrink: [
    // Fruits
    '🍇',
    '🍈',
    '🍉',
    '🍊',
    '🍋',
    '🍌',
    '🍍',
    '🥭',
    '🍎',
    '🍏',
    '🍐',
    '🍑',
    '🍒',
    '🍓',
    '🫐',
    '🥝',
    '🍅',
    '🫒',
    '🥥',
    // Vegetables
    '🥑',
    '🍆',
    '🥔',
    '🥕',
    '🌽',
    '🌶️',
    '🫑',
    '🥒',
    '🥬',
    '🥦',
    '🧄',
    '🧅',
    '🍄',
    '🥜',
    '🌰',
    // Prepared foods
    '🍞',
    '🥐',
    '🥖',
    '🫓',
    '🥨',
    '🥯',
    '🥞',
    '🧇',
    '🧀',
    '🍖',
    '🍗',
    '🥩',
    '🥓',
    '🍔',
    '🍟',
    '🍕',
    '🌭',
    '🥪',
    '🌮',
    '🌯',
    '🫔',
    '🥙',
    '🧆',
    '🥚',
    '🍳',
    '🥘',
    '🍲',
    '🫕',
    '🥣',
    '🥗',
    '🍿',
    '🧈',
    '🧂',
    '🥫',
    // Asian foods
    '🍱',
    '🍘',
    '🍙',
    '🍚',
    '🍛',
    '🍜',
    '🍝',
    '🍠',
    '🍢',
    '🍣',
    '🍤',
    '🍥',
    '🥮',
    '🍡',
    '🥟',
    '🥠',
    '🥡',
    // Desserts
    '🍦',
    '🍧',
    '🍨',
    '🍩',
    '🍪',
    '🎂',
    '🍰',
    '🧁',
    '🥧',
    '🍫',
    '🍬',
    '🍭',
    '🍮',
    '🍯',
    // Drinks
    '🍼',
    '🥛',
    '☕',
    '🫖',
    '🍵',
    '🍶',
    '🍾',
    '🍷',
    '🍸',
    '🍹',
    '🍺',
    '🍻',
    '🥂',
    '🥃',
    '🥤',
    '🧋',
    '🧃',
    '🧉',
    '🧊',
    // Utensils
    '🥢', '🍽️', '🍴', '🥄', '🔪', '🏺',
  ],

  EmojiCategory.travelPlaces: [
    // Maps and locations
    '🌍', '🌎', '🌏', '🌐', '🗺️', '🗾', '🧭',
    // Buildings
    '🏔️',
    '⛰️',
    '🌋',
    '🗻',
    '🏕️',
    '🏖️',
    '🏜️',
    '🏝️',
    '🏞️',
    '🏟️',
    '🏛️',
    '🏗️',
    '🧱',
    '🪨',
    '🪵',
    '🛖',
    '🏘️',
    '🏚️',
    '🏠',
    '🏡',
    '🏢',
    '🏣',
    '🏤',
    '🏥',
    '🏦',
    '🏧',
    '🏨',
    '🏩',
    '🏪',
    '🏫',
    '🏬',
    '🏭',
    '🏯',
    '🏰',
    '💒',
    '🗼',
    '🗽',
    '⛪',
    '🕌',
    '🛕',
    '🕍',
    '⛩️',
    '🕋',
    // Transportation - Land
    '⛲',
    '⛱️',
    '🌁',
    '🌃',
    '🏙️',
    '🌄',
    '🌅',
    '🌆',
    '🌇',
    '🌉',
    '♨️',
    '🎠',
    '🎡',
    '🎢',
    '💈',
    '🎪',
    '🚂',
    '🚃',
    '🚄',
    '🚅',
    '🚆',
    '🚇',
    '🚈',
    '🚉',
    '🚊',
    '🚝',
    '🚞',
    '🚋',
    '🚌',
    '🚍',
    '🚎',
    '🚐',
    '🚑',
    '🚒',
    '🚓',
    '🚔',
    '🚕',
    '🚖',
    '🚗',
    '🚘',
    '🚙',
    '🛻',
    '🚚',
    '🚛',
    '🚜',
    '🏎️',
    '🏍️',
    '🛵',
    '🦽',
    '🦼',
    '🛺',
    '🚲',
    '🛴',
    '🛹',
    '🛼',
    '🚁',
    '🚟',
    '🚠',
    '🚡',
    '🛰️',
    // Transportation - Water
    '🚢', '🛳️', '⛴️', '🛥️', '🚤', '⛵', '🛶', '🚣', '🤿', '🏊', '🏄', '🚀',
    // Transportation - Air
    '✈️', '🛩️', '🛫', '🛬', '🪂', '💺', '🚁', '🚟', '🚠', '🚡',
    // Traffic and signs
    '🚦', '🚥', '⚓', '⛽', '🚨', '🚏', '🚇', '🚑', '🚒', '🚓', '🚔',
    // Time and weather
    '🌠',
    '🎆',
    '🎇',
    '🌌',
    '🎑',
    '🏞️',
    '🌅',
    '🌄',
    '🌇',
    '🌆',
    '🌃',
    '🌉',
    '🌁',
  ],

  EmojiCategory.activities: [
    // Sports
    '⚽',
    '🏀',
    '🏈',
    '⚾',
    '🥎',
    '🎾',
    '🏐',
    '🏉',
    '🥏',
    '🎱',
    '🪀',
    '🏓',
    '🏸',
    '🏒',
    '🏑',
    '🥍',
    '🏏',
    '🪃',
    '🥅',
    '⛳',
    '🪁',
    '🏹',
    '🎣',
    '🤿',
    '🥊',
    '🥋',
    '🎽',
    '🛹',
    '🛼',
    '🛷',
    '⛸️',
    '🥌',
    '🎿',
    '⛷️',
    '🏂',
    '🪂',
    '🏋️',
    '🏋️‍♂️',
    '🏋️‍♀️',
    '🤼',
    '🤼‍♂️',
    '🤼‍♀️',
    '🤸',
    '🤸‍♂️',
    '🤸‍♀️',
    '⛹️',
    '⛹️‍♂️',
    '⛹️‍♀️',
    '🤺',
    '🤾',
    '🤾‍♂️',
    '🤾‍♀️',
    '🏌️',
    '🏌️‍♂️',
    '🏌️‍♀️',
    '🏇',
    '🧘',
    '🧘‍♂️',
    '🧘‍♀️',
    '🏄',
    '🏄‍♂️',
    '🏄‍♀️',
    '🏊',
    '🏊‍♂️',
    '🏊‍♀️',
    '🤽',
    '🤽‍♂️',
    '🤽‍♀️',
    '🚣',
    '🚣‍♂️',
    '🚣‍♀️',
    '🧗',
    '🧗‍♂️',
    '🧗‍♀️',
    '🚵',
    '🚵‍♂️',
    '🚵‍♀️',
    '🚴',
    '🚴‍♂️',
    '🚴‍♀️',
    '🏆',
    '🥇',
    '🥈',
    '🥉',
    '🏅',
    '🎖️',
    '🏵️',
    '🎗️',
    // Arts and entertainment
    '🎭',
    '🩰',
    '🎨',
    '🎬',
    '🎤',
    '🎧',
    '🎼',
    '🎵',
    '🎶',
    '🎹',
    '🥁',
    '🪘',
    '🎷',
    '🎺',
    '🪗',
    '🎸',
    '🪕',
    '🎻',
    '🎲',
    '♠️',
    '♥️',
    '♦️',
    '♣️',
    '♟️',
    '🃏',
    '🀄',
    '🎴',
    '🎮',
    '🕹️',
    '🎯',
    '🎳',
    '🎪',
    '🎨',
    '🎭',
    '🩰',
    '🎪',
    // Hobbies and activities
    '🧩', '🧸', '🪅', '🪆', '🖼️', '🧵', '🪡', '🧶', '🪢',
  ],

  EmojiCategory.objects: [
    // Clothing
    '👓',
    '🕶️',
    '🥽',
    '🥼',
    '🦺',
    '👔',
    '👕',
    '👖',
    '🧣',
    '🧤',
    '🧥',
    '🧦',
    '👗',
    '👘',
    '🥻',
    '🩱',
    '🩲',
    '🩳',
    '👙',
    '👚',
    '👛',
    '👜',
    '👝',
    '🛍️',
    '🎒',
    '🩴',
    '👞',
    '👟',
    '🥾',
    '🥿',
    '👠',
    '👡',
    '🩰',
    '👢',
    '👑',
    '👒',
    '🎩',
    '🎓',
    '🧢',
    '🪖',
    '⛑️',
    '📿',
    '💄',
    '💍',
    '💎',
    // Electronics
    '📱',
    '📲',
    '💻',
    '⌨️',
    '🖥️',
    '🖨️',
    '🖱️',
    '🖲️',
    '🕹️',
    '🗜️',
    '💽',
    '💾',
    '💿',
    '📀',
    '📼',
    '📷',
    '📸',
    '📹',
    '🎥',
    '📽️',
    '🎞️',
    '📞',
    '☎️',
    '📟',
    '📠',
    '📺',
    '📻',
    '🎙️',
    '🎚️',
    '🎛️',
    '🧭',
    '⏱️',
    '⏲️',
    '⏰',
    '🕰️',
    '⌛',
    '⏳',
    '📡',
    '🔋',
    '🔌',
    '💡',
    '🔦',
    '🕯️',
    '🪔',
    '🧯',
    // Tools and hardware
    '🛠️',
    '🔧',
    '🔨',
    '⚒️',
    '🛠️',
    '⛏️',
    '🔩',
    '⚙️',
    '🧰',
    '🧲',
    '🪓',
    '🪚',
    '🪛',
    '🪝',
    '⛓️',
    '🧱',
    '🪨',
    '🪵',
    '🛖',
    // Household items
    '🧴',
    '🧷',
    '🧹',
    '🧺',
    "🛒",
    '🧻',
    '🪣',
    '🧼',
    '🪥',
    '🧽',
    '🧯',
    '🛋️',
    '🪑',
    '🚪',
    '🪟',
    '🛏️',
    '🛌',
    '🧸',
    '🪆',
    '🖼️',
    '🪞',
    '🪟',
    '🛍️',
    '🧳',
    '⭐',
    '🌟',
    '🎀',
    '🎁',
    '🎊',
    '🎉',
    '🎈',
    '🎄',
    '🎋',
    '🎍',
    '🎎',
    '🎏',
    '🎐',
    '🎑',
    '🧧',
    '🎀',
    '🎁',
    '🎗️',
    '🎟️',
    '🎫',
    '🎖️',
    '🏆',
    '🏅',
    '🥇',
    '🥈',
    '🥉',
    // Office and school
    '📝',
    '✏️',
    '✒️',
    '🖋️',
    '🖊️',
    '🖌️',
    '🖍️',
    '📝',
    '✏️',
    '📁',
    '📂',
    '🗂️',
    '📅',
    '📆',
    '🗒️',
    '🗓️',
    '📇',
    '📈',
    '📉',
    '📊',
    '📋',
    '📌',
    '📍',
    '📎',
    '🖇️',
    '📏',
    '📐',
    '✂️',
    '🗃️',
    '🗄️',
    '🗑️',
    '🔒',
    '🔓',
    '🔏',
    '🔐',
    '🔑',
    '🗝️',
    '🔨',
    '🪓',
    '⛏️',
    '⚒️',
    '🛠️',
    '🗡️',
    '⚔️',
    '🔫',
    '🪃',
    '🏹',
    '🛡️',
    '🪚',
    '🔧',
    '🪛',
    '🔩',
    '⚙️',
    '🗜️',
    '⚖️',
    '🦯',
    '🔗',
    '⛓️',
    '🪝',
    '🧰',
    '🧲',
    '🪜',
    // Medical and science
    '⚗️',
    '🧪',
    '🧫',
    '🧬',
    '🔬',
    '🔭',
    '📡',
    '💉',
    '🩸',
    '💊',
    '🩹',
    '🩺',
    '🔬',
    // Money and business
    '💰',
    '🪙',
    '💴',
    '💵',
    '💶',
    '💷',
    '💸',
    '💳',
    '💎',
    '⚖️',
    '🪜',
    '🧰',
    '🔧',
    '🔨',
    '🪓',
    '⛏️',
    '⚒️',
    '🛠️',
    // Kitchen and dining
    '🔪',
    '🏺',
    '🍽️',
    '🥢',
    '🍴',
    '🥄',
    '⚱️',
    '🪣',
    '🧴',
    '🫖',
    '☕',
    '🍵',
    '🧋',
    '🧃',
    '🥤',
    '🧊',
    '🥛',
    '🍼',
    // Other objects
    '🚬', '⚰️', '🪦', '⚱️', '🗿', '🪧', '🪪',
  ],

  EmojiCategory.symbols: [
    // Hearts and love
    '❤️',
    '🧡',
    '💛',
    '💚',
    '💙',
    '💜',
    '🖤',
    '🤍',
    '🤎',
    '💔',
    '❣️',
    '💕',
    '💞',
    '💓',
    '💗',
    '💖',
    '💘',
    '💝',
    '💟',
    // Arrows
    '⬆️',
    '↗️',
    '➡️',
    '↘️',
    '⬇️',
    '↙️',
    '⬅️',
    '↖️',
    '↕️',
    '↔️',
    '↩️',
    '↪️',
    '⤴️',
    '⤵️',
    '🔃',
    '🔄',
    '🔙',
    '🔚',
    '🔛',
    '🔜',
    '🔝',
    // Geometric shapes
    '🔴',
    '🟠',
    '🟡',
    '🟢',
    '🔵',
    '🟣',
    '⚫',
    '⚪',
    '🟤',
    '🔺',
    '🔻',
    '🔸',
    '🔹',
    '🔶',
    '🔷',
    '🔳',
    '🔲',
    '▪️',
    '▫️',
    '◾',
    '◽',
    '◼️',
    '◻️',
    '⬛',
    '⬜',
    '🟥',
    '🟧',
    '🟨',
    '🟩',
    '🟦',
    '🟪',
    '🟫',
    // Math and symbols
    '➕',
    '➖',
    '➗',
    '✖️',
    '♾️',
    '💲',
    '💱',
    '™️',
    '©️',
    '®️',
    '〰️',
    '➰',
    '➿',
    '🔚',
    '🔙',
    '🔛',
    '🔝',
    '🔜',
    // Zodiac
    '♈', '♉', '♊', '♋', '♌', '♍', '♎', '♏', '♐', '♑', '♒', '♓', '⛎',
    // Audio and media
    '🔇',
    '🔈',
    '🔉',
    '🔊',
    '📢',
    '📣',
    '📯',
    '🔔',
    '🔕',
    '🎵',
    '🎶',
    '🎼',
    '🎹',
    // Warning and alert
    '⚠️', '🚸', '⛔', '🚫', '🚳', '🚭', '🚯', '🚱', '🚷', '📵', '🔞', '☢️', '☣️',
    // Religious and cultural
    '⚛️',
    '🕉️',
    '✡️',
    '☸️',
    '☯️',
    '✝️',
    '☦️',
    '☪️',
    '☮️',
    '🕎',
    '🔯',
    '♦️',
    '♣️',
    '♠️',
    '♥️',
    // Numbers
    '*️⃣',
    '0️⃣',
    '1️⃣',
    '2️⃣',
    '3️⃣',
    '4️⃣',
    '5️⃣',
    '6️⃣',
    '7️⃣',
    '8️⃣',
    '9️⃣',
    '🔟',
    // Letters
    '🅰️',
    '🆎',
    '🅱️',
    '🆑',
    '🆒',
    '🆓',
    'ℹ️',
    '🆔',
    'Ⓜ️',
    '🆕',
    '🆖',
    '🅾️',
    '🆗',
    '🅿️',
    '🆘',
    '🆙',
    '🆚',
    '🈁',
    '🈂️',
    '🈷️',
    '🈶',
    '🈯',
    '🉐',
    '🈹',
    '🈚',
    '🈲',
    '🉑',
    '🈸',
    '🈴',
    '🈳',
    '㊗️',
    '㊙️',
    '🈺',
    '🈵',
    // Punctuation and symbols
    '❓',
    '❔',
    '❕',
    '❗',
    '〰️',
    '💯',
    '🔥',
    '💫',
    '⭐',
    '🌟',
    '✨',
    '⚡',
    '☄️',
    '💥',
    '💢',
    '💨',
    '💦',
    '💤',
    // Gender and accessibility
    '♿', '🚹', '🚺', '🚻', '🚼', '🚾', '⚧️',
    // Technology and communication
    '📶',
    '📳',
    '📴',
    '🔀',
    '🔁',
    '🔂',
    '▶️',
    '⏸️',
    '⏯️',
    '⏹️',
    '⏺️',
    '⏭️',
    '⏮️',
    '⏩',
    '⏪',
    '⏫',
    '⏬',
    '◀️',
    '🔼',
    '🔽',
    '➡️',
    '⬅️',
    '⬆️',
    '⬇️',
    '↗️',
    '↘️',
    '↙️',
    '↖️',
    '↕️',
    '↔️',
    '↩️',
    '↪️',
    '⤴️',
    '⤵️',
    '🔃',
    '🔄',
    '🔙',
    '🔚',
    '🔛',
    '🔜',
    '🔝',
    // Other symbols
    '⚜️',
    '🔱',
    '📛',
    '🔰',
    '⭕',
    '✅',
    '☑️',
    '✔️',
    '❌',
    '❎',
    '➕',
    '➖',
    '➗',
    '➰',
    '➿',
    '〽️',
    '✳️',
    '✴️',
    '❇️',
    '‼️',
    '⁉️',
    '❓',
    '❔',
    '❕',
    '❗',
    '〰️',
    '🔆',
    '🔅',
    '💹',
    '🈯',
    '💠',
    '🔔',
    '🔕',
    '📢',
    '📣',
    '💬',
    '💭',
    '🗯️',
    '♨️',
    '🌐',
    '💠',
    '🔲',
    '🔳',
    '⚫',
    '⚪',
    '🟤',
    '🔴',
    '🟠',
    '🟡',
    '🟢',
    '🔵',
    '🟣',
    '🟥',
    '🟧',
    '🟨',
    '🟩',
    '🟦',
    '🟪',
    '🟫',
    '⬛',
    '⬜',
    '◼️',
    '◻️',
    '▪️',
    '▫️',
    '◾',
    '◽',
  ],

  EmojiCategory.flags: [
    // Country flags (major countries)
    '🏁', '🚩', '🎌', '🏴', '🏳️', '🏳️‍🌈', '🏳️‍⚧️', '🏴‍☠️',
    '🇦🇨',
    '🇦🇩',
    '🇦🇪',
    '🇦🇫',
    '🇦🇬',
    '🇦🇮',
    '🇦🇱',
    '🇦🇲',
    '🇦🇴',
    '🇦🇶',
    '🇦🇷',
    '🇦🇸',
    '🇦🇹',
    '🇦🇺',
    '🇦🇼',
    '🇦🇽',
    '🇦🇿',
    '🇧🇦',
    '🇧🇧',
    '🇧🇩',
    '🇧🇪',
    '🇧🇫',
    '🇧🇬',
    '🇧🇭',
    '🇧🇮',
    '🇧🇯',
    '🇧🇱',
    '🇧🇲',
    '🇧🇳',
    '🇧🇴',
    '🇧🇶',
    '🇧🇷',
    '🇧🇸',
    '🇧🇹',
    '🇧🇻',
    '🇧🇼',
    '🇧🇾',
    '🇧🇿',
    '🇨🇦',
    '🇨🇨',
    '🇨🇩',
    '🇨🇫',
    '🇨🇬',
    '🇨🇭',
    '🇨🇮',
    '🇨🇰',
    '🇨🇱',
    '🇨🇲',
    '🇨🇳',
    '🇨🇴',
    '🇨🇵',
    '🇨🇷',
    '🇨🇺',
    '🇨🇻',
    '🇨🇼',
    '🇨🇽',
    '🇨🇾',
    '🇨🇿',
    '🇩🇪', '🇩🇬', '🇩🇯', '🇩🇰', '🇩🇲', '🇩🇴', '🇩🇿',
    '🇪🇦', '🇪🇨', '🇪🇪', '🇪🇬', '🇪🇭', '🇪🇷', '🇪🇸', '🇪🇹', '🇪🇺',
    '🇫🇮', '🇫🇯', '🇫🇰', '🇫🇲', '🇫🇴', '🇫🇷',
    '🇬🇦',
    '🇬🇧',
    '🇬🇩',
    '🇬🇪',
    '🇬🇫',
    '🇬🇬',
    '🇬🇭',
    '🇬🇮',
    '🇬🇱',
    '🇬🇲',
    '🇬🇳',
    '🇬🇵',
    '🇬🇶',
    '🇬🇷',
    '🇬🇸',
    '🇬🇹',
    '🇬🇺',
    '🇬🇼',
    '🇬🇾',
    '🇭🇰', '🇭🇲', '🇭🇳', '🇭🇷', '🇭🇹', '🇭🇺',
    '🇮🇨',
    '🇮🇩',
    '🇮🇪',
    '🇮🇱',
    '🇮🇲',
    '🇮🇳',
    '🇮🇴',
    '🇮🇶',
    '🇮🇷',
    '🇮🇸',
    '🇮🇹',
    '🇯🇪', '🇯🇲', '🇯🇴', '🇯🇵',
    '🇰🇪',
    '🇰🇬',
    '🇰🇭',
    '🇰🇮',
    '🇰🇲',
    '🇰🇳',
    '🇰🇵',
    '🇰🇷',
    '🇰🇼',
    '🇰🇾',
    '🇰🇿',
    '🇱🇦',
    '🇱🇧',
    '🇱🇨',
    '🇱🇮',
    '🇱🇰',
    '🇱🇷',
    '🇱🇸',
    '🇱🇹',
    '🇱🇺',
    '🇱🇻',
    '🇱🇾',
    '🇲🇦',
    '🇲🇨',
    '🇲🇩',
    '🇲🇪',
    '🇲🇫',
    '🇲🇬',
    '🇲🇭',
    '🇲🇰',
    '🇲🇱',
    '🇲🇲',
    '🇲🇳',
    '🇲🇴',
    '🇲🇵',
    '🇲🇶',
    '🇲🇷',
    '🇲🇸',
    '🇲🇹',
    '🇲🇺',
    '🇲🇻',
    '🇲🇼',
    '🇲🇽',
    '🇲🇾',
    '🇲🇿',
    '🇳🇦',
    '🇳🇨',
    '🇳🇪',
    '🇳🇫',
    '🇳🇬',
    '🇳🇮',
    '🇳🇱',
    '🇳🇴',
    '🇳🇵',
    '🇳🇷',
    '🇳🇺',
    '🇳🇿',
    '🇴🇲',
    '🇵🇦',
    '🇵🇪',
    '🇵🇫',
    '🇵🇬',
    '🇵🇭',
    '🇵🇰',
    '🇵🇱',
    '🇵🇲',
    '🇵🇳',
    '🇵🇷',
    '🇵🇸',
    '🇵🇹',
    '🇵🇼',
    '🇵🇾',
    '🇶🇦',
    '🇷🇪', '🇷🇴', '🇷🇸', '🇷🇺', '🇷🇼',
    '🇸🇦',
    '🇸🇧',
    '🇸🇨',
    '🇸🇩',
    '🇸🇪',
    '🇸🇬',
    '🇸🇭',
    '🇸🇮',
    '🇸🇯',
    '🇸🇰',
    '🇸🇱',
    '🇸🇲',
    '🇸🇳',
    '🇸🇴',
    '🇸🇷',
    '🇸🇸',
    '🇸🇹',
    '🇸🇻',
    '🇸🇽',
    '🇸🇾',
    '🇸🇿',
    '🇹🇦',
    '🇹🇨',
    '🇹🇩',
    '🇹🇫',
    '🇹🇬',
    '🇹🇭',
    '🇹🇯',
    '🇹🇰',
    '🇹🇱',
    '🇹🇲',
    '🇹🇳',
    '🇹🇴',
    '🇹🇷',
    '🇹🇹',
    '🇹🇻',
    '🇹🇼',
    '🇹🇿',
    '🇺🇦', '🇺🇬', '🇺🇲', '🇺🇳', '🇺🇸', '🇺🇾', '🇺🇿',
    '🇻🇦', '🇻🇨', '🇻🇪', '🇻🇬', '🇻🇮', '🇻🇳', '🇻🇺',
    '🇼🇫', '🇼🇸',
    '🇽🇰',
    '🇾🇪', '🇾🇹',
    '🇿🇦', '🇿🇲', '🇿🇼',
    // Subdivision flags (examples)
    '🏴󠁧󠁢󠁥󠁮󠁧󠁿',
    '🏴󠁧󠁢󠁳󠁣󠁴󠁿',
    '🏴󠁧󠁢󠁷󠁬󠁳󠁿',
    '🏴󠁵󠁳󠁴󠁸󠁿',
    '🏴󠁵󠁳󠁣󠁡󠁿',
  ],
};
