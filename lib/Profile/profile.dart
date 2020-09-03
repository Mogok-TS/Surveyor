import 'package:Surveyor/assets/custom_icons_icons.dart';
import 'package:Surveyor/stores.dart';
import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

var tabIndexs = 0;
List<String> shopList = ['-'];
List<String> userList = ['-'];

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    TabScope _tabScope = TabScope.getInstance();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomIcons.appbarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => StoreScreen(),
              ),
            );
          },
        ),
        title: Text("Profile"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10.0),
              elevation: 5,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                leading: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/logo.png'),
                  ),
                ),
                title: Text("Profile"),
                subtitle: Text("Phone Number"),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10.0),
              height: 60.0,
              color: Colors.red[50],
              child: DefaultTabController(
                length: 4,
                initialIndex: _tabScope.tabIndex,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width: 630.0,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: TabBar(
                        onTap: (index) => setState(() {
                          _tabScope.setTabIndex(index);
                        }),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black,
                        indicator: new BubbleTabIndicator(
                          indicatorRadius: 5.0,
                          indicatorHeight: 35.0,
                          indicatorColor: CustomIcons.appbarColor,
                          tabBarIndicatorSize: TabBarIndicatorSize.tab,
                        ),
                        tabs: [
                          Container(
                            child: new Tab(
                              child: new Text(
                                "User Shop",
                              ),
                            ),
                          ),
                          Container(
                            child: new Tab(
                              child: new Text(
                                "Team",
                              ),
                            ),
                          ),
                          Container(
                            child: new Tab(
                              child: new Text(
                                "Shop Transfer",
                              ),
                            ),
                          ),
                          Container(
                            child: new Tab(
                              child: new Text(
                                "Password Reset",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (tabIndexs == 0)
              Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Container(
                        child: Image(
                          image: AssetImage('assets/logo.png'),
                          width: 60,
                        ),
                      ),
                      title: Text("Profile"),
                      subtitle: Text("Phone Number"),
                    ),
                    ListTile(
                      leading: Container(
                        child: Image(
                          image: AssetImage('assets/logo.png'),
                          width: 60,
                        ),
                      ),
                      title: Text("Profile"),
                      subtitle: Text("Phone Number"),
                    )
                  ],
                ),
              )
            else if (tabIndexs == 1)
              Container(
                child: Column(
                  children: <Widget>[
                    Text("Team"),
                  ],
                ),
              )
            else if (tabIndexs == 2)
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        "Select Shop",
                        style: TextStyle(fontSize: 17, color: Colors.black54),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownButtonHideUnderline(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: DropdownButton(
                            isExpanded: true,
                            items: shopList.map(
                              (val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, top: 20),
                      child: Text(
                        "Select User",
                        style: TextStyle(fontSize: 17, color: Colors.black54),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: DropdownButtonHideUnderline(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: DropdownButton(
                            isExpanded: true,
                            items: userList.map(
                              (val) {
                                return DropdownMenuItem(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 20.0),
                      width: double.infinity,
                      height: 35.0,
                      child: FlatButton(
                        child: Text("Submit"),
                        onPressed: () {},
                        textColor: Colors.white,
                        color: CustomIcons.appbarColor,
                      ),
                    ),
                  ],
                ),
              )
            else if (tabIndexs == 3)
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: TextFormField(
                      // controller: street,
                      cursorColor: CustomIcons.textField,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        labelText: 'Current Password',
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 18),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: TextFormField(
                      // controller: street,
                      cursorColor: CustomIcons.textField,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        labelText: 'New Password',
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 18),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: TextFormField(
                      // controller: street,
                      cursorColor: CustomIcons.textField,
                      decoration: InputDecoration(
                        focusColor: Colors.black,
                        labelText: 'Confirm Password',
                        labelStyle:
                            TextStyle(color: Colors.black54, fontSize: 18),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    width: double.infinity,
                    height: 35.0,
                    child: FlatButton(
                      child: Text("Submit"),
                      onPressed: () {},
                      textColor: Colors.white,
                      color: CustomIcons.appbarColor,
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}

class TabScope {
  static TabScope _tabScope;
  int tabIndex = 0;

  static TabScope getInstance() {
    if (_tabScope == null) _tabScope = TabScope();
    return _tabScope;
  }

  void setTabIndex(int index) {
    tabIndex = index;
    tabIndexs = index;
  }
}
