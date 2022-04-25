import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({Key? key}) : super(key: key);

  @override
  _RecommendationState createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  final CarouselController _controller = CarouselController();

  Widget recommendationContainer(header, content) {
    var size = MediaQuery.of(context);

    return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      elevation: 0.0,
      title: Container(
        height: 80,
        padding: EdgeInsets.all(8),
        color: Colors.purple[200],
        child: Text(
          header.toString(),
          textAlign: TextAlign.start,
        ),
      ),
      content: Container(
        padding: EdgeInsets.all(8),
        width: size.size.width * 0.8,
        height: size.size.width * 1,
        child: Text(
          content.toString(),
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context);
    return Center(
      child: SingleChildScrollView(
        child: Container(
          height: size.size.height * 0.6,
          width: size.size.width * 0.8,
          // padding: EdgeInsets.only(left: 10,right: 10),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: CarouselSlider(
                  items: [
                    recommendationContainer(
                        'Check that you’re using the correct wattage in all your fixtures and appliances.',
                        'Using the right bulbs can prevent electrical problems, so check all lamps, fixtures and appliances to ensure you’re using the correct wattage. If a light fixture has no wattage listed, use 60-watt bulbs or less. For unmarked ceiling fixtures, choose 25-watt bulbs.'),
                    recommendationContainer(
                        'Watch out for overloaded outlets to protect your home.',
                        'Overloading an electrical outlet is a common cause of electrical problems. Check all outlets to ensure they are cool to the touch, have protective faceplates and are in proper working order.'),
                    recommendationContainer(
                        'Replace or repair damaged electrical cords to keep your home safe.',
                        'Damaged power cords are a serious residential electrical safety risk, and they are capable of causing both fires and electrocution. All power and extension cords should be checked regularly for signs of fraying and cracking, and they should then be repaired or replaced as needed. '),
                  ],
                  options: CarouselOptions(
                      enlargeCenterPage: true,
                      autoPlay: false,
                      viewportFraction: 1,
                      height: size.size.height,
                      enableInfiniteScroll: false),
                  carouselController: _controller,
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.purple[300])
                        ),
                        onPressed: () => _controller.previousPage(),
                        child: FaIcon(
                          FontAwesomeIcons.arrowLeft,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.purple[300])
                        ),
                        onPressed: () => _controller.nextPage(),
                        child: FaIcon(
                          FontAwesomeIcons.arrowRight,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      )
    );
  }
}
