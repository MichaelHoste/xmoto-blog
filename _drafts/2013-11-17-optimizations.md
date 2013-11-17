---
layout: post_page
title: 10. Optimizations
---

J'ai :

 * Défini la zone de l'affichage pour ne pas afficher les blocks / edges / items qui ne sont pas compris dedans. (compute_visibility). Pour ce faire j'ai utilisé la technique des AABB en créant des boites englobantes de mes blocks et edges et en les comparant avec les boites englobantes de mon "screen".

 Ca a déjà pas mal accéléré l'affichage du jeu mais le problème d'un affichage à chaque frame restait.

 J'ai alors pensé à définir un deuxième buffer qui est nettemnet plus grand que le buffer du jeu (largeur * 4 et hauteur * 4 = 4000 * 2400 * 4 bytes = 37mo). Ce buffer est calculé un fois au début du jeu. Il contient tous les éléments statiques du jeu, soit les blocks, les edges et les sprites (les trois éléments les plus lourds à afficher à chaque frame).

 Une fois que le buffer est calculé, il est concervé en mémoire avec la position de la moto quand il a été créé. Il est ensuite replacé correctement, en fonction de la position actuelle de la moto, dans le canvas principal.

 Il faut le placer avec précision malgré le zoom. Pour ça on utilise ctx.drawImage avec des paramètres qui varient en fonction de la position, du zoom, et de la taille du canvas principal et celui du buffer.

 Le gain est énorme.

 Le buffer doit être recalculé quand les limites du canvas dépassent les limites pré-calculées du buffer. Dans ce cas il est recalculé à partir de la position actuelle de la moto.

 Ce qui signifie qu'en pratique, pour une moto qui avance à une bonne vitesse, le pré-calcul des blocks/edges/sprites est calculé une fois toutes les 5 secondes environ, soit une fois toutes les 300 frames, au lieu d'être calculée à chaque frame.
