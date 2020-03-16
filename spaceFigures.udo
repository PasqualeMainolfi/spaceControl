//CONTROLLO DELLO SPAZIO IN 2 E 3 DIMENSIONI

//VECTOR BASED - FIGURE NELLO SPAZIO
//IN DUE DIMENSIONI

opcode toRad, k, k
kgradi xin
krad = kgradi * $M_PI/180
xout(krad)
endop

    opcode p2c, kk, kk //polar to cartesian
kraggio, kangle xin
kangle = toRad(kangle)
kx = kraggio * cos(kangle)
ky = kraggio * sin(kangle)
xout(kx, ky)
    endop

    opcode c2p, kk, kk //cartesian to polar
kx, ky xin
kraggio = sqrt(kx * kx + ky * ky)
kangle = taninv2(ky, kx) //in radianti
kangle = toRad(kangle)
xout(kraggio, kangle)
    endop

    opcode p3c, kkk, kkk //polar to cartesian spherical
kraggio, kele, kazi xin

kele = toRad(kele)
kazi = toRad(kazi)

kx = kraggio * cos(kele) * cos(kazi)
ky = kraggio * cos(kele) * sin(kazi)
kz = kraggio * sin(kele)
xout(kx, ky, kz)
    endop

    opcode c3p, kkk, kkk //cartesian to polar spherical
kx, ky, kz xin
kraggio = sqrt(kx * kx + ky * ky + kz * kz)
kele = taninv2(kz, sqrt(kx * kx + ky * ky))
kele = toRad(kele)
kazi = taninv2(ky, kx)
kazi = toRad(kazi)
xout(kraggio, kele, kazi)
    endop


    opcode spiral, kk, kkio //SPIRALE DI ARCHIMEDE
kraggio, iN, itime, imode xin

/*
iN = numero di giri della spirale (frequenza)
itime = tempo totale per completare iN giri
imode = default 0 ---> spirale verso l'esterno (crescente verso il raggio max) 1 ---> spirale verso l'interno (verso zero)
*/

i2pi = 2 * $M_PI
kangle = linseg:k(0, itime, 1) * i2pi

if(imode = 0) then
    krag = kraggio - (kraggio/(kraggio + kangle))
    krag = linseg:k(0, itime, 1) * ((kraggio - krag) + krag) //in modo da arrivare sempre alla massima ampiezza
    elseif(imode = 1) then
        krag = (kraggio/(kraggio + kangle))
        krag = linseg:k(1, itime, 0) * ((kraggio - krag) + krag)
    endif

kleft = (krag * cos(kangle * iN))
kright = (krag * sin(kangle * iN))

xout(kleft, kright)
    endop

    opcode circle, kk, kiio //CIRCOLARE
kraggio, iN, itime, imode xin

/*
kraggio = raggio
iN = numeri di giri 2π
itime = durata complessiva di iN giri
imode = default 0 ---> senso antiorario 1 ---> senso orario
*/

i2pi = 2 * $M_PI
kangle = linseg:k(0, itime, iN) * i2pi

if(imode = 1) then
    kangle = -kangle
endif

kleft = kraggio * cos(kangle)
kright = kraggio * sin(kangle)

xout(kleft, kright)
    endop

    opcode radonea, kk, kkii //RADONEA
kraggio, kk, iN, itime xin

/*
kraggio = kraggio
kk = fattore radonea
iN = frequenza
itime = durata totale
*/

i2pi = 2 * $M_PI
kangle = linseg:k(0, itime, 1) * i2pi
kraggio = kraggio * sin(kk * kangle * iN)

kleft =  kraggio * cos(kangle * iN)
kright = kraggio * sin(kangle * iN)

xout(kleft, kright)
    endop

    opcode ellisse, kk, kkii //ELLISSI
kmaj, kmin, iN, itime xin

/*
kmaj = asse maggiore
kmin = asse minore
iN = frequenza
itime = durata totale
*/

i2pi = 2 * $M_PI
kangle = linseg:k(0, itime, 1) * i2pi

kleft = kmaj * cos(kangle * iN)
kright = kmin * sin(kangle * iN)

xout(kleft, kright)
    endop


    opcode lissaj, kk, kkkkkkki //CURVE DI LISSAJOUS
krCos, knCos, kphCos, krSin, knSin, kphSin, kn, itime xin

i2pi = 2 * $M_PI
kangle = linseg:k(0, itime, 1) * (i2pi * kn)

kx = krCos * cos(kangle * knCos + kphCos)
ky = krSin * sin(kangle * knSin + kphSin)

xout(kx, ky)
    endop


