import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget { // uygulamayı şekillendirir, widgetleri ve diğer ayarlamalar burada yapılır.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Application',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random(); // bu class uygulamanın çalışması için gereken verileri tanımlar.
  // uygulamanın asıl verisi bu class içinde tanımlanır ve bu veriler değiştiğinde uygulamanın güncellenmesi için notifyListeners() fonksiyonu çağrılır. 
  void getNext() {// bu fonksiyon, current değişkenini yeni bir rastgele kelime çifti ile günceller ve ardından notifyListeners() fonksiyonunu çağırarak uygulamanın güncellenmesini sağlar.
    current = WordPair.random();
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget { // uygulamanın ana sayfasını tanımlar, bu sayfa uygulamanın ana içeriğini gösterir.
  @override
  Widget build(BuildContext context) { // Build fonksiyonu, widget ağacını oluşturur ve günceller. 
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column( // Column widgeti, diğer widgetleri dikey olarak sıralar.
        children: [
          Text('A random AWESOME idea:'),
          Text(appState.current.asLowerCase),

          // ↓ Add this.
          ElevatedButton(
            onPressed: () {
              appState.getNext();// bu butona tıklandığında getNext() fonksiyonu çağrılır ve uygulama güncellenir.
            },
            child: Text('Next'),
          ),

        ],
      ),
    );
  }
}