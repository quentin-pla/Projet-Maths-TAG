#### SAISIE DEMANDE

def setDemande():
    global demande
    cpt = 0
    while cpt != len(demande):
        demande = raw_input('Mot: ')
        demande = demande.lower()                                         #Formatage de demande en minuscule.
        for char in demande:                                              #Pour chaque caractère dans demande(string)...
            cpt += checkDemande(char)
        if cpt != len(demande):
            cpt = 0
            print('Mot invalide ! (Caractères valides: a-z)')
        
#### VERIFICATION DEMANDE

def checkDemande(char):
    if ord(char)-97 < 0 or ord(char)-97 > 25:                     #  Si le code ASCII-97 du caractère n'est pas compris entre 0 et 25...
        return 0
    else:
        return 1

#### SAISIE COULEUR

def setColor():
	global printColor
	printColor = 'undefined'
	while printColor != checkColor(printColor):
		print('Couleurs disponibles: black, grey, red, green, blue, yellow, orange, purple, pink, cyan, lime')
		printColor = raw_input('Couleur: ')
		printColor = printColor.lower()                                         #Formatage de demande en minuscule.
		if printColor != checkColor(printColor):
			print('Couleur introuvable !')
	printColor = checkColor(printColor)

#### VERIFICATION COULEUR

def checkColor(printColor):
    colors=['black','grey','red','green','blue','yellow','orange','purple','pink','cyan','lime']  #Initialisation tableau "colors" contenant les couleurs possibles pour le graffiti.
    if printColor not in str(colors):                                                             #Si printColor n'appartient pas au tableau colors...
        return '0'                                                                        #  printColor vaut la couleur par défaut rouge.
    return printColor

#### DEFINITION EPAISSEUR GRAFFITI

#visible(bool): Choix de l'affichage du graffiti.

def setSize(visible):
    if visible:           #Si visible(int) vaut 1...
        return pointSize  #  Retourne l'épaisseur du graffiti, si visible.
    else:                 #Sinon...
        return 0          #  Retourne 0, si invisible.

#### DEFINITION PARAMETRES D'AFFICHAGE

def getScaling():
    global pointSize                                                       #Utilisation de la variable globale pointSize.
    global scale
    scale = 2
    if(len(demande)) <= 5:                                                 #Si la longueur du string à traiter est inférieure ou égale à 5...
        pointSize = 500;                                                   #Épaisseur du graffiti à 500
        return {'xmin':-5,'ymin':-50,'xmax':95,'ymax':50,'figsize':10}     #  Retourne les paramètres d'affichage pour afficher au maximum 5 caractères.
    else:                                                                  #Sinon...
        pointSize = 250;                                                   #Épaisseur du graffiti à 250
        return {'xmin':-5,'ymin':-100,'xmax':195,'ymax':100,'figsize':10}  #  Retourne les paramètres d'affichage pour afficher au maximum 10 caractères.

#### DEFINITION ESPACE ENTRE CARACTERES

#index(int): Position du caractère dans la chaine.

def getSpace(index):
    middle = ((getScaling()['xmax']-getScaling()['xmin'])-10)/2  #Initialisation de "middle" qui est la position du milieu initiale de l'animation.
    return ((middle-((len(demande)-1)*10))+(index*20))/scale     #Retourne l'espacement du caractère.

#### DEFINITION TRANSITION ENTRE CARACTERES

#lastframe(image):    Dernière image du tableau "frames"
#begin(tableau[x,y]): Coordonnées(x,y) dernier point lettre précédente
#end(tableau[x,y]):   Coordonnées(x,y) premier point lettre suivante.

def getTransition(lastframe,begin,end):
    a = (end[1]-begin[1])/(end[0]-begin[0])                      #Calcul coefficient directeur a = (yb-ya)/(xb-xa).
    b = (begin[1]-(a*begin[0]))                                  #Calcul ordonnée à l'origine b = ya-(a*xa).
    tmpframe = lastframe                                         #Initialisation de tmpframe(image).
    frames = []                                                  #Initialisation de frames(tableau d'images).
    frames.append(tmpframe)                                      #Ajout à la fin de tmpframe dans frames.
    frames += Diagonale(tmpframe,begin[0],end[0],0.2,a,b,false)  #Ajout des images du tableau d'images retourné par la fonction Diagonale dans frames.
    frames.pop(0)                                                #Suppression de la première image dans frames.
    return frames                                                #Retourne le tableau d'images contenant la transition.
    
