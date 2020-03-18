//SPACE CONTROL - VECTOR BASED

/*

g1 = (teta2 - tetaPan)/(teta2 - teta1) //gain channel 1
g2 = (tetaPan - teta1)/(teta2 - teta1) //gain channel 2

teta2 > tetaPan > teta1


LINEAR PANNING:

0 < angle < π/2

L(angle) = (π/2 - angle)·2/π
R(angle) = teta·2/π

CONSTANT POWER PANNING:

L(angle) = cos(teta)
R(angle) = sin(teta)

-4.5 dB PAN LAW:

L(angle) = sqrt((π/2 - angle)·cos(angle))
R(angle) = sqrt(angle·(2/π)·sin(angle))
*/

//***************************************************
//***************************************************
//***************************************************

//IN 2D

    opcode toRad, k, k
kgradi xin
krad = kgradi * $M_PI/180
xout(krad)
    endop

    opcode toDeg, k, k
krad xin
kdeg = krad * 180/$M_PI
xout(kdeg)
    endop

    opcode pLinear, aa, ak //LINEAR PANNING
asource, kpan xin

/*
aource = sorgente
kpan = 0 ---> right, 1 ---> left
*/

kangle = kpan * $M_PI_2
kleft = ($M_PI_2 - kangle) * 2/$M_PI
kright = kangle * 2/$M_PI

a1 = asource * kleft
a2 = asource * kright

xout(a1, a2)
    endop

    opcode pCostant, aa, ak //COSTANT POWER PANNING
asource, kpan xin

a1 = asource * cos(kpan * $M_PI_2)
a2 = asource * sin(kpan * $M_PI_2)

xout(a1, a2)
    endop

    opcode pComp, aa, ak //-4.5 PAN LAW -COMPROMESSO-
asource, kpan xin

kangle = kpan * $M_PI_2
kl1 = ($M_PI_2 - kangle) * 2/$M_PI
kr1 = kangle * 2/$M_PI

kleft = sqrt(kl1 * (2/$M_PI) * cos(kangle))
kright = sqrt(kr1 * (2/$M_PI) * sin(kangle))

a1 = asource * kleft
a2 = asource * kright

xout(a1, a2)
    endop


    opcode squareQuad, aaaa, ak //SIMPLE QUAD PAN SQUARE ROOT METHOD
asource, kpan xin

/*
aource = aorgente in
kpan = 0 ---> speaker 1, 1 ---> speaker 2, 2 ---> speaker 3, 3 ---> speaker 4
*/

if(kpan >= 0 && kpan <= 1) then
    ka = sqrt(1 - kpan)
    kb = sqrt(kpan)
    kc = 0
    kd = 0
    elseif(kpan > 1 && kpan <= 2) then
        ka = 0
        kb = sqrt(2 - kpan)
        kc = sqrt(kpan - 1)
        kd = 0
        elseif(kpan > 2 && kpan <= 3) then
            ka = 0
            kb = 0
            kc = sqrt(3 - kpan)
            kd = kpan - 2
            elseif(kpan > 3 && kpan <= 4) then
                ka = sqrt(kpan - 3)
                kb = 0
                kc = 0
                kd = sqrt(4 - kpan)
            endif

asource = asource * (sqrt(2)/2)

a1 = asource * ka
a2 = asource * kb
a3 = asource * kc
a4 = asource * kd

xout(a1, a2, a3, a4)
    endop


    opcode vecQuad, aaaa, aki[]k
asource, kazi, ispkDeg[], kperc xin

/*
asource = sorgente
kazi = azimuth in gradi, valore positivo da 0 a 360°
ispkDeg[] = posizione in gradi degli speaker
kperc = SPREAD in percentuale. Percentuale di suono su tutti gli altri altoparlanti -tutti accesi- 100% sorgente su tutti i canali
*/

kazi = kazi%360
kazi = toRad(kazi)
ispkDeg[] = ispkDeg * $M_PI/180
ifac = 1/sqrt(2)
kperc = kperc/100
a0 = (asource * ifac) * kperc
ax = asource * cos(kazi) * (1 - kperc)
ay = asource * sin(kazi) * (1 - kperc)

