import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget{
  final VoidCallback signOut;
  Dashboard(this.signOut);

  @override
  State<Dashboard> createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard>{

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  _buildAppBar() {
    return AppBar(
      title: const Text(
        'Dashboard',
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
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(60.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                'Data',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontFamily: 'Lexend',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
            ),
          ],),
      ),
    );
  }
}