#### DEFINITION POLYGON BOMBE TAG

#baseX: Coordonnée en abscisse initiale.
#baseY: Coordonnée en ordonnée initiale.

def tag(baseX,baseY):
    POLYGON = polygon2d([[(baseX-1)*scale,baseY*scale],[(baseX+1)*scale,baseY*scale],[(baseX+1)*scale,(baseY+3.5)*scale],[(baseX-1)*scale,(baseY+3.5)*scale]] , color=printColor, edgecolor="black",
    thickness=3/scale, zorder=3)
    #Ajout d'un polygon dans POLYGON(plot) de la couleur définie par l'utilisateur, avec bordures noires, épaisseur (3/échelle animation), couche numéro 3.
    POLYGON += ellipse((baseX*scale,(baseY+3.5)*scale),0.9*scale,0.5*scale,pi,fill=True,edgecolor='black', facecolor='silver', thickness=3/scale,zorder=2)
    #Ajout d'une ellipse dans POLYGON(plot).
    POLYGON += polygon2d([[(baseX-0.5)*scale,(baseY+1.5)*scale],[(baseX+1)*scale,(baseY+1.5)*scale],[(baseX+1)*scale,(baseY+2.85)*scale],[(baseX-0.5)*scale,(baseY+2.85)*scale]] , color="white",
    edgecolor="black", thickness=3/scale,zorder=4)
    #Ajout d'un polygon dans POLYGON(plot).
    POLYGON += polygon2d([[(baseX-0.2)*scale,(baseY+3.9)*scale],[(baseX+0.2)*scale,(baseY+3.9)*scale],[(baseX+0.2)*scale,(baseY+4.45)*scale],[(baseX-0.2)*scale,(baseY+4.45)*scale]] , color="grey",
    edgecolor="black",thickness=3/scale,zorder=1)
    #Ajout d'un polygon dans POLYGON(plot).
    POLYGON += circle(((baseX+0.13)*scale,(baseY+4.26)*scale),0.06*scale,fill=True,facecolor='black', thickness=0,zorder=2)
    #Ajout d'un cercle dans POLYGON(plot).
    return POLYGON  #Retourne POLYGON(plot)

#### DEFINITION POLYGON BOMBE TAG + SPRAY

#baseX(float): Coordonnée en abscisse initiale.
#baseY(float): Coordonnée en ordonnée initiale.

def tagspraying(baseX,baseY):
    POLYGON = polygon2d([[(baseX-1)*scale,baseY*scale],[(baseX+1)*scale,baseY*scale],[(baseX+1)*scale,(baseY+3.5)*scale],[(baseX-1)*scale,(baseY+3.5)*scale]] , color=printColor, edgecolor="black",
    thickness=3/scale, zorder=3)
    POLYGON += ellipse((baseX*scale,(baseY+3.5)*scale),0.9*scale,0.5*scale,pi,fill=True,edgecolor='black', facecolor='silver', thickness=3/scale,zorder=2)
    POLYGON += polygon2d([[(baseX-0.5)*scale,(baseY+1.5)*scale],[(baseX+1)*scale,(baseY+1.5)*scale],[(baseX+1)*scale,(baseY+2.85)*scale],[(baseX-0.5)*scale,(baseY+2.85)*scale]] , color="white",
    edgecolor="black", thickness=3/scale,zorder=4)
    POLYGON += polygon2d([[(baseX-0.2)*scale,(baseY+3.9)*scale],[(baseX+0.2)*scale,(baseY+3.9)*scale],[(baseX+0.2)*scale,(baseY+4.45)*scale],[(baseX-0.2)*scale,(baseY+4.45)*scale]] , color="grey",
    edgecolor="black",thickness=3/scale,zorder=1)
    POLYGON += circle(((baseX+0.13)*scale,(baseY+4.26)*scale),0.06*scale,fill=True,facecolor='black', thickness=0,zorder=2)
    POLYGON += polygon([((baseX+0.14)*scale,(baseY+4.26)*scale), ((baseX+1.66)*scale,(baseY+(4.28+0.76))*scale), ((baseX+1.66)*scale,(baseY+(4.28-0.76))*scale)], color=printColor)
    return POLYGON  #Retourne POLYGON(plot)