if(kazi < ispkDeg[1] && kazi > ispkDeg[0]) then
    a1 = ax * cos(ispkDeg[0]) + ay * sin(ispkDeg[0]) + a0
    a2 = ax * cos(ispkDeg[1]) + ay * sin(ispkDeg[1]) + a0
    a3 = a0
    a4 = a0
    elseif(kazi < ispkDeg[2] && kazi > ispkDeg[1]) then
        a1 = a0
        a2 = ax * cos(ispkDeg[1]) + ay * sin(ispkDeg[1]) + a0
        a3 = ax * cos(ispkDeg[2]) + ay * sin(ispkDeg[2]) + a0
        a4 = a0
        elseif(kazi < ispkDeg[3] && kazi > ispkDeg[2]) then
            a1 = a0
            a2 = a0
            a3 = ax * cos(ispkDeg[2]) + ay * sin(ispkDeg[2]) + a0
            a4 = ax * cos(ispkDeg[3]) + ay * sin(ispkDeg[3]) + a0
            elseif(kazi > ispkDeg[3]) then
                a1 = ax * cos(ispkDeg[0]) + ay * sin(ispkDeg[0]) + a0
                a2 = a0
                a3 = a0
                a4 = ax * cos(ispkDeg[3]) + ay * sin(ispkDeg[3]) + a0
            endif
xout(a1, a2, a3, a4)
    endop



    opcode space2d_encode, a[], ak //first order encoder (w, x, y)
asource, kazim xin
kazim = toRad(kazim)
aouts[] init 3
aouts[0] = asource //componente w
aouts[1] = asource * cos(kazim) //componente x
aouts[2] = asource * sin(kazim) //compoenete y
xout(aouts)
    endop

    opcode ambi2d_basic_decode, a[], aaak //basic ambisonic decoder FL - FR - BL - BR
aw, ax, ay, kperc xin

aouts[] init 4

ifac = 1/sqrt(2)
kperc = kperc/100
aw = aw * kperc
ax = ax * (1 - kperc)
ay = ay * (1 - kperc)

aouts[0] = (aw + ax + ay) * ifac //front left
aouts[1] = (aw - ax + ay) * ifac //back left
aouts[2] = (aw - ax - ay) * ifac //back right
aouts[3] = (aw + ax - ay) * ifac //front right

xout(aouts)
    endop

    opcode ambi2d_4_decode, a[], aaai[]k //4 channels decode
aw, ax, ay, ispkDeg[], kperc xin

/*
aw = source
a1 = componente x
a2 = componente y
ispkDeg[] = posizione in gradi degli speaker
kperc = SPREAD. percentuale della componente w su tutti gli altoparlanti
*/

aouts[] init 4
ispkDeg[] = ispkDeg * $M_PI/180

ifac = sqrt(2)/2
kperc = kperc/100
aw = aw * kperc
ax = ax * (1 - kperc)
ay = ay * (1 - kperc)

aouts[0] = (aw + cos(ispkDeg[0]) * ax + sin(ispkDeg[0]) * ay) * ifac
aouts[1] = (aw + cos(ispkDeg[1]) * ax + sin(ispkDeg[1]) * ay) * ifac
aouts[2] = (aw + cos(ispkDeg[2]) * ax + sin(ispkDeg[2]) * ay) * ifac
aouts[3] = (aw + cos(ispkDeg[3]) * ax + sin(ispkDeg[3]) * ay) * ifac

xout(aouts)
    endop

    opcode ambi2d_8_decode, a[], aaai[]k //8 channels decode
aw, ax, ay, ispkDeg[], kperc xin

/*
aw = source
a1 = componente x
a2 = componente y
ispkDeg[] = posizione in gradi degli speaker
kperc = SPREAD. percentuale della componente w su tutti gli altoparlanti
*/

aouts[] init 8
ispkDeg[] = ispkDeg * ($M_PI/180)
ifac = sqrt(2)/2
kperc = kperc/100
aw = aw * kperc
ax = ax * (1 - kperc)
ay = ay * (1 - kperc)

