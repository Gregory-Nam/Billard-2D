from sage.plot.colors import *

#MCmoins = matrix ( [[1, 0, -C[0]],[0, 1, -C[1]],[0,0,1]])
#M       = matrix ( [[cos(t), -sin(t), 0],[sin(t), cos(t), 0],[0, 0, 1]])
NbTick = 70
Start = 0.01
#-----------------COORDONNEE DU RECTANGLE -----------------#
RectangleX1 = 0
RectangleX2 = 40
RectangleX3 = 40
RectangleX4 = 0

RectangleY1 = 0
RectangleY2 = 0
RectangleY3 = 20
RectangleY4 = 20

#-----------------COORDONNEE DU MILIEU DU RECTANGLE -----------------#
xMilieuRec = ((RectangleX1+RectangleX2)/2)
yMilieuRec = ((RectangleY1+RectangleY4)/2)

#----------------RECTANGLE QUI CORRESPOND A LA BORDURE-------------------------#

polygoneRectangleBordure = polygon2d([(RectangleX1 - 1.5,RectangleY1 - 1.5), (RectangleX2 + 1.5,RectangleY2 - 1.5), (RectangleX3 +1.5,RectangleY3 + 1.5), (RectangleX4 - 1.5,RectangleY4 + 1.5)], color='peru')


#-----------------RECTANGLE QUI CORRESPOND AU BILLARD (tapis) -----------------#
polygoneRectangle = polygon2d([(RectangleX1,RectangleY1), (RectangleX2,RectangleY2), (RectangleX3,RectangleY3), (RectangleX4,RectangleY4)], color='green')

#----------------- NOMBRE DE POINT CORRESPONDANT AU CERCLE -----------------#
N=20

#----------------- RAYON DES BOULES -----------------#
rBoule  = 1

#----------------- TAILLE DES AXES (ABCISSE ET ORDONNEE) -----------------#
cadre = 43

#-----------------DIFFERENT POINT DU CERCLE / BOULE BLANCHE -----------------#
xBlanche = [(rBoule*cos(k*2*pi/N) + xMilieuRec + (xMilieuRec/2)) for k in [0..N-1] ]
yBlanche = [rBoule*sin(k*2*pi/N) + yMilieuRec for k in [0..N-1] ]

#-----------------DIFFERENT POINT DU CERCLE / BOULE ROUGE -----------------#
xRouge = [(rBoule*cos(k*2*pi/N)) + (xMilieuRec/2) for k in [0..N-1] ]
yRouge = [rBoule*sin(k*2*pi/N) + yMilieuRec for k in [0..N-1] ]

#-----------------DIFFERENT POINT DU CERCLE / BOULE BLEU -----------------#
xBleu = [(rBoule*cos(k*2*pi/N)) + ((xMilieuRec/2)-((rBoule*2))) for k in [0..N-1] ]
yBleu = [rBoule*sin(k*2*pi/N) + (yMilieuRec-(rBoule )) for k in [0..N-1] ]

#-----------------DIFFERENT POINT DU CERCLE / BOULE JAUNE -----------------#
xJaune = [(rBoule*cos(k*2*pi/N)) + ((xMilieuRec/2)-((rBoule*2))) for k in [0..N-1] ]
yJaune = [rBoule*sin(k*2*pi/N) + (yMilieuRec+(rBoule )) for k in [0..N-1] ]

#------------------VECTEUR DES DEUX POINTS DE LA CANNE---------------------#
p1 = vector([40,10,1])
p2 = vector([33,7,1])

#------------------CANNE---------------------#
L = [p1, p2]

#----------------- COORDONNEE HOMOGENE COMMUNE A TOUTES LES BOULES -----------------#
z = [1 for k in [0..N-1] ]

#-----------------FONCTION PERMETTANT DE CREER LA COLLECTION DE VECTEUR POUR CHAQUE BOULE -----------------#
def creationBoule(x,y,z) :
    return [ vector(RR, zip(x,y,z)[j]) for j in [0..len(x)-1] ]

#----------------- CREATION DE LA COLLECTION DE VECTEUR POUR CHAQUE BOULE -----------------#
BouleBlanche  = creationBoule(xBlanche, yBlanche, z)
BouleRouge  = creationBoule(xRouge, yRouge, z)
BouleBleu = creationBoule(xBleu, yBleu, z)
BouleJaune = creationBoule(xJaune,yJaune,z)

ListeDeplacement = [[BouleBlanche[0][0], BouleBlanche[0][1],BouleBlanche[10][0],BouleBlanche[10][1]]] #list coordonée rectangle