#### DEFINITION DROITE HORIZONTALE

#tmpframe(image): Dernière image du tableau "frames".
#min(float):      Abscisse de départ.
#max(float):      Abscisse de fin.
#pas(float):      Fréquence d'affichage.
#y(float):        Ordonnée initiale.
#visible(bool):    Choix de l'affichage du graffiti.

def DroiteH(tmpframe,min,max,pas,y,visible):
    frames = []                                                                 #Initialisation d'un tableau vide frames.
    y*=scale                                                                    #Mutliplication de y par l'échelle de l'animation.
    for x in srange(min*scale,max*scale,pas*scale):                             #Pour x allant de (min*échelle) à (max*échelle) avec un pas de (pas*échelle).
        frame = tmpframe + point((x,y),size=setSize(visible),color=printColor)  #  Initialisation d'une image "frame" regroupant la dernière image du tableau avec un point aux coordonnées données.
        tmpframe = frame                                                        #  tmpframe est égale à frame.
        if visible:                                                             #  Si visible vaut vrai...
            frame += tagspraying((x-(2*scale))/scale,(y-(4.28*scale))/scale)    #    Ajout du polygon "tagspraying" dans frame.
        else:                                                                   #  Sinon...
            frame += tag((x-(2*scale))/scale,(y-(4.28*scale))/scale)            #    Ajout du polygon "tag" dans frame.
        frames.append(frame)                                                    #  Ajout de l'image frame dans frames.
    frames.append(tmpframe)                                                     #Ajout de l'image sans polygon tmpframe dans frames.
    return frames                                                               #Retourne la tableau d'images frames.
    
#### DEFINITION DROITE VERTICALE

#tmpframe(image): Dernière image du tableau "frames".
#min(float):      Ordonnée de départ.
#max(float):      Ordonnée de fin.
#pas(float):      Fréquence d'affichage.
#x(float):        Ordonnée initiale.
#visible(bool):    Choix de l'affichage du graffiti.

def DroiteV(tmpframe,min,max,pas,x,visible):    
    frames = []                                                                 #Initialisation d'un tableau vide frames.
    x*=scale                                                                    #Mutliplication de x par l'échelle de l'animation.
    for y in srange(min*scale,max*scale,pas*scale):                             #Pour y allant de (min*échelle) à (max*échelle) avec un pas de (pas*échelle).
        frame = tmpframe + point((x,y),size=setSize(visible),color=printColor)  #  Initialisation d'une image "frame" regroupant la dernière image du tableau avec un point aux coordonnées données.
        tmpframe = frame                                                        #  tmpframe est égale à frame.
        if visible:                                                             #  Si visible vaut vrai...
            frame += tagspraying((x-(2*scale))/scale,(y-(4.28*scale))/scale)    #    Ajout du polygon "tagspraying" dans frame.
        else:                                                                   #  Sinon...
            frame += tag((x-(2*scale))/scale,(y-(4.28*scale))/scale)            #    Ajout du polygon "tag" dans frame.
        frames.append(frame)                                                    #  Ajout de l'image frame dans frames.
    frames.append(tmpframe)                                                     #Ajout de l'image sans polygon tmpframe dans frames.
    return frames                                                               #Retourne la tableau d'images frames.
        
#### CALCUL ORDONNEE ORIGINE FONCTION AFFINE

#a(float):   Coefficient directeur.
#b(float):   Ordonnée à l'origine.
#ptd(float): Point de départ en abscisse.

def getBDiag(a,b,ptd):
    if a < 0:                         #Si a est inférieur à 0...
        return (((a*ptd)+(b*-1))*-1)  #  Retourne la nouvelle ordonnée à l'origine.
    else:                             #Sinon...
        return (((a*ptd)+b)*-1)       #  Retourne la nouvelle ordonnée à l'origine.
    
#### DEFINITION DIAGONALE

