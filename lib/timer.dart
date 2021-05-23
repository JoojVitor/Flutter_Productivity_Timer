import 'dart:async';
import './timermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountDownTimer {
  double _radius = 1;
  bool _isActive = true;
  Timer timer;
  Duration _time;
  Duration _fullTime;
  int work = 10;
  int shortBreak = 5;
  int longBreak = 20;

  String returnTime(Duration duration) {
    //retorna a duração em uma string formatada.
    String minutes = formatBelowTen(duration.inMinutes);
    int numSeconds = duration.inSeconds - (duration.inMinutes * 60);
    String seconds = formatBelowTen(numSeconds);
    String formattedTime = minutes + ":" + seconds;
    return formattedTime;
  }

  String formatBelowTen(int value){
    //método para acrescentar o '0' caso o valor no timer for menor que '10'.
    return value < 10
        ? '0' + value.toString()
        : value.toString();
  }

  Stream<TimerModel> stream() async* {
    //método assíncrono que produz um valor a cada segundo.
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if (_isActive) {
        //caso o timer esteja ativo, a duração será decrementada em um segundo.
        _time = _time - Duration(seconds: 1);
        _radius = _time.inSeconds / _fullTime.inSeconds;
        if (_time.inSeconds <= 0) {
          //caso o timer seja zerado, seu estado mudará para inativo.
          _isActive = false;
        }
      }
      time = returnTime(_time);
      return TimerModel(time, _radius);
    });
  }

  Future readSettings() async {
    //lê as configurações dos valores de cada função dos botões,
    //aplica valores padrões caso não possuir configuração cadastrada.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    work = prefs.getInt('workTime') == null
        ? 10 : prefs.getInt('workTime');
    shortBreak = prefs.getInt('shortBreak') == null
        ? 5 : prefs.getInt('shortBreak');
    longBreak = prefs.getInt('longBreak') == null
        ? 20 : prefs.getInt('longBreak');
  }
  
  void stopTimer() {
    //para o contador.
    _isActive = false;
  }

  void startTimer() {
  //inicia o contador, caso não estiver zerado.
    if (_time.inSeconds > 0) {
      _isActive = true;
    }
  }

  void startWork() async{
    //inicia o contador ao iniciar a aplicação com o valor configurado para o
    //'work', como padrão.
    await readSettings(); 
    _radius = 1;
    _time = Duration(minutes: work, seconds: 0);
    _fullTime = _time;
  }

  void startBreak(bool isShort) {
    //executa a função dos botões 'break', recebendo um  booleano como parâmetro
    //para indicar se é 'short break', dependendo do valor, acrescentará o valor
    //configurado para a opção selecionada.
    _radius = 1;
    _time = Duration(
      minutes: (isShort)
          ? shortBreak
          : longBreak,
      seconds: 0);
    _fullTime = _time;
  }
}
