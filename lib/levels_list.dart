import 'package:flutter/material.dart';

class Level {
    Level({required this.id, required this.title, required this.icon, required this.caption, this.isBlocked = false, required this.description, required this.color, this.emphColor = Colors.grey});

    final int id;
    final String title;
    final String icon;
    final String description;
    final Color color;
    final Color emphColor;
    final String caption;
    final bool isBlocked;
}

List<Level> LEVELS = [
    Level(id: 1, title: "Nivel principiantes", caption: "1/5 retos completados", icon: "🤓", description: "Familiarizate con el juego en tramos super cortos", color: const Color.fromRGBO(245, 72, 145, 1), emphColor: const Color(0xFFFFCEE3)),
    Level(id: 2, title: "Super fáciles", caption: "Completa la mitad de los retos del nivel anterior para desbloquear", icon: "✌️", description: "Vamos por tramos un poco más largos en zonas centrales", color: const Color.fromRGBO(65, 94, 174, 1)),
    Level(id: 3, title: "Fáciles", isBlocked: true, caption: "Completa la mitad de los retos del nivel anterior para desbloquear", icon: "🪜", description: "Rutas que utilizaz al menos una correspondencia", color: const Color.fromRGBO(65, 94, 174, 1)),
    Level(id: 4, title: "Medio fáciles", isBlocked: true, caption: "Completa la mitad de los retos del nivel anterior para desbloquear", icon: "🍖", description: "Por zonas más alejadas de la zona central", color: const Color.fromRGBO(65, 94, 174, 1)),
    Level(id: 5, title: "Complicados", isBlocked: true, caption: "Completa la mitad de los retos del nivel anterior para desbloquear", icon: "🕊", description: "Guia por tramos un poco más largos en zonas centrales", color: const Color.fromRGBO(65, 94, 174, 1)),
    Level(id: 6, title: "Difíciles", isBlocked: true, caption: "Completa la mitad de los retos del nivel anterior para desbloquear", icon: "🥷", description: "Guia por tramos cortos con una correspondencia", color: const Color.fromRGBO(65, 94, 174, 1))
];