#tmpframe(image): Dernière image du tableau "frames".
#min(float):      Ordonnée de départ.
#max(float):      Ordonnée de fin.
#pas(float):      Fréquence d'affichage.
#a(float):        Coefficient directeur.
#b(float):        Ordonnée à l'origine.
#visible(bool):    Choix de l'affichage du graffiti.

def Diagonale(tmpframe,min,max,pas,a,b,visible):
    frames = []                                                                       #Initialisation d'un tableau vide frames.
    b*=scale                                                                          #scaletiplication de la valeur de l'ordonnée à l'origine par l'échelle de l'animation.
    for x in srange(min*scale,max*scale,pas*scale):                                   #Pour x allant de (min*échelle) à (max*échelle) avec un pas de (pas*échelle).
        frame = tmpframe + point((x,(a*x)+b),size=setSize(visible),color=printColor)  #  Initialisation d'une image "frame" regroupant la dernière image du tableau avec un point aux coordonnées données.
        tmpframe = frame                                                              #  tmpframe est égale à frame.
        if visible:                                                                   #  Si visible vaut vrai...
            frame += tagspraying((x-(2*scale))/scale,((a*x)+(b-(4.28*scale)))/scale)  #    Ajout du polygon "tagspraying" dans frame.
        else:                                                                         #  Sinon...
            frame += tag((x-(2*scale))/scale,((a*x)+(b-(4.28*scale)))/scale)          #    Ajout du polygon "tag" dans frame.
        frames.append(frame)                                                          #  Ajout de l'image frame dans frames.
    frames.append(tmpframe)                                                           #Ajout de l'image sans polygon tmpframe dans frames.
    return frames                                                                     #Retourne la tableau d'images frames.
    
#### CONVERSION DEGRES ANGLE ABSCISSE

#value(int): Valeur à convertir en degrés.
#scale(int):   Échelle de l'animation.
#pos(float): Position en abscisse

def getXdegree(value,scale,pos):
    return ((math.cos(value * (math.pi / 180))) * scale)+pos  #Retourne la valeur en degrés pour l'abscisse x.

#### CONVERSION DEGRES ANGLE ORDONNEE

#value(int): Valeur à convertir en degrés.
#scale(int):   Échelle de l'animation.
#pos(float): Position en abscisse

def getYdegree(value,scale,pos):
    return ((math.sin(value * (math.pi / 180))) * scale)+pos  #Retourne la valeur en degrés pour l'ordonnée y.
    
#### DEFINITION COURBE

#tmpframe(image): Dernière image du tableau "frames".
#min(float):   Ordonnée de départ.
#max(float):   Ordonnée de fin.
#pas(float):   Fréquence d'affichage.
#scalex(float):  Largeur horizontale de la courbe.
#posx(float):  Position en abscisse x du centre de la courbe.
#scaley(float):  Largeur verticale de la courbe.
#posy(float):  Position en ordonnée y du centre de la courbe.
#visible(bool): Choix de l'affichage du graffiti.

def Courbe(tmpframe,min,max,pas,scalex,posx,scaley,posy,visible):
    frames = []                                                                                                                     #Initialisation d'un tableau vide frames.
    scalex*=scale                                                                                                                   #scaletiplication de scalex par l'échelle de l'animation
    posx*=scale                                                                                                                     #scaletiplication de posx par l'échelle de l'animation
    scaley*=scale                                                                                                                   #scaletiplication de scaley par l'échelle de l'animation
    posy*=scale                                                                                                                     #scaletiplication de posy par l'échelle de l'animation
    for deg in srange(min,max,pas):                                                                                                 #Pour deg allant de min à max avec un pas égal à pas.
        frame = tmpframe + point((getXdegree(deg,scalex,posx),getYdegree(deg,scaley,posy)),size=setSize(visible),color=printColor)  #  Initialisation d'une image "frame" regroupant la dernière image du tableau avec un point aux coordonnées données.
        tmpframe = frame                                                                                                            #  tmpframe est égale à frame.
        if visible:                                                                                                                 #  Si visible vaut true...
            frame += tagspraying((getXdegree(deg,scalex,posx-(2*scale)))/scale,(getYdegree(deg,scaley,posy-(4.28*scale)))/scale)    #    Ajout du polygon "tagspraying" dans frame.
        else:                                                                                                                       #  Sinon...
            frame += tag((getXdegree(deg,scalex,posx-(2*scale)))/scale,(getYdegree(deg,scaley,posy-(4.28*scale)))/scale)            #    Ajout du polygon "tag" dans frame.
        frames.append(frame)                                                                                                        #  Ajout de l'image frame dans frames.
    frames.append(tmpframe)                                                                                                         #Ajout de l'image sans polygon "tmpframe" dans frames.
    return frames                                                                                                                   #Retourne la tableau d'images frames.
    
