import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:maptest/constants/colors.dart';
import 'package:maptest/data/models/placeSuggestion.dart';

class PlaceItem extends StatelessWidget {
  final PlaceSuggestion placeSuggestion;
  const PlaceItem({Key? key, required this.placeSuggestion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var subTitile = placeSuggestion.description!
        .replaceAll(placeSuggestion.description!.split(',')[0], '');
    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.all(8),
      padding: const EdgeInsetsDirectional.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: MyColors.lightblue,
              ),
              child: const Icon(
                Icons.place,
                color: Colors.blue,
              ),
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${placeSuggestion.description!.split(',')[0]}\n',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: subTitile.substring(2),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
