import 'package:flutter/material.dart';

class Rating extends StatelessWidget {
  final int starCount;
  final double rating;
  final void Function(double rate)? onRatingChanged;
  final bool isDisable;
  final double? size;

  const Rating({super.key, this.starCount = 5, this.rating = .0, this.onRatingChanged ,required this.isDisable, this.size});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    final width = MediaQuery.of(context).size.width;
    double size1 = 16;

    //Deciding size of star based on screen size
    if(width<=390){
      size1 = 18;
    }else if(width < 420 && width >390 ){
      size1 = 20;
    }else{
      size1 = 26;
    }

    //Display single unbordered star
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        size: size ?? size1,
        color: Theme.of(context).colorScheme.onBackground,
      );
    }
    //Display half border star
    else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        size: size ?? size1,
        color: Theme.of(context).colorScheme.onBackground,
      );
    }
    //Display full star
    else {
      icon = Icon(
        Icons.star,
        size: size ?? size1,
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
