import 'package:flutter/material.dart';
import 'package:my_delivery_app/common/const/colors.dart';
import 'package:collection/collection.dart';

class RatingCard extends StatelessWidget {
  final ImageProvider avatarImage;
  final List<Image> images;
  final int rating;
  final String email;
  final String content;

  const RatingCard({
    super.key,
    required this.avatarImage,
    required this.images,
    required this.rating,
    required this.email,
    required this.content,
  });

  // factory RatingCard.fromModel({});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(
          rating: rating,
          email: email,
          avatarImage: avatarImage,
        ),
        const SizedBox(height: 8.0),
        _Body(
          content: content,
        ),
        if (images.isNotEmpty)
          SizedBox(
            height: 100.0,
            child: _Images(
              images: images,
            ),
          ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final ImageProvider avatarImage;
  final int rating;
  final String email;

  const _Header(
      {super.key,
      required this.avatarImage,
      required this.rating,
      required this.email});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12.0,
          backgroundImage: avatarImage,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            email,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
        ),
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star : Icons.star_border_outlined,
            color: PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String content;

  const _Body({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            content,
            style: TextStyle(
              color: BODY_TEXT_COLOR,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

class _Images extends StatelessWidget {
  final List<Image> images;

  const _Images({
    super.key,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: images
          .mapIndexed(
            (index, element) => Padding(
              padding: EdgeInsets.only(
                  right: index == images.length - 1 ? 0.0 : 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: element,
              ),
            ),
          )
          .toList(),
    );
  }
}
