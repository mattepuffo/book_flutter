enum OrdinamentoLibro {
  titoloAsc("Titolo ASC"),
  titoloDesc("Titolo DESC"),
  prezzoAsc("Prezzo ASC"),
  prezzoDesc("Prezzo DESC"),
  autoreAsc("Autore ASC"),
  autoreDesc("Autore DESC"),
  editoreAsc("Editore ASC"),
  editoreDesc("Editore DESC"),
  scaffaleAsc("Scaffale ASC"),
  scaffaleDesc("Scaffale DESC");

  final String desc;

  const OrdinamentoLibro(this.desc);
}
