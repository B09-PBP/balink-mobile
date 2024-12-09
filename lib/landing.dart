import 'package:flutter/material.dart';
import 'left_drawer.dart';
import 'package:balink_mobile/Product/Screens/product_page_admin.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Balink',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(32, 73, 255, 1),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromRGBO(32, 73, 255, 1), Color.fromRGBO(32, 73, 255, 1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: const EdgeInsets.all(16.0),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image Section
                    Expanded(
                      child: Image.asset(
                        'assets/image 6.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Text Section
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Linking your Road with',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),
                          ),
                          const Row(
                            children: [
                              Text(
                                'Ba',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 203, 48, 1),
                                ),
                              ),
                              Text(
                                'Link',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(32, 73, 255, 1),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromRGBO(32, 73, 255, 1),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () {
                             Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(builder: (context) => const ProductPageAdmin()));
                            },
                            child: const Text(
                              "Let's Go!",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Popular Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                color: Color.fromRGBO(32, 73, 255, 1),
                child: Column(
                  children: [
                    const Text(
                      'Our Popular',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        _buildPopularCard(
                          imagePath: 'assets/mercedes-benz-gls-class.png',
                          title: 'Mercedes-Benz GLS',
                          price: 'Rp1.000.000/day',
                        ),
                        _buildPopularCard(
                          imagePath: 'assets/motor-keren.jpg',
                          title: 'Royal Enfield Thunderbird 350X',
                          price: 'Rp500.000/day',
                        ),
                        _buildPopularCard(
                          imagePath: 'assets/BMW-7-Series.png',
                          title: 'BMW 7 Series 730Ld',
                          price: 'Rp1.000.000/day',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Services Section
              Container(
                padding: const EdgeInsets.all(20.0),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Our Services',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color:Color.fromRGBO(255, 203, 48, 1),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildServiceItem(
                      title: 'Pick-Up and Drop-Off Service',
                      description:
                          'BaLink ensures that customers have the convenience of being picked up and dropped off at their preferred locations.',
                    ),
                    _buildServiceItem(
                      title: 'Daily and Weekly Car Rentals',
                      description:
                          'Customers can choose from a variety of vehicles available for rental on both daily and weekly bases.',
                    ),
                    _buildServiceItem(
                      title: '24/7 Customer Support',
                      description:
                          'BaLink provides round-the-clock customer support, ensuring that any issues or inquiries are addressed promptly.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: const LeftDrawer(),
    );
  }

  Widget _buildPopularCard({
    required String imagePath,
    required String title,
    required String price, 
  }) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Image.asset(imagePath, fit: BoxFit.cover, height: 120),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 14, 
                fontWeight: FontWeight.bold,
                color:Color.fromRGBO(32, 73, 255, 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem({required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, color: Color.fromRGBO(32, 73, 255, 1)),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }
}