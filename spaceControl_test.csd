<CsoundSynthesiser>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 1
nchnls = 2
0dbfs = 1

#include "spaceFigures.udo"
#include "spaceControl.udo"


//COORDINATE IN 2D

	instr Circle

kraggio = .7
iN = 10 //numero totale di giri
itime = p3 //durata totale in cui compiere gli n giri
imode = 0 //senso di rotazione

kx, ky circle kraggio, iN, itime, imode

outvalue("x", kx)
outvalue("y", ky)

	endin

	instr Spirale

kraggio = 1
iN = 10 //numero totale di giri ---> dal numero di giri dipende la densità della spirale
itime = p3 //durata totale in cui compiere gli n giri
imode = 0 //senso di rotazione

kx, ky spiral kraggio, iN, itime, imode

	endin

	instr Radonea

kraggio = .7
kk = 5 //fattore radonea ---> numero di petali = kk pari ---> 2 * kk, kk dispari ---> kk petali
iN = 2 //numero totale di giri
itime = p3 //durata totale in cui compiere gli n giri

kx, ky radonea kraggio, kk, iN, itime

outvalue("x", kx)
outvalue("y", ky)

	endin

	instr Ellisse

kmaj = .7 //asse maggiore
kmin = .3 //asse minore
iN = 10 //numero totale di giri
itime = p3 //durata totale in cui compiere gli n giri

kx, ky ellisse kmaj, kmin, iN, itime

outvalue("x", kx)
outvalue("y", ky)

	endin


//IN 3D

	instr Sphere

kraggio = .9 //raggio
kA = linseg:k(0, 3, 10) //azimuth
kh = linseg:k(0, 3, 1) //elevazione

kx, ky, kz sphere3c kraggio, kA, kh

outvalue("x", kx)
outvalue("y", ky)
outvalue("z", kz)

	endin

	instr Ellissoide

ka = .9 //asse x
kb = .7 //asse y
kc = .5 //asse z
kA = linseg:k(0, 3, 1) //azimuth
kh = linseg:k(.5, 3, .5) //elevazione

kx, ky, kz ellissoide ka, kb, kc, kA, kh

outvalue("x", kx)
outvalue("y", ky)
outvalue("z", kz)

	endin

	instr Conica

kraggio = .9 //raggio
kA = linseg:k(0, 3, 1) //azimuth
kh = linseg:k(.3, 3, .3) //elevazione

kx, ky, kz conic3c kraggio, kA, kh

outvalue("x", kx)
outvalue("y", ky)
outvalue("z", kz)

	endin

	instr Transform

kraggio = .9 //raggio
kA = linseg:k(0, 3, 1) //azimuth
kh = linseg:k(.5, 3, .5) //elevazione

kangleX = 1/8 //rotazione sull'asse x (valori da 0 a 1 ---> 0 a 2π)
kangleY = 0 //rotazione sull'asse y (valori da 0 a 1 ---> 0 a 2π)
kangleZ = 0 //rotazione sull'asse z (valori da 0 a 1 ---> 0 a 2π)

kscaleX = 1 //fattore di scalatura x
kscaleY = 1 //fattore di scalatura y
kscaleZ = 1 //fattore di scalatura z

ktranslateX = 0 //coordinata di traslazione x
ktranslateY = 0 //coordinata di traslazione y
ktranslateZ = 0 //coordinata di traslazione z

kx, ky, kz sphere3c kraggio, kA, kh

kx, ky, kz rotate3d kx, ky, kz, kangleX, kangleY, kangleZ //rotazione
kx, ky, kz scale3d kx, ky, kz, kscaleX, kscaleY, kscaleZ //scalatura
kx, ky, kz translate3d kx, ky, kz, ktranslateX, ktranslateY, ktranslateZ //traslazione


outvalue("x", kx)
outvalue("y", ky)
outvalue("z", kz)


	endin


//METODI DI PANNING

	instr Space1 //test 4 - 8 channel

a1 = poscil:a(linseg:k(0, 1, 1), 120)
kazi = linseg:k(0, 3, 3 * 360, 3, 0) //in gradi Azimuth da 0° a n * 360° (in esempio un giro completo di circonferenza)
ispkPos[] = fillarray(0, 45, 90, 135, 180, 225, 270, 315)
ispk[] = fillarray(0, 90, 180, 270)

a4Enc[] = space2d_encode(a1, kazi)
a4Dec[] = ambi2d_8_decode(a4Enc[0], a4Enc[1], a4Enc[2], ispkPos, 5) //modo 1

