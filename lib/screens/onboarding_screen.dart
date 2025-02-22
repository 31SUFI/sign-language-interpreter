import 'package:flutter/material.dart';
import 'package:gemini_api/screens/sign_language_interpreter_screen.dart';

class OnBoardingData {
  final String title;
  final String description;
  final IconData icon;

  OnBoardingData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int activeIndex = 0;

  final List<OnBoardingData> data = [
    OnBoardingData(
      title: "Real-time Sign Language Interpreter",
      description:
          "Transform sign language into text instantly using your camera",
      icon: Icons.sign_language,
    ),
    OnBoardingData(
      title: "Powered by AI",
      description:
          "Advanced AI technology helps interpret signs accurately and quickly",
      icon: Icons.psychology,
    ),
    OnBoardingData(
      title: "Easy to Use",
      description:
          "Just point your camera, start the interpreter, and get instant translations",
      icon: Icons.camera_alt,
    ),
  ];

  void _onGetStarted() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignLanguageInterpreterScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Expanded(
              child: PageView.builder(
                itemCount: data.length,
                controller: _controller,
                onPageChanged: (page) {
                  setState(() {
                    activeIndex = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          duration: const Duration(milliseconds: 500),
                          scale: activeIndex == index ? 1 : 0.8,
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue[50],
                            ),
                            child: Icon(
                              data[index].icon,
                              size: 100,
                              color: Colors.blue[600],
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 500),
                          opacity: activeIndex == index ? 1 : 0,
                          child: Column(
                            children: [
                              Text(
                                data[index].title,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                data[index].description,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      data.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        height: 8,
                        width: activeIndex == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: activeIndex == index
                              ? Colors.blue[600]
                              : Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _onGetStarted,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
