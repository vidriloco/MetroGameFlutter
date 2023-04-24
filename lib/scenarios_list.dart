class Scenario {
    Scenario({required this.enabledStations, required this.path, required this.title, required this.icon});

    final List<String> enabledStations;
    final List<String> path;
    final String title;
    final String icon;
}

List<Scenario> SCENARIOS = [
    Scenario(title: "Ayuda al chamaco a llegar a su clase", icon: "🧒🏽", enabledStations: ["sevilla", "cuauhtemoc"], path: ["sevilla", "insurgentes", "cuauhtemoc"]),
    Scenario(title: "Petra necesita llegar ir mercado", icon: "🦹🏽‍♀️", enabledStations: ["hidalgo", "ninosheroes"], path: ["hidalgo", "juarez", "balderas", "ninosheroes"]),
    Scenario(title: "La Sra Gatito debe regresar a casa", icon: "😽", enabledStations: ["sevilla", "ninosheroes"], path: ["sevilla", "insurgentes", "cuauhtemoc", "balderas", "ninosheroes"]),
    Scenario(title: "Josefa va tarde a la misa", icon: "👵🏽", enabledStations: ["tasquena", "villadecortes"], path: ["tasquena", "generalanaya", "ermita", "portales", "nativitas", "villadecortes"]),
    Scenario(title: "Pepe tiene que regresar a la merced", icon: "👨🏽‍🍳", enabledStations: ["indiosverdes", "candelaria"], path: ["indiosverdes", "deportivo18marzo", "potrero", "laraza", "tlatelolco", "guerrero", "hidalgo", "juarez", "balderas", "saltodelagua", "isabellacatolica", "pinosuarez", "merced", "candelaria"])
];