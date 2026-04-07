import 'package:flutter/material.dart';

import '../../../../core_widget/common_button.dart';

class ReviewBottomSheet extends StatelessWidget {
  const ReviewBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController titleController = TextEditingController();
    final TextEditingController reviewController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "Create Review",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context), // sheet close
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Name
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Name",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey, // border ka color grey
                  width: 1.0,
                ),
              ),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Enter your name",
                  border: InputBorder.none, // default border hata diya
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Email
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Email ID",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey, // border ka color grey
                  width: 1.0,
                ),
              ),
              child: TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Enter Email ID",
                  border: InputBorder.none, // default border hata diya
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Review Title
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Review Title",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey, // border ka color grey
                  width: 1.0,
                ),
              ),
              child: TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Enter your review subject",
                  border: InputBorder.none, // default border hata diya
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Review Text
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Review",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextField(
              controller: reviewController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Write your review",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
                width: double.infinity,
                child: CommonButton(
                    onTap: () {}, buttonText: "Submit Your Review"))
          ],
        ),
      ),
    );
  }
}