aouts[0] = (aw + cos(ispkDeg[0]) * ax + sin(ispkDeg[0]) * ay) * ifac
aouts[1] = (aw + cos(ispkDeg[1]) * ax + sin(ispkDeg[1]) * ay) * ifac
aouts[2] = (aw + cos(ispkDeg[2]) * ax + sin(ispkDeg[2]) * ay) * ifac
aouts[3] = (aw + cos(ispkDeg[3]) * ax + sin(ispkDeg[3]) * ay) * ifac
aouts[4] = (aw + cos(ispkDeg[4]) * ax + sin(ispkDeg[4]) * ay) * ifac
aouts[5] = (aw + cos(ispkDeg[5]) * ax + sin(ispkDeg[5]) * ay) * ifac
aouts[6] = (aw + cos(ispkDeg[6]) * ax + sin(ispkDeg[6]) * ay) * ifac
aouts[7] = (aw + cos(ispkDeg[7]) * ax + sin(ispkDeg[7]) * ay) * ifac

xout(aouts)
    endop

    opcode encDist_a, ak, akk // codifica della distanza supponendo il centro il punto più vicino (from cartesian)
asource, kx, ky xin

/*
asource = sorgente
kx, ky = cartesiane
in uscita ---> sorgente e azimuth per la codifica
*/

kdist = sqrt(kx * kx + ky * ky)
kd = 1 - (1 - exp(-kdist * 2))
kazi = taninv2(ky, kx)
kazi = toDeg((kazi < 0 ? kazi + $M_PI : kazi)) //evitare valori negativi
aout = tone(5 * asource * kd, 18000 * exp(-.1 * kd)) //simulazione assorbimento dell'aria

xout(aout, kazi)
    endop

    opcode encDist_xy, kk, kk //CODIFICA DELLA DISTANZA E DELL'AZIMUTH A PARTIRE DALLE CARTESIANE
kx, ky xin

kdist = sqrt(kx * kx + ky * ky)
kd = 1 - (1 - exp(-kdist * 2))
kazi = taninv2(ky, kx)
kazi = toDeg((kazi < 0 ? kazi + $M_PI : kazi)) //TUTTO POSITIVO

xout(kd, kazi)
    endop

    opcode assorb, a, ak //SIMULAZIONE ASSORBIMENTO ARIA
asource, kdist xin
aout = tone:a(5 * asource * kdist, 18000 * exp(-.1 * kdist))
xout(aout)
    endop

    opcode dop, a, ak //EFFETTO DOPPLER
asource, kdist xin
ivel = 1/343.8

adel delayr .5
    adoppler = deltapi(interp(kdist) * ivel + .01)
        delayw(asource)

xout(adoppler)
    endop


//UTILIZZO DELLA DISTANZA TRA SORGENTE VIRTUALE ED ALTOPARLANTI PER IL CALCOLO DEI PESI
    opcode vecDistPan_4, a[], akk[] //DISTANCE-BASED AMPLITUDE PANNING
asource, kazi, kspkPos[] xin

ifac = 1/sqrt(2)
kspkPos[] = kspkPos * $M_PI/180
kazi = toRad(kazi)

ilen = lenarray:i(kspkPos)
kspk_x[] init ilen //speaker position
kspk_y[] init ilen

kx = cos(kazi)
ky = sin(kazi)

ki init 0
until (ki == ilen) do
    kspk_x[ki] = cos(kspkPos[ki])
    kspk_y[ki] = sin(kspkPos[ki])
    ki += 1
od

kdx[] = kspk_x - kx //calcolo della distanza istantanea tra sorgente ed altoparlanti componente x
kdy[] = kspk_y - ky //calcolo della distanza istantanea tra sorgente ed altoparlanti componente y
kdist[] = sqrt(kdx * kdx + kdy * kdy + .5^2) //calcolo magnitudine
kg[] = 1 - (1 - exp(-kdist * 2)) //inverso della distanza al quadrato per il calcolo pesi

kcx[] = kg * kspk_x
kcy[] = kg * kspk_y

ax = asource * kx
ay = asource * ky

aouts[] init ilen
aouts[0] = ax * kcx[0] + ay * kcy[0]
aouts[1] = ax * kcx[1] + ay * kcy[1]
aouts[2] = ax * kcx[2] + ay * kcy[2]
aouts[3] = ax * kcx[3] + ay * kcy[3]

