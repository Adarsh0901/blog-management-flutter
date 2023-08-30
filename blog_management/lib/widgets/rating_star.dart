import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final int starCount;
  final double rating;
  final void Function(double rate)? onRatingChanged;
  final bool isDisable;

  const Rating({super.key, this.starCount = 5, this.rating = .0, this.onRatingChanged ,required this.isDisable});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    final width = MediaQuery.of(context).size.width;
    double size = 16;
    if(width<=390){
      size = 18;
    }else if(width < 420 && width >390 ){
      size = 20;
    }else{
      size = 26;
    }
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        size: size,
        color: Theme.of(context).colorScheme.onBackground,
      );
    }
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        size: size,
        color: Theme.of(context).colorScheme.onBackground,
      );
    } else {
      icon = Icon(
        Icons.star,
        size: size,
        color: Theme.of(context).colorScheme.onBackground,
      );
    }
    return InkResponse(
      onTap: isDisable ? null : () {onRatingChanged!(index + 1.0);},
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: List.generate(starCount, (index) => buildStar(context, index)));
  }
}
