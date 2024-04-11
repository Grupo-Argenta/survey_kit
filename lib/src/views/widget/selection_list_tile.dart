import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectionListTile extends StatelessWidget {
  final String text;
  final Function onTap;
  final bool isSelected;

  const SelectionListTile({
    Key? key,
    required this.text,
    required this.onTap,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: ListTile(
            title: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(
                    color: isSelected
                        ? Colors.blue
                        : Theme.of(context).textTheme.headlineSmall?.color,
                  )
                  .merge(GoogleFonts.notoColorEmoji()),
            ),
            trailing: isSelected
                ? Icon(
                    Icons.check,
                    size: 32,
                    color: isSelected ? Colors.blue : Colors.black,
                  )
                : Container(
                    width: 32,
                    height: 32,
                  ),
            onTap: () => onTap.call(),
          ),
        ),
        Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}
