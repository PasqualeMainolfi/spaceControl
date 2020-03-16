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
;
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
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBController">
  <objectName>x</objectName>
  <x>13</x>
  <y>9</y>
  <width>273</width>
  <height>269</height>
  <uuid>{93bc7652-db2d-4f6c-a7ff-e3afb2c4e267}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>y</objectName2>
  <xMin>-1.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>-1.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>-0.00000000</yValue>
  <type>point</type>
  <pointsize>7</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>y</objectName>
  <x>291</x>
  <y>9</y>
  <width>273</width>
  <height>269</height>
  <uuid>{7a08c2ad-bfd5-4888-9a6a-923ac22448f2}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>z</objectName2>
  <xMin>-1.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>-1.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>-0.00000000</xValue>
  <yValue>1.00000000</yValue>
  <type>point</type>
  <pointsize>7</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>988</x>
  <y>75</y>
  <width>42</width>
  <height>145</height>
  <uuid>{14bd8f70-a9c8-4891-921e-479cca4ee029}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>1</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.70674548</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1053</x>
  <y>102</y>
  <width>42</width>
  <height>145</height>
  <uuid>{1c648a54-f66e-4917-b139-0dc1100deff5}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>2</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>917</x>
  <y>99</y>
  <width>42</width>
  <height>145</height>
  <uuid>{2aee1077-329c-4a22-b840-9b827b072b84}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>3</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>855</x>
  <y>232</y>
  <width>42</width>
  <height>145</height>
  <uuid>{7fb9c722-54f1-49c9-8753-1b5cf8d25682}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>4</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.70674548</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>925</x>
  <y>359</y>
  <width>42</width>
  <height>145</height>
  <uuid>{6734265d-82db-4457-a6c8-e51852613f44}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>5</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>988</x>
  <y>383</y>
  <width>42</width>
  <height>145</height>
  <uuid>{734f27df-260b-4fc2-8083-ee36ba0ac115}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>6</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1050</x>
  <y>367</y>
  <width>42</width>
  <height>145</height>
  <uuid>{55cea9d0-4a00-4ef7-b822-1187b7c5fc75}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>7</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.70674548</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1110</x>
  <y>241</y>
  <width>42</width>
  <height>145</height>
  <uuid>{5e613a36-9949-453e-ae27-e74aaa8cb135}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>8</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>752</x>
  <y>103</y>
  <width>42</width>
  <height>145</height>
  <uuid>{045d5203-f19c-48ef-a235-104f7774bb1c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>01</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>610</x>
  <y>103</y>
  <width>42</width>
  <height>145</height>
  <uuid>{5f2f3a21-ba9c-4710-8e88-6a41e0d50c55}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>02</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00791801</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>616</x>
  <y>363</y>
  <width>42</width>
  <height>145</height>
  <uuid>{62a102ca-3f05-4d25-b411-58e81af5a955}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>03</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00672140</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>756</x>
  <y>362</y>
  <width>42</width>
  <height>145</height>
  <uuid>{1fff3845-9f0b-4fd5-befd-86b1317a1253}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>04</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.18199799</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>578</x>
  <y>69</y>
  <width>251</width>
  <height>461</height>
  <uuid>{614ba960-8757-4412-913d-d4ef248dddc0}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>4 CH</label>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>835</x>
  <y>59</y>
  <width>341</width>
  <height>492</height>
  <uuid>{65f45b8a-d76f-4ac7-8e1e-e2fb7b34a8a6}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>8 CH</label>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBGraph">
  <objectName/>
  <x>11</x>
  <y>283</y>
  <width>554</width>
  <height>323</height>
  <uuid>{adcc17c9-3247-4dd8-b49e-511e5a1a55b4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <value>0</value>
  <objectName2/>
  <zoomx>1.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <modex>lin</modex>
  <modey>lin</modey>
  <all>true</all>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1195</x>
  <y>170</y>
  <width>42</width>
  <height>145</height>
  <uuid>{27b04598-358c-4c30-be99-7dcf5dd286f6}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>1</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.70674548</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1244</x>
  <y>170</y>
  <width>42</width>
  <height>145</height>
  <uuid>{93f2ba9f-bbec-4af7-a87e-b24e339505d6}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>2</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1294</x>
  <y>170</y>
  <width>42</width>
  <height>145</height>
  <uuid>{01f92e3f-a3dc-4499-a738-91a3c63d5269}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>3</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1343</x>
  <y>170</y>
  <width>42</width>
  <height>145</height>
  <uuid>{3113c370-7dab-41d0-a7e7-28531d596760}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>4</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.70674548</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1394</x>
  <y>172</y>
  <width>42</width>
  <height>145</height>
  <uuid>{93a08797-fb8e-4432-b6f5-d789953cdd9f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>5</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1488</x>
  <y>174</y>
  <width>42</width>
  <height>145</height>
  <uuid>{1fd70ce6-f5cf-459b-a0db-bb9c108745fd}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>6</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1535</x>
  <y>175</y>
  <width>42</width>
  <height>145</height>
  <uuid>{a758ec74-0db4-4ec2-b313-d11c447ea91f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>7</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.70674548</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1442</x>
  <y>173</y>
  <width>42</width>
  <height>145</height>
  <uuid>{f5c6792c-dc9d-4cfb-8cf3-e76dfa2c4cb6}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>8</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>1183</x>
  <y>132</y>
  <width>409</width>
  <height>354</height>
  <uuid>{74487f73-982e-4ab2-b75d-5a0e15f9884b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <label>16 CH AMBI</label>
  <alignment>left</alignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>border</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1197</x>
  <y>324</y>
  <width>42</width>
  <height>145</height>
  <uuid>{2b221cbc-8df5-4abc-ac0c-892f0da7b3c0}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>9</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1246</x>
  <y>324</y>
  <width>42</width>
  <height>145</height>
  <uuid>{12342b6f-9bd1-4e32-94ac-280cfaaa06d0}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>10</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1296</x>
  <y>324</y>
  <width>42</width>
  <height>145</height>
  <uuid>{a68aacd1-4b46-4033-9208-4b99ba317a94}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>11</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1345</x>
  <y>324</y>
  <width>42</width>
  <height>145</height>
  <uuid>{deed3f7b-e037-4bd6-b094-9ca3510eb4ff}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>12</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1396</x>
  <y>326</y>
  <width>42</width>
  <height>145</height>
  <uuid>{31f87adf-2e29-4abf-a16d-20002b60d82b}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>13</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.70674548</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1490</x>
  <y>328</y>
  <width>42</width>
  <height>145</height>
  <uuid>{aa9245c3-1b10-4f59-a271-be6c3f6f4a45}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>15</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1537</x>
  <y>329</y>
  <width>42</width>
  <height>145</height>
  <uuid>{0e6dc5f8-852a-4222-80ee-7c25bc0b88a1}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>16</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor2</objectName>
  <x>1444</x>
  <y>327</y>
  <width>42</width>
  <height>145</height>
  <uuid>{7b6c05bb-1584-408a-9f45-e5624ba167df}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <objectName2>14</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </bgcolor>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