//IN TRE DIMENSIONI

    opcode conic3c, kkk, kkk //coniche to cartesian
kraggio, kA, kh xin

/*
kraggio = raggio
kA = azimuth 0 < A < 1
kh = altezza 0 < h < 1
*/

i2pi = 2 * $M_PI
kA = kA * i2pi

kx = kraggio * cos(kA)
ky = kraggio * sin(kA)
kz = kh

xout(kx, ky, kz)
    endop

    opcode conic3p, kkk, kkk //coniche catertesiane to polar
kx, ky, kz xin

kraggio = sqrt(kx * kx + ky * ky)
kA = taninv2(ky, kx)
kh = kz

xout(kraggio, kA, kh)
    endop

    opcode sphere3c, kkk, kkk //sferiche to cartesian
kraggio, kA, kh xin

/*
kraggio = raggio
kA = azimuth 0 < A < 1
kh = altezza 0 < h < 1 0 = tutto in basso, .5 = a metà altezza, 1 = tutto in alto
*/

i2pi = 2 * $M_PI

kA = kA * i2pi
kh = (kh * $M_PI) - $M_PI_2

kx = kraggio * cos(kh) * cos(kA)
ky = kraggio * cos(kh) * sin(kA)
kz = kraggio * sin(kh)

xout(kx, ky, kz)
    endop

    opcode sphere3p, kkk, kkk //sferiche catertesiane to polar
kx, ky, kz xin

kraggio = sqrt(kx * kx + ky * ky + kz * kz)
kh = taninv2(kz, sqrt(kx * kx + ky * ky))
kA = taninv2(ky, kx)

xout(kraggio, kA, kh)
    endop

    opcode ellissoide, kkk, kkkkk //ellissoide
ka, kb, kc, kA, kh xin

/*
ka = lunghezza asse x
kb = lunghezza asse y
kc = lunghezza asse z

ka > kb > kc ---> ellissoide scaleno
ka > kb = kc ---> sferoide prolato
ka = kb > kc ---> sferoide oblato
ka = kb = kc ---> sfera

kA = azimuth 0 < A < 1 (0 <---> 2π)
kh = elevazione 0 < h < 1 (0 <---> π)
*/

i2pi = 2 * $M_PI

kA = kA * i2pi
kh = (kh * $M_PI) - $M_PI_2

kx = ka * cos(kh) * cos(kA)
ky = kb * cos(kh) * sin(kA)
kz = kc * sin(kh)

xout(kx, ky, kz)
    endop


//TRASFORMAZIONI IN 2 E 3 DIMENSIONI

    opcode rotate2d, kk, kkk
kx, ky, kangle xin

//kangle = multipli di 2π

kangle = kangle * (2 * $M_PI)
kx = kx * cos(kangle) - ky * sin(kangle)
ky = kx * sin(kangle) + ky * cos(kangle)

xout(kx, ky)
    endop

    opcode traslate2d, kk, kkkk
kx, ky, kxt, kyt xin
//kxt, kyt = vettore di traslazione
kx += kxt
ky += kyt
xout(kx, ky)
    endop

    opcode scale2d, kk, kkkk
kx, ky, ka, kb xin

/*
ka, kb = fattori di scale per x e y
*/

kx = kx * ka
ky = ky * kb

xout(kx, ky)
    endop


    opcode rotate3d, kkk, kkkkkk
kx, ky, kz, kxa, kya, kza xin

/*
kxa, kya, kza = angolo di rotazione mulipli di 2π
*/

kxa = kxa * (2 * $M_PI)
kya = kya * (2 * $M_PI)
kza = kza * (2 * $M_PI)

kxx = kx
kyx = ky * cos(kxa) - kz * sin(kxa)
kzx = ky * sin(kxa) + kz * cos(kxa)

kxy = kxx * cos(kya) + kzx * sin(kya)
kyy = kyx
kzy = -kxx * sin(kya) + kzx * cos(kya)

kxz = kxy * cos(kza) - kyy * sin(kza)
kyz = kxy * sin(kza) + kyy * cos(kza)
kzz = kzy

xout(kxz, kyz, kzz)
    endop

    opcode scale3d, kkk, kkkkkk
kx, ky, kz, ka, kb, kc xin

/*
ka, kb, kc = fattori di scale per x, y e z
*/

kx = kx * ka
ky = ky * kb
kz = kz * kc

xout(kx, ky, kz)
    endop

    opcode translate3d, kkk, kkkkkk
kx, ky, kz, kxtra, kytra, kztra xin

kx += kxtra
ky += kytra
kz += kztra

xout(kx, ky, kz)
    endop