xout(aouts)
    endop


//***************************************************
//***************************************************
//***************************************************

//IN 3D

    opcode ambi3d_4, a[], akk //1° order a partire da azimuth ed elevazione
asource, kazi, kele xin

/*
asource = sorgente
kazi = azimuth in gradi
kele = angolo di elevazione in gradi
*/

kazi = toRad(kazi)
kele = toRad(kele)

aw = asource
ax = asource * cos(kele) * cos(kazi)
ay = asource * cos(kele) * sin(kazi)
az = asource * sin(kele)

awxyz[] init 4
awxyz[0] = aw
awxyz[1] = ax
awxyz[2] = ay
awxyz[3] = az

xout(awxyz)
    endop

    opcode ambi3d_16_decode, a[], akk // 3° order a partire da azimuth ed elevazione
asource, kazi, kele xin

kazi = toRad(kazi)
kele = toRad(kele)

ach[] init 16

aw = asource
ach[0] = aw
ach[1] = aw * cos(kele) * cos(kazi)
ach[2] = aw * cos(kele) * sin(kazi)
ach[3] = aw * sin(kele)
ach[4] = aw * sqrt(3/4) * sin(2 * kazi) * (cos(kele))^2
ach[5] = aw * sqrt(3/4) * sin(kazi) * sin(2 * kele)
ach[6] = aw * (1/2) * (3 * (sin(kele))^2 - 1)
ach[7] = aw * sqrt(3/4) * cos(kazi) * sin(2 * kele)
ach[8] = aw * sqrt(3/4) * cos(2 * kazi) * (cos(kele))^2
ach[9] = aw * sqrt(5/8) * sin(3 * kazi) * (cos(kele))^3
ach[10] = aw * sqrt(15/4) * sin(2 * kazi) * sin(kele) * (cos(kele))^2
ach[11] = aw * sqrt(3/8) * sin(kazi) * cos(kele) * (5 * (sin(kele))^2 - 1)
ach[12] = aw * (1/2) * sin(kele) * (5 * (sin(kele))^2 - 3)
ach[13] = aw * sqrt(3/8) * cos(kazi) * cos(kele) * (5 * (sin(kele))^2 - 1)
ach[14] = aw * sqrt(15/4) * cos(2 * kazi) * sin(kele) * (cos(kele))^2
ach[15] = aw * sqrt(5/8) * cos(3 * kazi) * (cos(kele))^3

xout(ach)
    endop


    opcode ambi3d_4_xyz, a[], akkk //DECODIFICA A 4 CANALI A PARTIRE DALLE CARTESIANE PER IL CONTROLLO DELLO SPAZIO
asource, kx, ky, kz xin

ach[] init 4

aw = asource
ach[0] = aw
ach[1] = aw * kx
ach[2] = aw * ky
ach[3] = aw * kz

xout(ach)
    endop

    opcode ambi3d_16_xyz, a[], akkk //DECODIFICA A 16 CANALI A PARTIRE DALLE CARTESIANE PER IL CONTROLLO DELLO SPAZIO
asource, kx, ky, kz xin

ach[] init 16

aw = asource
ach[0] = aw
ach[1] = aw * kx
ach[2] = aw * ky
ach[3] = aw * kz
ach[4] = aw * sqrt(3) * kx * ky
ach[5] = aw * sqrt(3) * ky * kz
ach[6] = aw * (1/2) * (3 * kz^2 - 1)
ach[7] = aw * sqrt(3) * kx * kz
ach[8] = aw * sqrt(3/4) * (kx^2 - ky^2)
ach[9] = aw * sqrt(5/8) * ky * (3 * kx^2 - ky^2)
ach[10] = aw * sqrt(15) * kx * ky * kz
ach[11] = aw * sqrt(3/8) * ky * (5 * kz^2 - 1)
ach[12] = aw * (1/2) * kz * (5 * kz^2 - 3)
ach[13] = aw * sqrt(3/8) * kx * (5 * kz^2 - 1)
ach[14] = aw * sqrt(15/4) * kz * (kx^2 - ky^2)
ach[15] = aw * sqrt(5/8) * kx * (kx^2 - 3 * ky^2)

xout(ach)
    endop
