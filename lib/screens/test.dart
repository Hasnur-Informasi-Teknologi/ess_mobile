import 'package:flutter/material.dart';



class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String selectedType = 'type1';

  Widget _buildComponent() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: _getComponentByKey(selectedType),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  Widget _getComponentByKey(String key) {
    switch (key) {
      case 'type1':
        return ComponentType1();
      case 'type2':
        return ComponentType2();
      case 'type3':
        return ComponentType3();
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Component Selector'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: selectedType,
            onChanged: (newValue) {
              setState(() {
                selectedType = newValue!;
              });
            },
            items: [
              DropdownMenuItem(
                value: 'type1',
                child: Text('Type 1'),
              ),
              DropdownMenuItem(
                value: 'type2',
                child: Text('Type 2'),
              ),
              DropdownMenuItem(
                value: 'type3',
                child: Text('Type 3'),
              ),
            ],
          ),
          _buildComponent(),
        ],
      ),
    );
  }
}

class ComponentType1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Component Type 1'),
    );
  }
}

class ComponentType2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Component Type 2'),
    );
  }
}

class ComponentType3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('This is Component Type 3'),
    );
  }
}
