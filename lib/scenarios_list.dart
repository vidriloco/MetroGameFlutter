class Scenario {
    Scenario({required this.id, required this.levelId, required this.enabledStations, required this.path, required this.title, required this.icon});

    final int id;
    final int levelId;
    final List<String> enabledStations;
    final List<String> path;
    final String title;
    final String icon;
}

List<Scenario> SCENARIOS = [
    Scenario(id: 0, levelId: 1, title: "Ayuda al chamaco a llegar a su clase", icon: "🧒🏽", enabledStations: ["sevilla", "cuauhtemoc"], path: ["sevilla", "insurgentes", "cuauhtemoc"]),
    Scenario(id: 1, levelId: 1, title: "Petra necesita llegar al mercado", icon: "🦹🏽‍♀️", enabledStations: ["hidalgo", "ninosheroes"], path: ["hidalgo", "juarez", "balderas", "ninosheroes"]),
    Scenario(id: 2, levelId: 1, title: "La Sra Gatito debe regresar a casa", icon: "😽", enabledStations: ["sevilla", "ninosheroes"], path: ["sevilla", "insurgentes", "cuauhtemoc", "balderas", "ninosheroes"]),
    Scenario(id: 3, levelId: 1, title: "Josefa va tarde a la misa", icon: "👵🏽", enabledStations: ["tasquena", "villadecortes"], path: ["tasquena", "generalanaya", "ermita", "portales", "nativitas", "villadecortes"]),
    Scenario(id: 4, levelId: 2, title: "Pepe tiene que regresar a la merced", icon: "👨🏽‍🍳", enabledStations: ["indiosverdes", "candelaria"], path: ["indiosverdes", "deportivo18marzo", "potrero", "laraza", "tlatelolco", "guerrero", "hidalgo", "juarez", "balderas", "saltodelagua", "isabellacatolica", "pinosuarez", "merced", "candelaria"])
];