#----------------- FONCTION DE TRANSLATION BOULE -----------------#
def translationDirecteBoule (tx, ty, Color, r = 0, t = -(pi)/2) :
    if (Color == 'white'):
        global BouleBlanche
        Circle = BouleBlanche
    if (Color == 'red'):
        global BouleRouge
        Circle = BouleRouge
    if (Color == 'blue'):
        global BouleBleu
        Circle = BouleBleu
    if (Color == 'yellow'):
        global BouleJaune
        Circle = BouleJaune
    Mt  = matrix ( [[1, 0, tx], [0, 1, ty], [0,0,1]]) # Matrice de translation
    Mtot = Mt
    if ( r == 1) :
        centreX = ((Circle[0][0]+Circle[9][0])/2).n()
        centreY = ((Circle[0][1]+Circle[9][1])/2).n()
        M       = matrix ( [[cos(t), -sin(t), Mt[0][2]],[sin(t), cos(t), Mt[1][2]],[0, 0, 1]])
        MCplus  = matrix ( [[1, 0,centreX], [0, 1,centreY ], [0,0,1]])
        MCmoins  = matrix ( [[1, 0,-centreX], [0, 1,-centreY ], [0,0,1]])
        Mtot = MCplus * M * MCmoins
    Cercle   = [Mtot*Circle[j] for j in [0..N-1]] #Tracé de la boule
    if (Color == 'white'):
        global ListeDeplacement
        BouleBlanche = Cercle
        ListeDeplacement = ListeDeplacement + [[BouleBlanche[0][0], BouleBlanche[0][1],BouleBlanche[10][0],BouleBlanche[10][1]]]
    if (Color == 'red'):
        BouleRouge = Cercle
    if (Color == 'blue'):
        BouleBleu = Cercle
    if (Color == 'yellow'):
        BouleJaune = Cercle

    CircleTrace = [Cercle[j][0:2] for j in [0..N-1]] #2D
    return polygon(CircleTrace, fill=True, rgbcolor=Color, xmin=-3, xmax=cadre, ymin=-3, ymax=cadre/2)
#----------------- FIN FONCTION DE TRANSLATION BOULE -----------------#


#------------------ GESTION DES TRANSLATIONS DES BOULES EN FONCTION DE LEURS COULEURS ET DE L'INSTANT -------------------------------#

def GererDeplacementDesBoules (j,Color):
    j = j - 20;
    if Color == 'white':
        if j >= 0 and j <= 9:
            return translationDirecteBoule (-1,1, Color,1)
        if j > 9 and j <= 18:
             return translationDirecteBoule (-1,-1, Color,1)
        if j > 18 and j <=26:
            return translationDirecteBoule (1,-1, Color,1)
        if j > 26 and j <46:
            return translationDirecteBoule (1,0.90, Color,1)
        else:
            return translationDirecteBoule (0,0, Color)
    if Color == 'red':
        if j >= 18 and j <= 28:
            return translationDirecteBoule (-1,-1, Color)
        else:
            return translationDirecteBoule (0,0, Color)
    if Color == 'blue':
        if j >= 18 and j <= 26:
            return translationDirecteBoule (-1,-1.15, Color)
        else:
            return translationDirecteBoule (0,0, Color)
    if Color == 'yellow':
        if j >= 18 and j <= 26:
            return translationDirecteBoule (-1,1.15, Color)
        else:
            return translationDirecteBoule (0,0, Color)
    else :
        return translationDirecteBoule (0,0, Color)
#----------------- MATRICE DE TRANSLATION ET ROTATION CANNE ----------------------------------------#
MGlobal  = matrix ( [[cos(0), -sin(0), 0],[sin(0), cos(0), 0],[0, 0, 1]])

#----------------- FONCTION DE LA ROTATION DE LA CANNE ----------------------------------------#
def Rotation(t) :
    M = matrix ( [[cos(t), -sin(t), 0],[sin(t), cos(t), 0],[0, 0, 1]]) #Matrice de rotation
    global MGlobal #On recupère MGlobal

    MCplus  = matrix ( [[1, 0,p2[0]], [0, 1, p2[1]], [0,0,1]]) #Matrice de translation positive
    MCmoins  = matrix ( [[1, 0,-p2[0]], [0, 1, -p2[1]], [0,0,1]]) #Matrice de translation negative
    Mtot = MCplus * M * MCmoins #Multiplication des deux matrices de translation et de la matrice de rotation
    MGlobal = Mtot #Sauvegarde de Mtot
    Ltourne= [Mtot*L[j] for j in [0..1]] #Tracé
    LigneTrace = [Ltourne[j][0:2] for j in [0..1]] #2D
    return line(LigneTrace,color = 'black', thickness = 4)

