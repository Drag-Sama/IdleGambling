# IdleGambling
Un jeu idle sur le casino

Différente machine dans l'ordre:
-Jeu à gratter
-Paris sur course de chevaux
-Machine à sous
-Roulette
-Black jack
-Roulette russe

Mécaniques : 
- Système de combo ?
- Machine 1 fait scale machine 2 ?
- Gambling réductions / augmentations de prix des upgrades ?
- Drop d'items ? (gambling sur l'item -> devient item gold ou jsp et multiplie ses stats)

Gestion des chiffres:
	1 234 567 891 234 = 1 234 567 * 10 ^ 6
	Donc ce n'est pas : money = 1 234 567 891 234
	Mais : money = 1 234 567 et mult = 6
	On affichera donc money * 10 ^ mult (ou on afficher juste money avec une notation selon *mult*)
