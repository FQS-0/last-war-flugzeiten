# s: Entfernung des Fluges [su]
# t: Zeit des gesamten Fluges [h]
# v_faktor: Geschwindigkeitsfaktor -> 20% bis 160%
# v_max: Höchstgeschwindigkeit [su/h]
# t_to_v_max: Zeit bis zum Erreichen der Höchstgeschwindigkeit [h]
# t_warmup: Verzögerung bis zum Start [h]
# verbrauch: Furozinverbrauch des gesamten Fluges [Frurozin/1000btns]
# verbrauch_max: Frurozinverbrauch bis zum Erreichen der Höchstgeschwindigkeit pro 1000btns [Frurozin/1000btns]
# verbrauch_pro_su: Frurozinverbrauch pro su pro 1000btns ab Erreichen der Höchstgeschwindigkeit [Frurozin/su/1000btns]

t(s, v_faktor, v_max, t_to_v_max, t_warmup) = ((s - 0.75) < v_max * v_faktor * t_to_v_max) \
            ? 2 * sqrt((s - 0.75) / 2 / (0.5 * v_max * v_faktor / t_to_v_max)) + t_warmup \
            : t_to_v_max + t_warmup + (s - 0.75) / (v_max * v_faktor)

verbrauch(s, v_faktor, v_max, t_to_v_max, verbrauch_max, verbrauch_pro_su) = (s < v_max * v_faktor * t_to_v_max) \
            ? sqrt(s / (v_max * v_faktor / t_to_v_max)) / t_to_v_max * verbrauch_max * v_faktor \
            : verbrauch_max * v_faktor + (s - v_max * t_to_v_max) * verbrauch_pro_su * v_faktor

# Parameter für Nuk-Antriebe
vmax_nuk = 10
t_to_vmax_nuk = 1
t_wu_nuk = 1
verbrauch_nuk_max = 50

# Parameter für Ion-Antriebe
vmax_ion = 25 
t_to_vmax_ion = 2
t_wu_ion = 2.5
verbrauch_ion_max = 20 # Fruro pro 1000btns

# Parameter für Hyp-Antriebe
vmax_hyp = 500
t_to_vmax_hyp = 0.125
t_wu_hyp = 4.5
verbrauch_hyp_max = 200 # Fruro pro 1000btns
verbrauch_hyp_su = 0.25 # Fruro pro su pro 1000btns

set style line 1 lc rgb 'dark-red'
set style line 2 lc rgb 'dark-red' dt 2
set style line 3 lc rgb 'dark-red' dt 3
set style line 4 lc rgb 'dark-green'
set style line 5 lc rgb 'dark-green' dt 2
set style line 6 lc rgb 'dark-green' dt 3
set style line 7 lc rgb 'dark-blue'
set style line 8 lc rgb 'dark-blue' dt 2
set style line 9 lc rgb 'dark-blue' dt 3
set style line 10 lc rgb 'orange'

set terminal pngcairo size 800,600 enhanced font 'Verdana,10'

set title 'Flugzeiten innerhalb einer Galaxie'
set xrange [1:100]
set xlabel 'Entfernung in su'
set yrange [0:10]
set ylabel 'Zeit in Stunden'
set key right bottom
set ytics 1
set xtics 10
set output 'flugzeiten-galaintern.png'

plot t(x, 1, vmax_nuk, t_to_vmax_nuk, t_wu_nuk) t 'Nuk 100%' ls 1,  \
     t(x, 1.3, vmax_nuk, t_to_vmax_nuk, t_wu_nuk) t 'Nuk 130%' ls 2, \
     t(x, 1.6, vmax_nuk, t_to_vmax_nuk, t_wu_nuk) t 'Nuk 160%' ls 3, \
     t(x, 1, vmax_ion, t_to_vmax_ion, t_wu_ion) t 'Ion 100%' ls 4, \
     t(x, 1.3, vmax_ion, t_to_vmax_ion, t_wu_ion) t 'Ion 130%' ls 5, \
     t(x, 1.6, vmax_ion, t_to_vmax_ion, t_wu_ion) t 'Ion 160%' ls 6, \
     t(x, 1, vmax_hyp, t_to_vmax_hyp, t_wu_hyp) t 'Hyp 100%' ls 7, \
     4.5 t 'Gty' ls 10

set output 'vergleich-flugzeiten-galaintern.png'

