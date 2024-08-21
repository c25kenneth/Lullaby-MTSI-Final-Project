import 'dart:async';
import 'package:baby_steps/LoadingScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomCarouselFB2 extends StatefulWidget {
  final Completer<GoogleMapController> mapController; 
  const CustomCarouselFB2({Key? key, required this.mapController}) : super(key: key);

  @override
  _CustomCarouselFB2State createState() => _CustomCarouselFB2State();
}

class _CustomCarouselFB2State extends State<CustomCarouselFB2> {
  final double carouselItemMargin = 16;

  late PageController _pageController;
  int _position = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: .9); // Adjusted viewportFraction
  }

  Future<void> _goToTheLocation(DocumentSnapshot doc) async {
    final GoogleMapController controller = await widget.mapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(double.parse(doc.get('lati')), double.parse(doc.get('longi'))), zoom: 15.0)));
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('locations').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> cards = snapshot.data!.docs.map((doc) => CardFb1(text: doc.get('name'), imageUrl: doc.get('img'), subtitle: doc.get('category'), address: doc.get('address'), onPressed: () {
            _goToTheLocation(doc);
            showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      top: Radius.circular(25.0),
    ),
  ),
  builder: (context) {
    return DraggableScrollableSheet(
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                child: Image.network(
                  doc.get('img'),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 50.0), // Added bottom padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doc.get('name'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      doc.get('address'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 18),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Adjusts the container to fit the text
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            doc.get('category'),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  },
);


          })).toList(); 
          return Padding(
            padding: const EdgeInsets.only(top: 8.0), // Adjust top padding as needed
            child: PageView.builder(
              controller: _pageController,
              itemCount: cards.length,
              onPageChanged: (int position) {
                setState(() {
                  _position = position;
                });
              },
              itemBuilder: (BuildContext context, int position) {
                return imageSlider(position, cards);
              },
            ),
          );
        } else {
          return LoadingScreen();
        }
      }
    );
  }

  Widget imageSlider(int position, List<Widget> cards) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, widget) {
        return Container(
          margin: EdgeInsets.all(carouselItemMargin),
          child: Center(child: widget),
        );
      },
      child: Container(
        child: cards[position],
      ),
    );
  }
}

class CardFb1 extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String subtitle;
  final String address; 
  final Function() onPressed;

  const CardFb1({
    required this.text,
    required this.imageUrl,
    required this.subtitle,
    required this.onPressed,
    required this.address,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Adjusted to take 80% of the screen width
        height: 150,
        padding: const EdgeInsets.only(left: 12.0, right: 12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.5),
          boxShadow: [
            BoxShadow(
              offset: const Offset(10, 20),
              blurRadius: 10,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.05),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.fill
                ),
              ),
            ),
            
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    address, 
                    style: TextStyle(color: Colors.grey), 
                    maxLines: 1, 
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Adjusts the container to fit the text
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            subtitle,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
