import 'package:flutter/material.dart';

class Level {
    Level({required this.title, required this.icon, required this.caption, this.isBlocked = false, required this.description, required this.color, this.emphColor = Colors.grey});

    final String title;
    final String icon;
    final String description;
    final Color color;
    final Color emphColor;
    final String caption;
    final bool isBlocked;
}

List<Level> LEVELS = [
    Level(title: "Nivel principiantes", caption: "1/5 retos completados", icon: "🤓", description: "Familiarizate con el juego en tramos super cortos", color: const Color.fromRGBO(245, 72, 145, 1), emphColor: const Color(0xFFFFCEE3)),
    Level(title: "Super fáciles", caption: "Completa la mitad de los retos del nivel anterior para desbloquear", icon: "✌️", description: "Vamos por tramos un poco más largos en zonas centrales", color: const Color.fromRGBO(65, 94, 174, 1)),
    Level(title: "Fáciles", isBlocked: true, caption: "Completa la mitad de los retos del nivel anterior para desbloquear", icon: "🪜", description: "Rutas que utilizaz al menos una correspondencia", color: const Color.fromRGBO(65, 94, 174, 1)),
    Level(title: "Medio fáciles", isBlocked: true, caption: "Completa la mitad de los retos del nivel anterior para desbloquear", icon: "🍖", description: "Por zonas más alejadas de la zona central", color: const Color.fromRGBO(65, 94, 174, 1)),
    Level(title: "Complicados", isBlocked: true, caption: "Completa la mitad de los retos del nivel anterior para desbloquear", icon: "🕊", description: "Guia por tramos un poco más largos en zonas centrales", color: const Color.fromRGBO(65, 94, 174, 1)),
    Level(title: "Difíciles", isBlocked: true, caption: "Completa la mitad de los retos del nivel anterior para desbloquear", icon: "🥷", description: "Guia por tramos cortos con una correspondencia", color: const Color.fromRGBO(65, 94, 174, 1))
];