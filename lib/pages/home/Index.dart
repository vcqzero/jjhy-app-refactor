import 'package:app/api/AppSetings.dart';
import 'package:flutter/material.dart';
import 'package:app/widgets/MyWidgets.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    AppSetings.getBanners().then((response) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyWidgets.getAppBar(hidden: true),
      body: Column(
        children: [
          Container(
            child: Image.network(
              'https://api.jjhycom.cn/storage/appClient/banners/ecaLvi1yGGpX3EtSpADD69nZzZv4yDWpVC6IQbOj.jpeg',
              fit: BoxFit.contain,
            ),
          ),
          Expanded(
            flex: 1,
            child: GridView.count(
              crossAxisCount: 3,
              children: [
                Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Container(
                          color: Colors.pink[400],
                          height: 64,
                          width: 64,
                          child: Icon(
                            Icons.wifi,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          'data',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
                Text('data'),
              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
