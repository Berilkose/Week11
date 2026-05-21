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
    notifyListeners();// notifyListeners() fonksiyonu, MyAppState sınıfını dinleyen widgetlere, verilerin değiştiğini bildirir ve bu widgetlerin yeniden oluşturulmasını sağlar. 
  }
  // Favorites listesi, kullanıcı tarafından favorilere eklenen kelime çiftlerini saklamak için kullanılır. toggleFavorite() fonksiyonu, 
  //current değişkeninin favorites listesinde olup olmadığını kontrol eder ve buna göre ekleme veya çıkarma işlemi yapar. 
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget { // uygulamanın ana sayfasını tanımlar, bu sayfa uygulamanın ana içeriğini gösterir.
  @override
  Widget build(BuildContext context) { // Build fonksiyonu, widget ağacını oluşturur ve günceller. 
    var appState = context.watch<MyAppState>();
    var pair = appState.current; 

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center( // Center widgeti ile içindeki widgetler ortalanmış olur.
        child: Column( // Column widgeti, diğer widgetleri dikey olarak sıralar.
        mainAxisAlignment: MainAxisAlignment.center, // dikey eksen üzerinde ortalamak için kullanılır. 
          children: [
            Text('A random AWESOME idea:'), 
            BigCard(pair: pair), // text olanı ayrı bir widget olarak tanımladık, bu widgeti BigCard olarak adlandırdık ve pair değişkenini bu widgete gönderdik.
            SizedBox(height: 10),// SizedBox widgeti, diğer widgetler arasında belirli bir boşluk oluşturmak için kullanılır. Bu örnekte, BigCard widgeti ile ElevatedButton widgeti arasında 10 birimlik bir boşluk oluşturulur.
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [ // like butonunun icon u eklenmiş oldu.
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),

                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();// bu butona tıklandığında getNext() fonksiyonu çağrılır ve uygulama güncellenir.
                  },
                  child: Text('Next'),
                ),
              ],
            ),
        
          ],
        ),
      ),
    );
  }
}

// Bu otomatik olarak BigCard widgetini oluşturur ve pair değişkenini bu widgete gönderir. BigCard widgeti, pair değişkenini kullanarak bir metin oluşturur ve bu metni ekranda gösterir. 
//ElevatedButton widgeti ise, kullanıcıya bir buton sağlar ve bu butona tıklandığında getNext() fonksiyonunu çağırarak uygulamanın güncellenmesini sağlar.
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // renk seçiminde kullanılan temayı alır. Bu, uygulamanın genel görünümünü ve hissini belirler.
    final style = theme.textTheme.displayMedium!.copyWith( // yazı stilini belirler. 
    );
    return Card( //Text widgetini bir Card widgeti içine yerleştirir. Card widgeti, içeriği görsel olarak vurgulamak için kullanılır ve genellikle kenarlık, gölge ve yuvarlatılmış köşeler gibi özelliklere sahiptir.
      color: theme.colorScheme.primary,
      child: Padding( // Padding widgeti, içindeki widgete belirli bir boşluk ekler. Bu örnekte, Text widgetine 8.0 birimlik bir boşluk eklenir.
        padding: const EdgeInsets.all(20.0),
        child: Text( //Burada Text widgeti, pair değişkenini kullanarak oluşturulan metni ekranda gösterir. pair.asLowerCase ifadesi, 
        //pair değişkenindeki kelime çiftini küçük harflerle birleştirir ve bu metni Text widgetine verir. style parametresi ise, metnin görünümünü belirler.
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}