import 'package:balink_mobile/review/models/review_models.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:balink_mobile/review/screens/review_edit.dart';

class YourReviewPage extends StatefulWidget {
  const YourReviewPage({super.key});

  @override
  State<YourReviewPage> createState() => _YourReviewPageState();
}

class _YourReviewPageState extends State<YourReviewPage> {
  Future<List<ReviewModels>> fetchreviews(CookieRequest request) async {
    final response = await request.get('https://nevin-thang-balink.pbp.cs.ui.ac.id/review/user-review-flutter/');
    var data = response;

    List<ReviewModels> listReview = [];
    for (var d in data) {
      if (d != null) {
        listReview.add(ReviewModels.fromJson(d));
      }
    }
    return listReview;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    const Color blue400 = Color.fromRGBO(32, 73, 255, 1);
    const Color yellow = Color.fromRGBO(255, 203, 48, 1);

    // Get screen size
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 600;
    final isDesktop = screenSize.width >= 1024;

    // Responsive font sizes
    final titleFontSize = isDesktop ? 28.0 : (isTablet ? 26.0 : 24.0);
    final cardTitleSize = isDesktop ? 16.0 : (isTablet ? 15.0 : 14.0);
    final bodyTextSize = isDesktop ? 15.0 : (isTablet ? 14.0 : 13.0);

    // Responsive padding
    final mainPadding = isDesktop ? 24.0 : (isTablet ? 20.0 : 16.0);
    final cardPadding = isDesktop ? 16.0 : (isTablet ? 14.0 : 12.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: isDesktop ? 70 : (isTablet ? 60 : 56),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Your ",
              style: TextStyle(
                color: yellow,
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize,
              ),
            ),
            Text(
              "Review",
              style: TextStyle(
                color: blue400,
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize,
              ),
            ),
            Icon(
              Icons.star_rounded,
              color: yellow,
              size: titleFontSize + 4,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<List<ReviewModels>>(
              future: fetchreviews(request),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'You haven\'t reviewed yet',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          color: Colors.black,
                        ),
                      ),
                    );
                  } else {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        // Responsive grid layout
                        int crossAxisCount;
                        if (constraints.maxWidth > 1200) {
                          crossAxisCount = 4;
                        } else if (constraints.maxWidth > 900) {
                          crossAxisCount = 3;
                        } else if (constraints.maxWidth > 600) {
                          crossAxisCount = 2;
                        } else {
                          crossAxisCount = 1;
                        }

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(mainPadding),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: mainPadding,
                            mainAxisSpacing: mainPadding,
                            childAspectRatio: isDesktop ? 0.8 : (isTablet ? 0.75 : 0.7),
                          ),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) {
                            final review = snapshot.data![index];
                            return Container(
                              padding: EdgeInsets.all(cardPadding),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey[300]!),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      review.image,
                                      height: isDesktop ? 160 : (isTablet ? 140 : 120),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: isDesktop ? 160 : (isTablet ? 140 : 120),
                                          color: Colors.grey,
                                          alignment: Alignment.center,
                                          child: const Icon(Icons.error, color: Colors.red),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: cardPadding),
                                  Text(
                                    review.rideName,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: cardTitleSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: cardPadding * 0.5),
                                  Text(
                                    "⭐ ${review.rating}",
                                    style: TextStyle(
                                      color: yellow,
                                      fontSize: bodyTextSize,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: cardPadding * 0.5),
                                  Expanded(
                                    child: Text(
                                      review.reviewMessage,
                                      maxLines: isDesktop ? 4 : 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: bodyTextSize,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: cardPadding * 0.5),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: cardPadding),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EditReviewPage(
                                              id: review.id,
                                              rideName: review.rideName,
                                              image: review.image,
                                              currentRating: review.rating,
                                              currentReviewMessage: review.reviewMessage,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        foregroundColor: WidgetStateProperty.all(Colors.white),
                                        padding: WidgetStateProperty.all(
                                          EdgeInsets.symmetric(
                                            vertical: isDesktop ? 16 : (isTablet ? 14 : 12),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(fontSize: bodyTextSize),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}