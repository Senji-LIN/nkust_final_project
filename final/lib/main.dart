import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:final_project/DatabaseHelper.dart';
import 'package:final_project/database.dart';

final player=AudioPlayer();
final player2=AudioPlayer();

void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}
int _currentindex=0;
class _MyAppState extends State<MyApp> {
  @override
  List<bool>type_list=[];
  List<bool>color_list=[];
  List<bool>lock=[];
  bool color=false;
  String text="黑棋回合";
  String icon1="icon0.png";
  String icon2="icon3.png";
  int number=0;
  String ttteset="";
  final dbHelper = DatabaseHelper.instance;

  _MyAppState(){
    for (var x = 0; x < 100; ++x) {
      type_list.add(false);
      color_list.add(false);
      lock.add(false);
    }
  }
  reset(){
    for (var x = 0; x < 100; ++x) {
      type_list[x]=false;
      color_list[x]=false;
      lock[x]=false;
      number=0;
      icon1="icon0.png";
      icon2="icon3.png";
    }
    color=false;
    text="黑棋回合";
    setState((){});
  }
  void insert() async {
    var backgammon = Backgammon(
      type_list: "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      color_list: "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
      lock: "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    );
    dbHelper.insert(backgammon.toMap());
  }
  void load() async {
    final rows = await dbHelper.queryAllRows();
    print("load");
    if(rows.length>0){
      type_list = string_to_boolist(rows[0]["type_list"], 100);
      color_list = string_to_boolist(rows[0]["color_list"], 100);
      lock = string_to_boolist(rows[0]["lock"], 100);
      determination(-66);
    }
  }
  void save()async{
    var backgammon = Backgammon(
      id: 1,
      type_list: boolist_to_string(type_list,100),
      color_list: boolist_to_string(color_list,100),
      lock: boolist_to_string(lock,100),
    );
    final rows = await dbHelper.queryAllRows();
    if(rows.length<1){
      print("insert");
      dbHelper.insert(backgammon.toMap());
    }
    else{
      print("update");
      dbHelper.update(backgammon.toMap());
    }
  }
  determination(int loc){
    int counter=-1;
    int now;
    int next;
    int longest=0;
    bool now_color=true;
    for(int x=0;x<100;++x){
      if(type_list[x]){
        now_color=!now_color;
      }
    }
    color=!now_color;
    var walk_list=[-10,10,-1,1,-11,11,-9,9];
    //上下, 左右, 左上 右下, 右上 左下
    for(int x=0;x<4;++x) {
      counter=1;
      for (int y = 0; y < 2; ++y) {
        next = loc;
        while ((next + walk_list[2*x+y]>= 0) && (next + walk_list[2*x+y] < 100))  {
          now=next;
          next += walk_list[2*x+y];
          if(((next%10)-(now%10))*((next%10)-(now%10))>1){
            break;
          }
          if(type_list[next]==true && (color_list[next] == now_color)){
            counter +=1;
          }
          else {
            break;
          }
        }
      }
      //print(counter);
      if(counter>longest){
        longest=counter;
      }
    }
    //print(longest);
    if(longest>=5){
      for (var x = 0; x < 100; ++x) {
        lock[x]=true;
      }
      text=now_color?"白棋勝利":"黑棋勝利";
      icon1=now_color?"icon1.png":"icon0.png";
      icon2=now_color?"icon1.png":"icon0.png";
      setState((){});
    }
    else if(number>=100){
      text="和局";
      icon1="icon0.png";
      icon2="icon1.png";
      setState((){});
    }
    else{
      text=now_color?"黑棋回合":"白棋回合";
      icon1=now_color?"icon0.png":"icon2.png";
      icon2=now_color?"icon3.png":"icon1.png";
      setState((){});
    }
  }
  String boolist_to_string(List<bool>input,int long){
    String output="";
    for(int x=0;x<long ;++x){
      if(input[x]) {
        output+="1";
      }
      else{
        output+="0";
      }
    }
    return output;
  }
  List<bool> string_to_boolist(String input,int long){
    List<bool>output=[];
    for(int x=0;x<long ;++x){
      if(input[x]=="1") {
        output.add(true);
      }
      else{
        output.add(false);
      }
    }
    return output;
  }
  Widget build(BuildContext context) {
    player.play(AssetSource("BGM.mp3"));
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('五子棋'),),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(

              width: double.infinity,height: 80,
              decoration: BoxDecoration(
                boxShadow: [ BoxShadow(color: Colors.green,),
                ],),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Image.asset('images/'+icon1),
                    height: 80,
                    width: 80,
                  ),
                  Text(text,style: TextStyle(fontSize: 40,color: Colors.white,fontWeight:FontWeight.bold), textAlign: TextAlign.center,),
                  Container(
                    child: Image.asset('images/'+icon2),
                    height: 80,
                    width: 80,
                  ),
                ],
              ),
            ),
            Container(
              width: 330,height: 330,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [ BoxShadow(color: Colors.indigoAccent,),
                ],),
              child: Column(
                children:[
                  SizedBox(height: 15,),
                  for(int x=0;x<10;++x)...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for(int y=0;y<10;++y)...[
                          Container(
                              width: 30,height: 30,
                              child: InkWell(
                                  onTap:() {
                                    if(!lock[x*10+y]){
                                      player2.play(AssetSource("chess.mp3"));
                                      color_list[x*10+y]=color;
                                      type_list[x*10+y]=true;
                                      lock[x*10+y]=true;
                                      color=!color;
                                      setState((){});
                                      number+=1;
                                      determination(x*10+y);
                                    }
                                  },
                                  child: Image(image:AssetImage(type_list[x*10+y]?(color_list[x*10+y]?'images/white.jpg':'images/black.jpg'):'images/nan.jpg'),fit: BoxFit.fill)
                              )
                          ),
                        ]
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: double.infinity,height: 80,
              decoration: BoxDecoration(
                boxShadow: [ BoxShadow(color: Colors.green,),
                ],),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children:[
                  Container(
                    width: 95,
                    child:TextButton(
                      child: Text(
                        "SAVE",style: TextStyle(color: Colors.yellow,fontSize: 25,),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        save();
                      },
                    ),
                  ),
                  Container(
                    width: 95,
                    child:TextButton(
                      child: Text(
                        "LOAD",style: TextStyle(color: Colors.yellow,fontSize: 25,),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        load();
                      },
                    ),
                  ),
                  Container(
                    width: 95,
                    child:TextButton(
                      child: Text(
                        "RESET",style: TextStyle(color: Colors.yellow,fontSize: 25,),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        reset();
                      },
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