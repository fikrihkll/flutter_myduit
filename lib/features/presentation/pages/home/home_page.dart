import 'package:flutter/material.dart';
import 'package:myduit/core/firebase_util.dart';
import 'package:myduit/features/presentation/pages/route.dart' as route;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController inputController = TextEditingController();

  List<String> listNama = [];

  void onButtonClicked() {
    listNama.add(inputController.text);
    setState(() {});
  }

  Widget sectionGambar() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 32),
          child: Text(
            "Gambar",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        Image.network("https://avatars.githubusercontent.com/u/57880863?v=4"),
        Image.network("https://avatars.githubusercontent.com/u/57880863?v=4"),
      ],
    );
  }

  Widget sectionInput() {
    return Column(
      children: [
        Text("halo 1"),
        Text("halo 2"),
        Row(
          children: [
            Text("halo 3"),
            SizedBox(
              width: 32,
            ),
            Text("halo 4"),
          ],
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
                hintText: "Nama",
                labelText: "Nama"
            ),
            controller: inputController,
          ),
        ),
        MaterialButton(
          onPressed: () {
            onButtonClicked();
          },
          color: Colors.blue,
          child: Text(
            "Press Me",
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
        Text(inputController.text),
        ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: listNama.length,
            itemBuilder: (context, position){
              return itemList2(position);
            })
      ],
    );
  }

  Widget sectionList() {
    return Column(
      children: [
        SizedBox(
          height: 32,
        ),
        Text(
          "List",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        ),
        ListView.builder(
            primary: false, // Matiin Scroll
            shrinkWrap: true, // Menjadikan Height List sebanyak item
            itemCount: 5,
            itemBuilder: (context, position) {
              return itemList(position);
            }
        )
      ],
    );
  }

  Widget itemList2(int positionList) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.9),
            spreadRadius: 5,
            blurRadius: 5,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "${listNama[positionList]}",
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ],
      ),
    );
  }

  Widget itemList(int positionList) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.9),
            spreadRadius: 5,
            blurRadius: 5,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Burger $positionList",
            style: TextStyle(
                color: Colors.white
            ),
          ),
          Text(
            "Rp.12.000",
            style: TextStyle(
                color: Colors.white
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                FirebaseUtil.signOut();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("See you later!")));
                Navigator.of(context).pushNamedAndRemoveUntil(route.loginPage, (route) => false);
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionInput(),
            sectionGambar(),
            sectionList(),
            MaterialButton(
                child: Text("MOVE ON"),
                onPressed: () {
                  Navigator.pushNamed(context, route.detailPage);
                }
            )
          ],
        ),
      ),
    );
  }
}