a1, a2, a3, a4 vecQuad a1, kazi, ispk, linseg:k(10, 6, 100) //modo 2

 outvalue("01", rms(a1))
 outvalue("02", rms(a2))
 outvalue("03", rms(a3))
 outvalue("04", rms(a4))

 outvalue("1", rms(a4Dec[0]))
 outvalue("2", rms(a4Dec[1]))
 outvalue("3", rms(a4Dec[2]))
 outvalue("4", rms(a4Dec[3]))
 outvalue("5", rms(a4Dec[4]))
 outvalue("6", rms(a4Dec[5]))
 outvalue("7", rms(a4Dec[6]))
 outvalue("8", rms(a4Dec[7]))

	endin


	instr Space2 //with spiral

kraggio = 1
iN = 10 //numero totale di giri ---> dal numero di giri dipende la densità della spirale
itime = p3 //durata totale in cui compiere gli n giri
imode = 0 //senso di rotazione

kx, ky spiral kraggio, iN, itime, imode //SPIRALE

asource = poscil(.7, 120)

//componenti w, x ed y
aw = asource
ax = asource * kx
ay = asource * ky

ispkPos[] = fillarray(0, 90, 180, 270) //in gradi
a4Dec[] = ambi2d_4_decode(aw, ax, ay, ispkPos, 25)
;a4Dec[] = ambi2d_basic_decode(asource, ax, ay, 25)

;outvalue("x", kx)
;outvalue("y", ky)

 outvalue("01", rms(a4Dec[0]))
 outvalue("02", rms(a4Dec[1]))
 outvalue("03", rms(a4Dec[2]))
 outvalue("04", rms(a4Dec[3]))

	endin


	instr Space3

kraggio = 10 ;massima distanza raggio spirale in metri
iN = 10 //numero totale di giri ---> dal numero di giri dipende la densità della spirale
itime = p3 //durata totale in cui compiere gli n giri
imode = 0 //senso di rotazione

a1 = butbp(rand:a(.9), 7000, 900)

ispkPos[] = fillarray(0, 90, 180, 270)

kx, ky spiral kraggio, iN, itime, imode //SPIRALE

asource, kazi encDist_a a1, kx, ky //codifica della distanza e dell'assorbimento dell'aria a partire dalle cartesiane
aSound[] = space2d_encode(asource, kazi) //codifica delle tre componenti
a4Dec[] = ambi2d_4_decode(aSound[0], aSound[1], aSound[2], ispkPos, 1) //decodifica


 outvalue("01", rms(a4Dec[0]))
 outvalue("02", rms(a4Dec[1]))
 outvalue("03", rms(a4Dec[2]))
 outvalue("04", rms(a4Dec[3]))

; outvalue("01", rms(a1))
; outvalue("02", rms(a2))
; outvalue("03", rms(a3))
; outvalue("04", rms(a4))

outvalue("x", kx)
outvalue("y", ky)

	dispfft(aSound[0], .1, 2048)

	endin


	instr Space4

a1 = poscil(.7, 120)
kazi = linseg:k(0, 3, 240)

kspkPos[] = fillarray(-30, 30, 120, -120)

a4[] = vecDistPan_4(a1, kazi, kspkPos) //utilizzo della distanza tra sorgente e speakers per il calcolo dei pesi

 outvalue("01", rms(a4[0]))
 outvalue("02", rms(a4[1]))
 outvalue("03", rms(a4[2]))
 outvalue("04", rms(a4[3]))

	endin

	instr Space5 //ambi 16 ch

asource = poscil(1, 120)

kx, ky, kz sphere3c 1, linseg:k(0, 3, 5), linseg:k(0, 3, 1) //NOTA I CERCHI VERTICALI
as[] = ambi3d_16_xyz(asource, kx, ky, kz)

outvalue("x", kx)
outvalue("y", ky)
outvalue("z", kz)

 outvalue("1", rms(as[0]))
 outvalue("2", rms(as[1]))
 outvalue("3", rms(as[2]))
 outvalue("4", rms(as[3]))
 outvalue("5", rms(as[4]))
 outvalue("6", rms(as[5]))
 outvalue("7", rms(as[6]))
 outvalue("8", rms(as[7]))
 outvalue("9", rms(as[8]))
 outvalue("10", rms(as[9]))
 outvalue("11", rms(as[10]))
 outvalue("12", rms(as[11]))
 outvalue("13", rms(as[12]))
 outvalue("14", rms(as[13]))
 outvalue("15", rms(as[14]))
 outvalue("16", rms(as[15]))

	endin



</CsInstruments>
<CsScore>

;i "SimplePan" 0 3
;i "Circle" 0 3
;i "Spirale" 0 10
;i "Radonea" 0 10
;i "Ellisse" 0 3
;i "Sphere" 0 3
;i "Ellissoide" 0 3
;i "Conica" 0 3
;i "Transform" 0 3

;i "Space1" 0 10
;i "Space2" 0 10
;i "Space3" 0 10
;i "Space4" 0 10
i "Space5" 0 10

</CsScore>
</CsoundSynthesiser>