#### DEFINITION ANIMATION

#frames(tableau[image]): Tableau contenant l'ensemble des images à générer pour l'animation.
#xmin(float): Valeur de l'abscisse minimale pour l'affichage.
#ymin(float): Valeur de l'ordonnée minimale pour l'affichage.
#xmax(float): Valeur de l'abscisse maximale pour l'affichage.
#ymax(float): Valeur de l'abscisse maximale pour l'affichage.
#size(int):   Valeur de l'échelle pour l'affichage.
#delay(int):  Vitesse d'affichage de l'animation en millisecondes.
#it(int):     Nombre d'itérations de l'animation.

def Animate(frames,xmin,ymin,xmax,ymax,size,delay,it):
    time = 0.42                                                                                                                                       #Temps moyen mis pour la génération d'une image.
    if ((len(frames)*time)/60) < 1:                                                                                                                   #Si (taille de frames * time)/60 plus petit que 1 minute...
        print(str(len(frames)) + " Images, temps estimé pour la génération " + str(round((len(frames)*time),0)) + " seconde(s).")                     #  Affichage du temps estimé pour la génération de l'animation.
    else:                                                                                                                                             #Sinon...
        minutes = ((len(frames)*time)/60)                                                                                                             #  Récupération du nombre de minutes estimées pour la génération.
        seconds = int((minutes-int(minutes))*60)                                                                                                      #  Récupération du nombre de secondes estimées pour la génération.
        print(str(len(frames)) + " Images, temps estimé pour la génération " + str(int(minutes)) + " minute(s) et " + str(seconds) + " seconde(s).")  #  Affichage du temps estimé pour la génération de l'animation.
    A = animate(frames,xmin=xmin,ymin=ymin,xmax=xmax,ymax=ymax,figsize=[size,size], axes=false)                                                       #Initialisation de l'animation avec le tableau d'images frames.
    A.apng(savefile='animation.png', show_path=True, delay=delay, iterations=it)                                                                      #Génération de l'animation au format apng avec la vitesse et le nombre d'itérations souhaitées.
    
#### MAIN

def main():
    setDemande()                                                                  #Appel de la fonction permettant à l'utilisateur de saisir un mot.
    setColor()                                                                    #Appel de la fonction permettant à l'utilisateur de choisir la couleur.
    frames = []                                                                   #Initialisation d'un tableau vide "frames".
    tmpframe = point((0,0),size=0)                                                #Initialisation de l'image tmpframe.
    frames.append(tmpframe)                                                       #Ajout de l'image tmpframe dans le tableau frames.
    for index, lettre in enumerate(demande):                                      #Pour chaque index et lettre dans demande...
        activeLetter = functions[ord(lettre)-97](getSpace(index),tmpframe)        #  Initialisation d'un tableau contenant les valeurs retournées par la fonction correspondante au caractère en cours.
        if index > 0:                                                             #  Si l'index du caractère est supérieur à 0...
            begin = tmpEnd                                                        #    Initialisation du tableau "begin" contenant les coordonnées(x,y) du dernier point renvoyé par la fonction de la lettre précédente.
            end = activeLetter['begin']                                           #    Initialisation du tableau "end" contenant les coordonnées(x,y) du premier point renvoyé par la fonction de la lettre actuelle.
            transition = getTransition(tmpframe,begin,end)                        #    Initialisation du tableau d'images "transition" égal au tableau renvoyé par la fonction getTransition.
            tmpframe = transition[-1]                                             #    tmpframe est égale à la dernière image du tableau d'images transition.
            transition.pop()                                                      #    Suppression de la dernière image du tableau transition.
            frames += transition                                                  #    Ajout du contenu de transition au tableau frames.
            activeLetter = functions[ord(lettre)-97](getSpace(index),tmpframe)    #    Mise à jour du tableau activeLetter avec la nouvelle image de départ tmpframe.
            activeLetter['frames'].pop(0)                                         #    Suppression de la première image du tableau d'images d'activeLetter.
        tmpEnd = activeLetter['end']                                              #  Initialisation du tableau "tmpEnd" contenant les coordonnées(x,y) du dernier point renvoyé de la lettre actuelle.
        letterFrames = activeLetter['frames']                                     #  letterFrames est égal au tableau 'frames' contenu dans activeLetter.
        tmpframe = letterFrames[-1]                                               #  tmpFrame est égale à la dernière image du tableau letterFrames.
        letterFrames.pop()                                                        #  Suppression de la dernière image du tableau letterFrames.
        frames += letterFrames                                                    #  Ajout de letterFrames dans frames.
    frames.append(tmpframe)                                                       #Ajout de la dernière image de la dernière lettre sans la bombe de tag.
    return frames                                                                 #Retourne le tableau contenant l'ensemble des images nécessaires pour l'animation.