plot t(x, 1, vmax_nuk, t_to_vmax_nuk, t_wu_nuk) t 'Nuk 100%' ls 1,  \
     t(x, 1.3, vmax_nuk, t_to_vmax_nuk, t_wu_nuk) t 'Nuk 130%' ls 2, \
     t(x, 1.6, vmax_nuk, t_to_vmax_nuk, t_wu_nuk) t 'Nuk 160%' ls 3, \
     t(x, 1, vmax_ion, t_to_vmax_ion, t_wu_ion) t 'Ion 100%' ls 4, \
     t(x, 1.3, vmax_ion, t_to_vmax_ion, t_wu_ion) t 'Ion 130%' ls 5, \
     t(x, 1.6, vmax_ion, t_to_vmax_ion, t_wu_ion) t 'Ion 160%' ls 6, \
     t(x, 1, vmax_hyp, t_to_vmax_hyp, t_wu_hyp) t 'Hyp 100%' ls 7, \
     4.5 t 'Gty' ls 10, \
     'flugzeiten-galaintern.txt' using 1:2 t 'Nuk 100% PHP' ls 1, \
     'flugzeiten-galaintern.txt' using 1:3 t 'Nuk 130% PHP' ls 2, \
     'flugzeiten-galaintern.txt' using 1:4 t 'Nuk 160% PHP' ls 3, \
     'flugzeiten-galaintern.txt' using 1:5 t 'Ion 160% PHP' ls 4, \
     'flugzeiten-galaintern.txt' using 1:6 t 'Ion 130% PHP' ls 5, \
     'flugzeiten-galaintern.txt' using 1:7 t 'Ion 160% PHP' ls 6, \
     'flugzeiten-galaintern.txt' using 1:8 t 'Hyp 100% PHP' ls 7, \
     'flugzeiten-galaintern.txt' using 1:9 t 'Gty 100% PHP' ls 10


set title 'Flugzeiten außerhalb einer Galaxie'
set xrange [1:2500]
set xtics 250
set yrange [0:10]
set output 'flugzeiten-galaextern.png'

plot t(x, 1, vmax_hyp, t_to_vmax_hyp, t_wu_hyp) t 'Hyp 100%' ls 7, \
     t(x, 1.3, vmax_hyp, t_to_vmax_hyp, t_wu_hyp) t 'Hyp 130%' ls 8, \
     t(x, 1.6, vmax_hyp, t_to_vmax_hyp, t_wu_hyp) t 'Hyp 160%' ls 9, \
     4.5 t 'Gty' ls 10

set output 'vergleich-flugzeiten-galaextern.png'

plot t(x, 1, vmax_hyp, t_to_vmax_hyp, t_wu_hyp) t 'Hyp 100%' ls 7, \
     t(x, 1.3, vmax_hyp, t_to_vmax_hyp, t_wu_hyp) t 'Hyp 130%' ls 8, \
     t(x, 1.6, vmax_hyp, t_to_vmax_hyp, t_wu_hyp) t 'Hyp 160%' ls 9, \
     4.5 t 'Gty' ls 10, \
     'flugzeiten-galaextern.txt' using 1:2 t 'Hyp 100% PHP' ls 7, \
     'flugzeiten-galaextern.txt' using 1:3 t 'Hyp 130% PHP' ls 8, \
     'flugzeiten-galaextern.txt' using 1:4 t 'Hyp 160% PHP' ls 9, \
     'flugzeiten-galaextern.txt' using 1:5 t 'Gty 100% PHP' ls 10

set title 'Treibstoffverbrauch innerhalb einer Galaxie'
set xrange [1:100]
set xlabel 'Entfernung in su'
set yrange [0:300]
set ylabel 'Treibstoffverbrauch in Frurozin pro 1000btns'
set key center top
set ytics 20
set xtics 10
set output 'verbrauch-galaintern.png'

plot verbrauch(x, 1, vmax_nuk, t_to_vmax_nuk, verbrauch_nuk_max, 0) t 'Nuk 100%' ls 1,  \
     verbrauch(x, 1.3, vmax_nuk, t_to_vmax_nuk, verbrauch_nuk_max, 0) t 'Nuk 130%' ls 2, \
     verbrauch(x, 1.6, vmax_nuk, t_to_vmax_nuk, verbrauch_nuk_max, 0) t 'Nuk 160%' ls 3, \
     verbrauch(x, 1, vmax_ion, t_to_vmax_ion, verbrauch_ion_max, 0) t 'Ion 100%' ls 4, \
     verbrauch(x, 1.3, vmax_ion, t_to_vmax_ion, verbrauch_ion_max, 0) t 'Ion 130%' ls 5, \
     verbrauch(x, 1.6, vmax_ion, t_to_vmax_ion, verbrauch_ion_max, 0) t 'Ion 160%' ls 6, \
     verbrauch(x, 1, vmax_hyp, t_to_vmax_hyp, verbrauch_hyp_max, verbrauch_hyp_su) t 'Hyp 100%' ls 7

