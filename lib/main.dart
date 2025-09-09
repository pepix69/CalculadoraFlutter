import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Flutter',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const PantallaCalculadora(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PantallaCalculadora extends StatefulWidget {
  const PantallaCalculadora({super.key});

  @override
  State<PantallaCalculadora> createState() => _EstadoPantallaCalculadora();
}

class _EstadoPantallaCalculadora extends State<PantallaCalculadora> {
  String expresion = ''; // toda la operación
  String resultado = '0'; // resultado actual
  List<String> historial = []; // lista de operaciones previas

  void botonPresionado(String valor) {
    setState(() {
      if (valor == 'C') {
        expresion = '';
        resultado = '0';
        historial.clear();
      } else if (valor == '=') {
        calcular();
      } else {
        // agregar operadores y números a la expresión
        expresion += valor;
      }
    });
  }

  void calcular() {
  try {
    // Reemplazar símbolos para que los entienda math_expressions
    String expresionProcesada =
        expresion.replaceAll('×', '*').replaceAll('÷', '/');

    ShuntingYardParser p = ShuntingYardParser();
    Expression exp = p.parse(expresionProcesada);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);

    resultado = eval.toString();
    if (resultado.endsWith('.0')) {
      resultado = resultado.substring(0, resultado.length - 2);
    }

    // Guardar en historial (solo las últimas 10 operaciones)
    historial.insert(0, "$expresion = $resultado");
    if (historial.length > 10) {
      historial = historial.sublist(0, 10);
    }

    expresion = '';
  } catch (e) {
    resultado = "Error";
  }
}



  Widget construirBoton(String valor, {Color? color, Color? colorTexto}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[800],
            foregroundColor: colorTexto ?? Colors.white,
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          onPressed: () => botonPresionado(valor),
          child: Text(
            valor,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Historial
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: historial.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 16.0),
                  child: Text(
                    historial[index],
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.right,
                  ),
                );
              },
            ),
          ),

          // Expresión actual
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              expresion,
              style: TextStyle(
                fontSize: 28,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ),

          // Resultado actual
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Text(
              resultado,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // Botones
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    construirBoton('C', color: Colors.red, colorTexto: Colors.white),
                    construirBoton('(', color: Colors.grey[700]),
                    construirBoton(')', color: Colors.grey[700]),
                    construirBoton('÷', color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    construirBoton('7'),
                    construirBoton('8'),
                    construirBoton('9'),
                    construirBoton('×', color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    construirBoton('4'),
                    construirBoton('5'),
                    construirBoton('6'),
                    construirBoton('-', color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    construirBoton('1'),
                    construirBoton('2'),
                    construirBoton('3'),
                    construirBoton('+', color: Colors.orange),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                          onPressed: () => botonPresionado('0'),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                '0',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    construirBoton('.'),
                    construirBoton('=', color: Colors.orange),
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
