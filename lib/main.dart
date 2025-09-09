import 'package:flutter/material.dart';

void main() {
  runApp(CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PantallaCalculadora(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PantallaCalculadora extends StatefulWidget {
  const PantallaCalculadora({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EstadoPantallaCalculadora createState() => _EstadoPantallaCalculadora();
}

class _EstadoPantallaCalculadora extends State<PantallaCalculadora> {
  String valorPantalla = '0';
  String valorPrevio = '';
  String operacion = '';
  bool esperandoNuevoValor = false;

  void botonPresionado(String valor) {
    setState(() {
      if (valor == 'C') {
        // Limpiar
        valorPantalla = '0';
        valorPrevio = '';
        operacion = '';
        esperandoNuevoValor = false;
      } else if (valor == '±') {
        // Cambiar signo
        if (valorPantalla != '0') {
          valorPantalla = valorPantalla.startsWith('-') 
              ? valorPantalla.substring(1) 
              : '-$valorPantalla';
        }
      } else if (valor == '%') {
        // Porcentaje
        double actual = double.parse(valorPantalla);
        valorPantalla = (actual / 100).toString();
        if (valorPantalla.endsWith('.0')) {
          valorPantalla = valorPantalla.substring(0, valorPantalla.length - 2);
        }
      } else if (['+', '-', '×', '÷'].contains(valor)) {
        // Operadores
        if (operacion.isNotEmpty && !esperandoNuevoValor) {
          calcular();
        }
        valorPrevio = valorPantalla;
        operacion = valor;
        esperandoNuevoValor = true;
      } else if (valor == '=') {
        // Igual
        calcular();
        operacion = '';
        valorPrevio = '';
        esperandoNuevoValor = true;
      } else if (valor == '.') {
        // Punto decimal
        if (esperandoNuevoValor) {
          valorPantalla = '0.';
          esperandoNuevoValor = false;
        } else if (!valorPantalla.contains('.')) {
          valorPantalla += '.';
        }
      } else {
        // Números
        if (esperandoNuevoValor) {
          valorPantalla = valor;
          esperandoNuevoValor = false;
        } else {
          valorPantalla = valorPantalla == '0' ? valor : '$valorPantalla$valor';
        }
      }
    });
  }

  void calcular() {
    if (valorPrevio.isEmpty || operacion.isEmpty) return;

    double previo = double.parse(valorPrevio);
    double actual = double.parse(valorPantalla);
    double resultado = 0;

    switch (operacion) {
      case '+':
        resultado = previo + actual;
        break;
      case '-':
        resultado = previo - actual;
        break;
      case '×':
        resultado = previo * actual;
        break;
      case '÷':
        if (actual != 0) {
          resultado = previo / actual;
        } else {
          valorPantalla = 'Error';
          return;
        }
        break;
    }

    valorPantalla = resultado.toString();
    
    // Quitar .0 si es número entero
    if (valorPantalla.endsWith('.0')) {
      valorPantalla = valorPantalla.substring(0, valorPantalla.length - 2);
    }
    
    esperandoNuevoValor = true;
  }

  Widget construirBoton(String valor, {Color? color, Color? colorTexto}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[300],
            foregroundColor: colorTexto ?? Colors.black,
            padding: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            elevation: 2,
          ),
          onPressed: () => botonPresionado(valor),
          child: Text(
            valor,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Calculadora',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Pantalla
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Text(
                valorPantalla,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          
          // Botones
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Primera fila: C, ±, %, ÷
                Row(
                  children: [
                    construirBoton('C', color: Colors.grey[400], colorTexto: Colors.black),
                    construirBoton('±', color: Colors.grey[400], colorTexto: Colors.black),
                    construirBoton('%', color: Colors.grey[400], colorTexto: Colors.black),
                    construirBoton('÷', color: Colors.orange, colorTexto: Colors.white),
                  ],
                ),
                
                // Segunda fila: 7, 8, 9, ×
                Row(
                  children: [
                    construirBoton('7', color: Colors.grey[700], colorTexto: Colors.white),
                    construirBoton('8', color: Colors.grey[700], colorTexto: Colors.white),
                    construirBoton('9', color: Colors.grey[700], colorTexto: Colors.white),
                    construirBoton('×', color: Colors.orange, colorTexto: Colors.white),
                  ],
                ),
                
                // Tercera fila: 4, 5, 6, -
                Row(
                  children: [
                    construirBoton('4', color: Colors.grey[700], colorTexto: Colors.white),
                    construirBoton('5', color: Colors.grey[700], colorTexto: Colors.white),
                    construirBoton('6', color: Colors.grey[700], colorTexto: Colors.white),
                    construirBoton('-', color: Colors.orange, colorTexto: Colors.white),
                  ],
                ),
                
                // Cuarta fila: 1, 2, 3, +
                Row(
                  children: [
                    construirBoton('1', color: Colors.grey[700], colorTexto: Colors.white),
                    construirBoton('2', color: Colors.grey[700], colorTexto: Colors.white),
                    construirBoton('3', color: Colors.grey[700], colorTexto: Colors.white),
                    construirBoton('+', color: Colors.orange, colorTexto: Colors.white),
                  ],
                ),
                
                // Quinta fila: 0, ., =
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.all(4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[700],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () => botonPresionado('0'),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                '0',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    construirBoton('.', color: Colors.grey[700], colorTexto: Colors.white),
                    construirBoton('=', color: Colors.orange, colorTexto: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}