#######################################  DEFINITION DES LETTRES  #######################################

#### DEFINITION LETTRE A

#space(float):     Espacement du caractère.
#lastframe(image): Dernière image du tableau frames.

def a(space,lastframe):
    begin = [space-3,-5]                                                                                 #Initialisation du tableau "begin" contenant les coordonnées du point de départ.
    end = [space+1.6,-1]                                                                                 #Initialisation du tableau "end" contenant les coordonnées du dernier point.
    tmpframe = lastframe                                                                                 #Initialisation de l'image "tmpframe" égale à lastframe.
    frames = []                                                                                          #Initialisation du tableau vide "frames".
    frames.append(tmpframe)                                                                              #Ajout de l'image tmpframe dans le tableau frames.
    frames += Diagonale(tmpframe,space-3,space,0.05,(10/3),getBDiag((10/3),5,space-3),true)              #Ajout des images retournées par la fonction Diagonale dans le tableau frames.
    tmpframe = frames[-1]                                                                                #tmpframe est égale à la dernière image du tableau frames.
    frames.pop()                                                                                         #Suppression de la dernière image du tableau frames.
    frames += Diagonale(tmpframe,space,space+3,0.05,-(10/3),getBDiag(-(10/3),5,space),true)              #Ajout des images retournées par la fonction Diagonale dans le tableau frames.
    tmpframe = frames[-1]                                                                                #tmpframe est égale à la dernière image du tableau frames.
    frames.pop()                                                                                         #Suppression de la dernière image du tableau frames.
    frames += Diagonale(tmpframe,space+3,space-1.8,-0.15,-(4/4.8),getBDiag(-(4/4.8),-5,space+3),false)   #Ajout des images retournées par la fonction Diagonale dans le tableau frames.
    tmpframe = frames[-1]                                                                                #tmpframe est égale à la dernière image du tableau frames.
    frames.pop()                                                                                         #Suppression de la dernière image du tableau frames.
    frames += DroiteH(tmpframe,space-1.5,space+1.6,0.1,-1,true)                                          #Ajout des images retournées par la fonction DroiteH dans le tableau frames.
    return {'frames':frames,'begin':begin,'end':end}                                                     #Retourne le tableau d'images, les coordonnées initiales et finales de la lettre.

#### DEFINITION LETTRE B

