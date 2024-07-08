import 'package:flutter/material.dart';
import 'package:game_tracker/controllers/review_controller.dart';
import 'package:game_tracker/models/game.dart';
import 'package:game_tracker/models/review.dart';

class ReviewPage extends StatefulWidget {
  final VoidCallback signOut;
  final Game game;
  final int userId;

  ReviewPage({required this.signOut, required this.game, required this.userId});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final ReviewController reviewController = ReviewController();
  final _formKey = GlobalKey<FormState>();
  double _score = 0.0;
  String _description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Review Game',
          style: TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontFamily: 'Lexend',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: Icon(Icons.lock_open),
          )
        ],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'New Review',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'Lexend',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _inputField("Score (0-10)", isNumeric: true),
                  const SizedBox(height: 10),
                  _inputField("Description"),
                  const SizedBox(height: 50),
                  _submitBtn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField(String hintText, {bool isNumeric = false}) {
    return TextFormField(
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Lexend'),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hintText';
        }
        if (isNumeric && (double.tryParse(value) == null || double.parse(value) < 0.0 || double.parse(value) > 10.0)) {
          return 'Please enter a valid score between 0.0 and 10.0';
        }
        return null;
      },
      onSaved: (value) {
        if (hintText.contains("Score")) {
          _score = double.parse(value!);
        } else {
          _description = value!;
        }
      },
    );
  }

  Widget _submitBtn() {
    return ElevatedButton(
      onPressed: () {
        _submit();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 109, 49, 237),
      ),
      child: const SizedBox(
        width: double.infinity,
        child: Text(
          "Submit Review",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontFamily: 'Lexend', color: Colors.white),
        ),
      ),
    );
  }

  void _submit() async {
    final form = _formKey.currentState;

    if (form!.validate()) {
      form.save();

      if (widget.game.id != null) {
        try {
          Review newReview = Review(
            userId: widget.userId,
            gameId: widget.game.id!,
            score: _score,
            description: _description,
            date: DateTime.now().toString(),
          );

          await reviewController.saveReview(newReview);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Review created successfully!')),
          );

          Navigator.pop(context);

        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to create review: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid game ID')),
        );
      }
    }
  }

  void signOut() {
    setState(() {
      widget.signOut();
    });
  }
}
