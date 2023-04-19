class Scenario {
    Scenario({required this.enabledStations, required this.path});

    final List<String> enabledStations;
    final List<String> path;
}

List<Scenario> SCENARIOS = [
    Scenario(enabledStations: ["sevilla", "cuauhtemoc"], path: ["sevilla", "insurgentes", "cuauhtemoc"]),
    Scenario(enabledStations: ["zaragoza", "moctezuma"], path: ["zaragoza", "gomezfarias", "boulevard", "balbuena", "moctezuma"]),
    Scenario(enabledStations: ["sevilla", "ninosheroes"], path: ["sevilla", "insurgentes", "cuauhtemoc", "balderas", "ninosheroes"]),
    Scenario(enabledStations: ["indiosverdes", "candelaria"], path: ["indiosverdes", "deportivo18marzo", "potrero", "laraza", "tlatelolco", "guerrero", "hidalgo", "juarez", "balderas", "saltodelagua", "isabellacatolica", "pinosuarez", "merced", "candelaria"])
];