#----------------- FONCTION DE LA TRANSLATION DE LA CANNE ------------------------------#
def translationQueu(tx, ty) :
    global MGlobal
    M = matrix ( [[MGlobal[0][0], MGlobal[0][1], MGlobal[0][2]+tx],[MGlobal[1][0], MGlobal[1][1], MGlobal[1][2]+ty],[0, 0, 1]])
    Ltourne = [M*L[j] for j in [0..1]]
    LigneTrace = [Ltourne[j][0:2] for j in [0..1]]
    return line(LigneTrace,color = 'black', thickness = 4)

#----------------- GESTION DE L'ANIMATION DE LA CANNE ----------------------------------------#
def GererAnimationRotation(j,L) :
    if (j <= 14):
        return Rotation (-(pi*(j*0.05)/2))
    elif(j >= 14 and j <= 20):
        return translationQueu(-((j-14) * 0.40), ((j-14) * 0.40))
    return translationQueu(((j-20)*0.65), -((j-20)*0.65))


QUEUE = [GererAnimationRotation((j),L) for j in sxrange (0.01,NbTick,1)]
animationQueue = animate(QUEUE, axes=False,  xmin=-3, xmax=cadre, ymin=-3, ymax=cadre/2)

#----------------- TRANSLATION ET ANIMATION DE LA BOULE BLANCHE -----------------#
TranslationBouleBlanche = [GererDeplacementDesBoules(j,'white') for j in sxrange (0.01,NbTick,1)]
animBouleBlanche   = animate(TranslationBouleBlanche, axes=False)

#----------------- TRANSLATION ET ANIMATION DE LA BOULE ROUGE -----------------#
TranslationBouleRouge = [GererDeplacementDesBoules(j,'red') for j in sxrange (0.01,NbTick,1)]
animBouleRouge   = animate(TranslationBouleRouge, axes=False)

#----------------- TRANSLATION ET ANIMATION DE LA BOULE BLEU -----------------#
TranslationBouleBleu = [GererDeplacementDesBoules(j,'blue') for j in sxrange (0.01,NbTick,1)]
animBouleBleu   = animate(TranslationBouleBleu, axes=False)

#----------------- TRANSLATION ET ANIMATION DE LA BOULE JAUNE -----------------#
TranslationBouleJaune = [GererDeplacementDesBoules(j,'yellow') for j in sxrange (0.01,NbTick,1)]
animBouleJaune   = animate(TranslationBouleJaune, axes=False)

#----------------- "ANIMATION" DU RECTANGLE -----------------#
rectangle = [polygoneRectangle for j in sxrange (0.01,NbTick,1)]
Tapis = animate(rectangle, axes=False)

#----------------- "ANIMATION" 2 DU RECTANGLE -----------------#

rectangle2 = [polygoneRectangleBordure for j in sxrange (0.01,NbTick,1)]
BordureDuBillard = animate (rectangle2, axes=False)

#----------------- ANIMATION STATIQUE DES 4 TROUS DU BILLARD -----------------#
trouBasGauche=circle((1,1), 1.3, color=('black'), fill=True)
basGauche = [trouBasGauche for j in sxrange (0.01,NbTick,1)]
animationFixeTrouBasGauche = animate(basGauche, axes=False)

trouBasDroit=circle((39,1), 1.3, color=('black'), fill=True)
BasDroit = [trouBasDroit for j in sxrange (0.01,NbTick,1)]
animationFixeTrouBasDroit = animate(BasDroit, axes=False)

trouHautDroit=circle((39,19), 1.3, color=('black'), fill=True)
HautDroit = [trouHautDroit for j in sxrange (0.01,NbTick,1)]
animationFixeTrouHautDroit = animate(HautDroit, axes=False)

trouHautGauche=circle((1,19), 1.3, color=('black'), fill=True)
HautGauche = [trouHautGauche for j in sxrange (0.01,NbTick,1)]
animationFixeTrouHautGauche = animate(HautGauche, axes=False)




def animatepRB(j):
    j = int(j)
    global ListeDeplacement
    j = j + 1
    return polygon2d([(ListeDeplacement[j][0], ListeDeplacement[j][1]),(ListeDeplacement[j][2], ListeDeplacement[j][3])], thickness=8,  color='orange')
rectangleBlanche = [animatepRB(j) for j in sxrange (Start, NbTick, 1)]
animRectangleBlanche = animate(rectangleBlanche)




BordureDuBillard + animationFixeTrouBasGauche + animationFixeTrouBasDroit + animationFixeTrouHautDroit + animationFixeTrouHautGauche + Tapis  + animBouleBlanche + animBouleBleu + animBouleJaune + animBouleRouge + animationQueue + animRectangleBlanche