set output 'vergleich-verbrauch-galaintern.png'

plot verbrauch(x, 1, vmax_nuk, t_to_vmax_nuk, verbrauch_nuk_max, 0) t 'Nuk 100%' ls 1,  \
     verbrauch(x, 1.3, vmax_nuk, t_to_vmax_nuk, verbrauch_nuk_max, 0) t 'Nuk 130%' ls 2, \
     verbrauch(x, 1.6, vmax_nuk, t_to_vmax_nuk, verbrauch_nuk_max, 0) t 'Nuk 160%' ls 3, \
     verbrauch(x, 1, vmax_ion, t_to_vmax_ion, verbrauch_ion_max, 0) t 'Ion 100%' ls 4, \
     verbrauch(x, 1.3, vmax_ion, t_to_vmax_ion, verbrauch_ion_max, 0) t 'Ion 130%' ls 5, \
     verbrauch(x, 1.6, vmax_ion, t_to_vmax_ion, verbrauch_ion_max, 0) t 'Ion 160%' ls 6, \
     verbrauch(x, 1, vmax_hyp, t_to_vmax_hyp, verbrauch_hyp_max, verbrauch_hyp_su) t 'Hyp 100%' ls 7, \
     'verbrauch-galaintern.txt' using 1:2 t 'Nuk 100% PHP' ls 1, \
     'verbrauch-galaintern.txt' using 1:3 t 'Nuk 130% PHP' ls 2, \
     'verbrauch-galaintern.txt' using 1:4 t 'Nuk 160% PHP' ls 3, \
     'verbrauch-galaintern.txt' using 1:5 t 'Ion 100% PHP' ls 4, \
     'verbrauch-galaintern.txt' using 1:6 t 'Ion 130% PHP' ls 5, \
     'verbrauch-galaintern.txt' using 1:7 t 'Ion 160% PHP' ls 6, \
     'verbrauch-galaintern.txt' using 1:8 t 'Hyp 100% PHP' ls 7

set title 'Treibstoffverbrauch außerhalb einer Galaxie'
set xrange [1:2500]
set xtics 250
set yrange [0:1500]
set ytics 100
set output 'verbrauch-galaextern.png'

plot \
     verbrauch(x, 1, vmax_hyp, t_to_vmax_hyp, verbrauch_hyp_max, verbrauch_hyp_su) t 'Hyp 100%' ls 7, \
     verbrauch(x, 1.3, vmax_hyp, t_to_vmax_hyp, verbrauch_hyp_max, verbrauch_hyp_su) t 'Hyp 130%' ls 8, \
     verbrauch(x, 1.6, vmax_hyp, t_to_vmax_hyp, verbrauch_hyp_max, verbrauch_hyp_su) t 'Hyp 160%' ls 9, \
     1000 t 'Gty' ls 10


set output 'vergleich-verbrauch-galaextern.png'

plot \
     verbrauch(x, 1, vmax_hyp, t_to_vmax_hyp, verbrauch_hyp_max, verbrauch_hyp_su) t 'Hyp 100%' ls 7, \
     verbrauch(x, 1.3, vmax_hyp, t_to_vmax_hyp, verbrauch_hyp_max, verbrauch_hyp_su) t 'Hyp 130%' ls 8, \
     verbrauch(x, 1.6, vmax_hyp, t_to_vmax_hyp, verbrauch_hyp_max, verbrauch_hyp_su) t 'Hyp 160%' ls 9, \
     1000 t 'Gty' ls 10, \
     'verbrauch-galaextern.txt' using 1:2 t 'Hyp 100% PHP' ls 7, \
     'verbrauch-galaextern.txt' using 1:3 t 'Hyp 130% PHP' ls 8, \
     'verbrauch-galaextern.txt' using 1:4 t 'Hyp 160% PHP' ls 9, \
     'verbrauch-galaextern.txt' using 1:5 t 'Gty 100% PHP' ls 10