def b(space,lastframe):
    begin = [space-3,-5]
    end = [space-3,-5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteV(tmpframe,-5,5,0.3,space-3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Courbe(tmpframe,90,-95,-5,4,space-3,2,3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Courbe(tmpframe,90,-90,-2,6,space-3,3,-2,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE C

def c(space,lastframe):
    begin = [getXdegree(30,3,space),getYdegree(30,5,0)]
    end = [getXdegree(332,3,space),getYdegree(332,5,0)]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += Courbe(tmpframe,30,332,3,3,space,5,0,true)
    return {'frames':frames,'begin':begin,'end':end}
    
#### DEFINITION LETTRE D

def d(space,lastframe):
    begin = [space-3,-5]
    end = [space-3,-5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteV(tmpframe,-5,5,0.3,space-3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Courbe(tmpframe,90,-90,-2,6,space-3,5,0,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE E

def e(space,lastframe):
    begin = [space-3,-5]
    end = [space+3,-5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteV(tmpframe,-5,5,0.3,space-3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space-3,space+3,0.2,5,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space+3,space-3,-0.2,(5/6),getBDiag((5/6),-5,space+3),false)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space-3,space+2,0.2,0,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space+2,space-3,-0.2,1,getBDiag(1,0,space+2),false)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space-3,space+3,0.2,-5,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE F

def f(space,lastframe):
    begin = [space-3,-5]
    end = [space+2,0]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteV(tmpframe,-5,5,0.3,space-3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space-3,space+3,0.2,5,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space+3,space-3,-0.2,(5/6),getBDiag((5/6),-5,space+3),false)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space-3,space+2,0.2,0,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE G

def g(space,lastframe):
    begin = [getXdegree(30,3,space),getYdegree(30,5,0)]
    end = [space,0]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += Courbe(tmpframe,30,360,3,3,space,5,0,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space+3,space,-0.1,0,true)  
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE H

def h(space,lastframe):
    begin = [space-3,-5]
    end = [space+3,5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteV(tmpframe,-5,5,0.3,space-3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,5,0,-0.2,space-3,false)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space-3,space+3,0.2,0,true)  
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,0,-5,-0.2,space+3,false)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,-5,5,0.3,space+3,true) 
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE I

def i(space,lastframe):
    begin = [space-3,5]
    end = [space+3,-5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteH(tmpframe,space-3,space+3,0.3,5,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space+3,space,-0.3,5,false)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,5,-5,-0.3,space,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space,space-3,-0.3,-5,false)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space-3,space+3,0.3,-5,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE J

def j(space,lastframe):
    begin = [space-2,5]
    end = [space-3,0]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteH(tmpframe,space-2,space+3,0.2,5,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space+3,space+1,-0.2,5,false)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,5,0,-0.2,space+1,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Courbe(tmpframe,0,-182,-2,2,space-1,5,0,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE K

def k(space,lastframe):
    begin = [space-3,-5]
    end = [space+3,-5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteV(tmpframe,-5,5,0.3,space-3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,5,0,-0.15,space-3,false)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space-3,space+2,0.2,1,getBDiag(1,0,space-3),true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space+2,space-3,-0.2,1,getBDiag(1,0,space-3),false) 
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space-3,space+3,0.2,-(5/6),getBDiag(-(5/6),0,space-3),true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE L

def l(space,lastframe):
    begin = [space-3,5]
    end = [space+3,-5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteV(tmpframe,5,-5,-0.3,space-3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space-3,space+3.2,0.2,-5,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE M

def m(space,lastframe):
    begin = [space-3,-5]
    end = [space+3,-5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteV(tmpframe,-5,5,0.3,space-3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space-3,space,0.15,(-4/3),getBDiag(-(4/3),5,space-3),true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space,space+3,0.15,(4/3),getBDiag((4/3),-1,space),true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,5,-5,-0.3,space+3,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE N

def n(space,lastframe):
    begin = [space-3,-5]
    end = [space+3,5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteV(tmpframe,-5,5,0.3,space-3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space-3,space+3,0.15,(-5/3),getBDiag(-(5/3),5,space-3),true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,-5,5,0.3,space+3,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE O

def o(space,lastframe):
    begin = [getXdegree(0,3,space),getYdegree(0,5,0)]
    end = [getXdegree(360,3,space),getYdegree(360,5,0)]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += Courbe(tmpframe,0,360,3,3,space,5,0,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE P

def p(space,lastframe):
    begin = [space-3,-5]
    end = [space-3,0]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteV(tmpframe,-5,5,0.3,space-3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Courbe(tmpframe,90,-90,-2,6,space-3,2.5,2.5,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE Q

def q(space,lastframe):
    begin = [getXdegree(0,3,space),getYdegree(0,5,0)]
    end = [space+3,-5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += Courbe(tmpframe,0,360,3,3,space,5,0,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space+3,space,-0.2,0,false) 
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space,space+3,0.2,(-5/3),getBDiag((-5/3),0,space),true)
    return {'frames':frames,'begin':begin,'end':end}
    
#### DEFINITION LETTRE R

def r(space,lastframe):
    begin = [space-3,-5]
    end = [space+3,-5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteV(tmpframe,-5,5,0.3,space-3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Courbe(tmpframe,90,-90,-2,6,space-3,2.5,2.5,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space-3,space,0.2,0,false)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space,space+3,0.2,(-5/3),getBDiag((-5/3),0,space),true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE S

def s(space,lastframe):
    begin = [getXdegree(30,3,space),getYdegree(30,2.5,2.5)]
    end = [getXdegree(-165,3,space),getYdegree(-165,2.5,-2.5)]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += Courbe(tmpframe,30,275,5,3,space,2.5,2.5,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Courbe(tmpframe,90,-165,-5,3,space,2.5,-2.5,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE T

def t(space,lastframe):
    begin = [space-3,5]
    end = [space,-5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteH(tmpframe,space-3,space+3,0.2,5,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space+3,space,-0.2,5,false) 
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,5,-5,-0.3,space,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE U

def u(space,lastframe):
    begin = [space-3,5]
    end = [space+3,5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteV(tmpframe,5,0,-0.2,space-3,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Courbe(tmpframe,180,360,3,3,space,5,0,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,0,5.1,0.2,space+3,true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE V

def v(space,lastframe):
    begin = [space-3,5]
    end = [space+3,5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += Diagonale(tmpframe,space-3,space,0.1,(-10/3),getBDiag(-(10/3),5,space-3),true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space,space+3.1,0.1,(10/3),getBDiag((10/3),5,space),true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE W

def w(space,lastframe):
    begin = [space-3,5]
    end = [space+3,5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += Diagonale(tmpframe,space-3,space-1.5,0.05,(-10/1.5),getBDiag(-(10/1.5),5,space-3),true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space-1.5,space,0.07,(10/3),getBDiag((10/3),5,space-1.5),true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space,space+1.5,0.07,(-10/3),getBDiag(-(10/3),0,space),true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space+1.5,space+3.05,0.05,(10/1.5),getBDiag((10/1.5),5,space+1.5),true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE X

def x(space,lastframe):
    begin = [space-3,5]
    end = [space-3,-5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += Diagonale(tmpframe,space-3,space+3,0.1,(-10/6),getBDiag(-(10/6),5,space-3),true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,-5,5,0.2,3,false)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space+3,space-3,-0.1,(10/6),getBDiag((10/6),5,space-3),true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE Y

def y(space,lastframe):
    begin = [space-3,5]
    end = [space+3,5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += Diagonale(tmpframe,space-3,space,0.1,(-10/6),getBDiag(-(10/6),5,space-3),true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,0,-5,-0.2,space,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteV(tmpframe,-5,0,0.2,space,false)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space,space+3,0.1,(10/6),getBDiag((10/6),5,space-3),true)
    return {'frames':frames,'begin':begin,'end':end}

#### DEFINITION LETTRE Z

def z(space,lastframe):
    begin = [space-3,5]
    end = [space+3,-5]
    tmpframe = lastframe
    frames = []
    frames.append(tmpframe)
    frames += DroiteH(tmpframe,space-3,space+3,0.25,5,true)
    tmpframe = frames[-1]
    frames.pop()
    frames += Diagonale(tmpframe,space+3,space-3,-0.1,(10/6),getBDiag((10/6),5,space-3),true)
    tmpframe = frames[-1]
    frames.pop()
    frames += DroiteH(tmpframe,space-3,space+3,0.25,-5,true)
    return {'frames':frames,'begin':begin,'end':end}
    
#### DEFINITION DE L'ENSEMBLE DES FONCTIONS POUR CHAQUE LETTRE

functions = [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z]


#######################################  FIN DEFINITION DES LETTRES  #######################################

Animate(main(),getScaling()['xmin'],getScaling()['ymin'],getScaling()['xmax'],getScaling()['ymax'],getScaling()['figsize'],2,3)  #Création de l'animation